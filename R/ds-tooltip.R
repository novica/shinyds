#' Tooltip
#'
#' Add a tooltip to an element by attaching `data-tooltip` attributes.
#'
#' @param tag The element to attach the tooltip to.
#' @param text The tooltip text.
#' @param placement Tooltip placement: `"top"`, `"bottom"`, `"left"`,
#'   or `"right"`.
#'
#' @return The element with tooltip attributes added.
#' @export
#'
#' @examples
#' ds_tooltip(
#'   ds_button("Hover me"),
#'   text = "This is helpful information"
#' )
ds_tooltip <- function(tag, text, placement = "top") {
  tag <- htmltools::tagAppendAttributes(
    tag,
    `data-tooltip` = text,
    `data-tooltip-placement` = placement
  )
  htmltools::attachDependencies(tag, ds_dependencies())
}
