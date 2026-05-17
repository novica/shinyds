#' Tooltip
#'
#' Add a tooltip to an element using the data-tooltip attribute.
#'
#' @param element The element to attach the tooltip to
#' @param text The tooltip text
#' @param placement Tooltip placement ("top", "bottom", "left", "right")
#'
#' @return The element with tooltip attributes added
#' @export
#'
#' @examples
#' ds_tooltip(
#'   ds_button("Hover me"),
#'   text = "This is helpful information"
#' )
ds_tooltip <- function(element, text, placement = "top") {
  element <- htmltools::tagAppendAttributes(
    element,
    `data-tooltip` = text,
    `data-tooltip-placement` = placement
  )
  htmltools::attachDependencies(element, ds_dependencies())
}
