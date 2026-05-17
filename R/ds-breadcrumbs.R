#' Breadcrumbs Component
#'
#' Create a breadcrumb navigation trail.
#'
#' @param ... Child elements (typically list items with links)
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_breadcrumbs(
#'   htmltools::tags$ol(
#'     htmltools::tags$li(ds_link("Home", href = "/")),
#'     htmltools::tags$li(ds_link("Products", href = "/products")),
#'     htmltools::tags$li(htmltools::tags$span("Current Page"))
#'   )
#' )
ds_breadcrumbs <- function(..., class = NULL) {
  tag <- htmltools::tag("ds-breadcrumbs", list(
    class = .ds_classes("ds-breadcrumbs", class),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}
