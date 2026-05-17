#' Alert Component
#'
#' Create an alert message using Designsystemet styles.
#'
#' @param ... Alert content
#' @param variant Alert variant ("info", "warning", "danger", "success")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_alert("This is an informational message.", variant = "info")
#' ds_alert("Warning: Please review before continuing.", variant = "warning")
#' ds_alert("Error: Something went wrong.", variant = "danger")
#' ds_alert("Success! Your changes were saved.", variant = "success")
ds_alert <- function(..., variant = c("info", "warning", "danger", "success"),
                     class = NULL) {

  variant <- match.arg(variant)

  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-alert", class),
    `data-variant` = variant,
    role = "alert",
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}
