#' Designsystemet Dependencies
#'
#' Returns the HTML dependencies required for Designsystemet components.
#'
#' @return A list of htmltools htmlDependency objects
#' @export
#'
#' @examples
#' ds_dependencies()
ds_dependencies <- function() {
  list(
    # CSS from @digdir/designsystemet-css
    htmltools::htmlDependency(
      name = "designsystemet-css",
      version = "1.19.1",
      src = system.file("www/css", package = "shinyds"),
      stylesheet = "designsystemet.min.css"
    ),

    # Web components from @digdir/designsystemet-web (UMD bundle)
    htmltools::htmlDependency(
      name = "designsystemet-web",
      version = "1.19.1",
      src = system.file("www/js", package = "shinyds"),
      script = "designsystemet-web.umd.js"
    ),

    # Shiny input bindings (hand-written)
    # ds-bindings-generated.js not loaded — conflicts with hand-written bindings until audited.
    htmltools::htmlDependency(
      name = "designsystemet-bindings",
      version = utils::packageVersion("shinyds"),
      src = system.file("www/js", package = "shinyds"),
      script = "ds-bindings.js"
    )
  )
}

#' Use Designsystemet in a Shiny App
#'
#' Include this function in your UI to load all necessary Designsystemet
#' CSS and JavaScript dependencies.
#'
#' @param color_scheme Color scheme to apply to the page. One of `"light"` or
#'   `"dark"`. Sets the `data-color-scheme` attribute on `<html>`, which
#'   activates Designsystemet's CSS custom property tokens.
#'
#' @return A tagList containing the dependencies
#' @export
#'
#' @examples
#' ui <- bslib::page_fluid(
#'   use_designsystemet(),
#'   ds_button("Click me", inputId = "btn")
#' )
use_designsystemet <- function(color_scheme = "light") {
  htmltools::tagList(
    ds_dependencies(),
    htmltools::tags$script(htmltools::HTML(sprintf(
      'document.documentElement.setAttribute("data-color-scheme", "%s");',
      color_scheme
    )))
  )
}

#' Designsystemet Theme
#'
#' Override Designsystemet CSS tokens for color, typography, and spacing.
#' Call inside your UI alongside [use_designsystemet()].
#'
#' Color palette tokens follow the Designsystemet naming convention. Use
#' `data-color="brand2"` on a container to switch its color context, or set
#' `color` here to change the global default.
#'
#' @param color Global color context. One of `"default"`, `"brand1"`,
#'   `"brand2"`, `"neutral"`, `"success"`, `"warning"`, `"danger"`, `"info"`.
#'   Sets `data-color` on `<html>`.
#' @param font_size Base font size as a CSS value (e.g. `"16px"`, `"1rem"`).
#'   Overrides `--ds-font-size-base` on `:root`.
#' @param border_radius Border radius as a CSS value (e.g. `"4px"`, `"0"`).
#'   Overrides `--ds-border-radius-md` on `:root`.
#' @param button_padding Padding for buttons as a CSS shorthand
#'   (e.g. `"0.4rem 0.9rem"`). Overrides `--dsc-button-padding` on `:root`.
#' @param ... Named CSS custom property overrides in the form
#'   `"--ds-token-name" = "value"`. Applied to `:root`.
#'
#' @return A `<style>` tag applied to `:root` and optionally a JS snippet to
#'   set `data-color` on `<html>`.
#' @export
#'
#' @examples
#' ui <- bslib::page_fluid(
#'   use_designsystemet(),
#'   ds_theme(color = "brand1", border_radius = "2px", button_padding = "0.3rem 0.8rem"),
#'   ds_button("Click me", inputId = "btn")
#' )
ds_theme <- function(color = NULL,
                     font_size = NULL,
                     border_radius = NULL,
                     button_padding = NULL,
                     ...) {
  tokens <- list(...)

  if (!is.null(font_size))     tokens[["--ds-font-size-base"]]    <- font_size
  if (!is.null(border_radius)) tokens[["--ds-border-radius-md"]]  <- border_radius
  if (!is.null(button_padding)) tokens[["--dsc-button-padding"]]  <- button_padding

  tags <- list()

  if (length(tokens) > 0) {
    props <- paste(
      sprintf("  %s: %s;", names(tokens), unlist(tokens)),
      collapse = "\n"
    )
    css <- sprintf(":root {\n%s\n}", props)
    tags <- c(tags, list(htmltools::tags$style(htmltools::HTML(css))))
  }

  if (!is.null(color)) {
    js <- sprintf('document.documentElement.setAttribute("data-color", "%s");', color)
    tags <- c(tags, list(htmltools::tags$script(htmltools::HTML(js))))
  }

  do.call(htmltools::tagList, tags)
}
