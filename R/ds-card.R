#' Card Component
#'
#' Create a styled card container using Designsystemet styles.
#'
#' @param ... Child elements
#' @param variant Card variant ("default", "tinted")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_card(
#'   ds_card_block(
#'     ds_heading("Card Title", level = 3),
#'     ds_paragraph("Card content goes here.")
#'   )
#' )
ds_card <- function(..., variant = NULL, class = NULL) {
  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-card", class),
    `data-variant` = variant,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Card Block
#'
#' A block section within a card with proper padding.
#'
#' @param ... Child elements
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_card_block(ds_paragraph("Card content."))
ds_card_block <- function(..., class = NULL) {
  htmltools::tag("div", list(
    class = .ds_classes("ds-card__block", class),
    ...
  ))
}
