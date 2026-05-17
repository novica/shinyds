#' List Component
#'
#' Create a styled list using Designsystemet styles.
#'
#' @param ... List items
#' @param ordered If TRUE, creates an ordered list
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_list(
#'   ds_list_item("First item"),
#'   ds_list_item("Second item"),
#'   ds_list_item("Third item")
#' )
ds_list <- function(..., ordered = FALSE, class = NULL) {
  tag_name <- if (ordered) "ol" else "ul"
  tag <- htmltools::tag(tag_name, list(
    class = .ds_classes("ds-list", class),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' List Item
#'
#' Create a list item.
#'
#' @param ... Item content
#'
#' @return A Shiny tag object
#' @export
ds_list_item <- function(...) {
  htmltools::tag("li", list(...))
}
