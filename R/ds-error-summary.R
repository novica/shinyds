#' Error Summary Component
#'
#' Display a summary of form validation errors.
#'
#' @param ... Error list items
#' @param heading The heading text for the error summary
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_error_summary(
#'   heading = "There were errors in the form",
#'   htmltools::tags$li(ds_link("Name is required", href = "#name")),
#'   htmltools::tags$li(ds_link("Email is invalid", href = "#email"))
#' )
ds_error_summary <- function(..., heading = "Feil i skjema", class = NULL) {
  tag <- htmltools::tag("ds-error-summary", list(
    class = .ds_classes("ds-error-summary", class),
    htmltools::tag("h2", list(heading)),
    htmltools::tag("ul", list(...))
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}
