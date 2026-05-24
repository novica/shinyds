#!/usr/bin/env Rscript
# tools/bootstrap-registry.R
# ===========================
# Reads custom-elements.json from the designsystemet build and compares the
# web components it defines against the entries already in component-registry.yaml.
#
# Outputs:
#   - Components present in the JSON but missing from the registry
#     (new upstream additions you need to add)
#   - Components present in the registry but absent from the JSON
#     (removed upstream or renamed)
#   - With --write: appends skeletal YAML entries for new components to the registry
#
# Usage (run from package root):
#   Rscript tools/bootstrap-registry.R
#   Rscript tools/bootstrap-registry.R --write

library(yaml)
library(jsonlite)

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------

get_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("--file=", args, value = TRUE)
  if (length(file_arg) > 0) {
    return(dirname(normalizePath(sub("--file=", "", file_arg))))
  }
  if (file.exists("tools/component-registry.yaml")) return(normalizePath("tools"))
  if (file.exists("component-registry.yaml"))       return(normalizePath("."))
  stop("Run from the package root or tools/ directory.")
}

TOOLS_DIR        <- get_script_dir()
PACKAGE_ROOT     <- dirname(TOOLS_DIR)
REGISTRY_PATH    <- file.path(TOOLS_DIR, "component-registry.yaml")
CUSTOM_ELEM_PATH <- file.path(
  PACKAGE_ROOT, "..", "designsystemet", "packages", "web", "dist", "custom-elements.json"
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

tag_to_key <- function(tag) {
  # ds-error-summary -> error_summary
  key <- sub("^ds-", "", tag)
  gsub("-", "_", key)
}

load_registry_tags <- function(registry) {
  tags <- character()
  for (name in names(registry$web_components)) {
    tag <- registry$web_components[[name]]$tag
    if (!is.null(tag)) tags <- c(tags, tag)
    # Also collect sub-element tags
    for (sub in registry$web_components[[name]]$sub_elements %||% list()) {
      if (!is.null(sub$tag)) tags <- c(tags, sub$tag)
    }
  }
  unique(tags)
}

extract_custom_element_tags <- function(ce) {
  tags <- character()
  for (mod in ce$modules %||% list()) {
    for (decl in mod$declarations %||% list()) {
      tag <- decl$tagName
      if (!is.null(tag) && nchar(tag) > 0) tags <- c(tags, tag)
    }
  }
  unique(tags)
}

extract_attributes <- function(ce, tag) {
  for (mod in ce$modules %||% list()) {
    for (decl in mod$declarations %||% list()) {
      if (identical(decl$tagName, tag)) {
        return(decl$attributes %||% list())
      }
    }
  }
  list()
}

# ---------------------------------------------------------------------------
# YAML skeleton builder
# ---------------------------------------------------------------------------

build_yaml_entry <- function(tag, attrs) {
  key <- tag_to_key(tag)

  entry <- list(
    tag     = tag,
    binding = "none"
  )

  if (length(attrs) > 0) {
    entry$attributes <- lapply(attrs, function(a) {
      r_param <- gsub("-", "_", a$name)
      typ <- trimws(a$type$text %||% "string")
      # Map TS types to registry types
      reg_type <- if (grepl("\\|", typ)) "enum"
                  else if (grepl("^boolean", typ)) "boolean"
                  else if (grepl("^number|^int", typ)) "integer"
                  else "string"
      item <- list(name = a$name, r_param = r_param, type = reg_type)
      if (!is.null(a$description) && nchar(a$description) > 0)
        item$description <- a$description
      # Extract enum values from "a | b | c" type text
      if (reg_type == "enum") {
        vals <- trimws(strsplit(typ, "\\|")[[1]])
        vals <- gsub('^"|"$|^\'|\'$', "", vals)  # strip quotes
        vals <- vals[nchar(vals) > 0]
        if (length(vals) > 0) item$values <- as.list(vals)
      }
      item
    })
  }

  setNames(list(entry), key)
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

`%||%` <- function(a, b) if (is.null(a)) b else a

args      <- commandArgs(trailingOnly = TRUE)
do_write  <- "--write" %in% args

if (!file.exists(REGISTRY_PATH)) stop("Registry not found: ", REGISTRY_PATH)
if (!file.exists(CUSTOM_ELEM_PATH)) {
  cat("custom-elements.json not found at:\n  ", CUSTOM_ELEM_PATH, "\n")
  cat("Build the upstream first: cd ../designsystemet && pnpm build\n")
  quit(status = 1)
}

registry <- yaml::read_yaml(REGISTRY_PATH)
ce       <- jsonlite::fromJSON(CUSTOM_ELEM_PATH, simplifyVector = FALSE)

registry_tags <- load_registry_tags(registry)
ce_tags       <- extract_custom_element_tags(ce)

new_tags     <- setdiff(ce_tags, registry_tags)
removed_tags <- setdiff(registry_tags, ce_tags)
common_tags  <- intersect(ce_tags, registry_tags)

cat("=== bootstrap-registry report ===\n\n")
cat("Upstream tags in custom-elements.json : ", length(ce_tags), "\n")
cat("Registry tags in component-registry.yaml:", length(registry_tags), "\n")
cat("Common (already registered)            : ", length(common_tags), "\n\n")

if (length(removed_tags) > 0) {
  cat("REMOVED from upstream (", length(removed_tags), ") — review and delete from registry:\n", sep = "")
  for (t in sort(removed_tags)) cat("  -", t, "\n")
  cat("\n")
}

if (length(new_tags) == 0) {
  cat("No new web components found — registry is up to date.\n")
} else {
  cat("NEW in upstream (", length(new_tags), ") — skeletal entries below:\n\n", sep = "")

  new_entries <- list()
  for (tag in sort(new_tags)) {
    attrs <- extract_attributes(ce, tag)
    entry <- build_yaml_entry(tag, attrs)
    new_entries <- c(new_entries, entry)

    # Print human-readable YAML for this entry
    cat("---\n# web_components entry for", tag, "\n")
    cat(yaml::as.yaml(entry))
    cat("\n")
  }

  if (do_write) {
    cat("Writing ", length(new_entries), " new entries to registry...\n", sep = "")
    registry$web_components <- c(registry$web_components, new_entries)
    yaml::write_yaml(registry, REGISTRY_PATH)
    cat("Done: ", REGISTRY_PATH, "\n")
  } else {
    cat("Re-run with --write to append these entries to component-registry.yaml.\n")
  }
}
