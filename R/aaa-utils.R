#' @importFrom htmltools tag tagList attachDependencies HTML htmlDependency
#' @importFrom shiny getDefaultReactiveDomain
NULL


#' Internal: Combine class names
#'
#' @param ... Class names (can be NULL)
#' @keywords internal
.ds_classes <- function(...) {
  classes <- c(...)
  classes <- classes[!is.null(classes) & classes != ""]
  if (length(classes) == 0) return(NULL)
  paste(classes, collapse = " ")
}
