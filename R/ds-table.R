#' Table Component
#'
#' Create a styled table using Designsystemet styles.
#'
#' @param ... Table content (thead, tbody, etc.)
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_table(
#'   ds_thead(
#'     ds_tr(
#'       ds_th("Name"),
#'       ds_th("Email")
#'     )
#'   ),
#'   ds_tbody(
#'     ds_tr(
#'       ds_td("John Doe"),
#'       ds_td("john@example.com")
#'     )
#'   )
#' )
ds_table <- function(..., size = NULL, class = NULL) {
  tag <- htmltools::tag("table", list(
    class = .ds_classes("ds-table", class),
    `data-size` = size,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Table Header
#'
#' Create a table header section.
#'
#' @param ... Header rows
#'
#' @return A Shiny tag object
#' @export
ds_thead <- function(...) {
  htmltools::tag("thead", list(...))
}

#' Table Body
#'
#' Create a table body section.
#'
#' @param ... Body rows
#'
#' @return A Shiny tag object
#' @export
ds_tbody <- function(...) {
  htmltools::tag("tbody", list(...))
}

#' Table Row
#'
#' Create a table row.
#'
#' @param ... Row cells
#'
#' @return A Shiny tag object
#' @export
ds_tr <- function(...) {
  htmltools::tag("tr", list(...))
}

#' Table Header Cell
#'
#' Create a table header cell.
#'
#' @param ... Cell content
#' @param scope Cell scope ("col", "row")
#'
#' @return A Shiny tag object
#' @export
ds_th <- function(..., scope = "col") {
  htmltools::tag("th", list(scope = scope, ...))
}

#' Table Data Cell
#'
#' Create a table data cell.
#'
#' @param ... Cell content
#'
#' @return A Shiny tag object
#' @export
ds_td <- function(...) {
  htmltools::tag("td", list(...))
}
