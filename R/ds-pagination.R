#' Pagination Component
#'
#' Create a pagination component for navigating through pages.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param current The current page number (1-indexed)
#' @param total The total number of pages
#' @param label Accessibility label for the pagination nav
#' @param href Optional URL template for page links (use \code{sprintf} style, e.g. "page?p=1")
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_pagination("mypage", current = 1, total = 10)
ds_pagination <- function(inputId, current = 1, total,
                          label = "Sidenavigasjon",
                          href = NULL, ...) {
  tag <- htmltools::tag("ds-pagination", list(
    id = inputId,
    class = "ds-pagination ds-shiny-input",
    `aria-label` = label,
    `data-current` = current,
    `data-total` = total,
    `data-href` = href,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Update Pagination Input
#'
#' Change the current page or total pages from the server.
#'
#' @param session The Shiny session object
#' @param inputId The input ID of the pagination component
#' @param current The new current page number
#' @param total The new total number of pages
#'
#' @export
update_ds_pagination <- function(session = shiny::getDefaultReactiveDomain(),
                                  inputId, current = NULL, total = NULL) {
  message <- list(current = current, total = total)
  message <- Filter(Negate(is.null), message)
  session$sendInputMessage(inputId, message)
}
