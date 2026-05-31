#' Tabs Component
#'
#' Create a tabbed interface using Designsystemet tabs.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param ... Child elements (typically ds_tablist and ds_tabpanel elements)
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_tabs("mytabs",
#'   ds_tablist(
#'     ds_tab("First", value = "tab1", selected = TRUE),
#'     ds_tab("Second", value = "tab2")
#'   ),
#'   ds_tabpanel(value = "tab1", "Content 1"),
#'   ds_tabpanel(value = "tab2", "Content 2")
#' )
ds_tabs <- function(inputId, ..., class = NULL) {
  tag <- htmltools::tag("ds-tabs", list(
    id = inputId,
    class = .ds_classes("ds-tabs", "ds-shiny-input", class),
    ...

  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Tab List Container
#'
#' Container for tab buttons within ds_tabs.
#'
#' @param ... Child elements (ds_tab elements)
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_tablist(
#'   ds_tab("First", value = "tab1", selected = TRUE),
#'   ds_tab("Second", value = "tab2")
#' )
ds_tablist <- function(..., class = NULL) {
  htmltools::tag("ds-tablist", list(
    class = class,
    ...
  ))
}

#' Tab Button
#'
#' A single tab button within ds_tablist.
#'
#' @param label The tab label text
#' @param value The value to return when this tab is selected
#' @param selected Whether this tab is initially selected
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_tab("Overview", value = "overview", selected = TRUE)
ds_tab <- function(label, value, selected = FALSE, ...) {
  htmltools::tag("ds-tab", list(
    `data-value` = value,
    `aria-selected` = if (selected) "true" else NULL,
    label,
    ...
  ))
}

#' Tab Panel
#'
#' Content panel for a tab.
#'
#' @param ... Panel content
#' @param value The value that matches the corresponding ds_tab
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_tabpanel(value = "overview", ds_paragraph("Content here."))
ds_tabpanel <- function(..., value, class = NULL) {
  htmltools::tag("ds-tabpanel", list(
    `data-value` = value,
    class = class,
    ...
  ))
}

#' Update Tabs Input
#'
#' Change the selected tab from the server.
#'
#' @param session The Shiny session object
#' @param inputId The input ID of the tabs component
#' @param selected The value of the tab to select
#'
#' @return Called for its side effect. Returns \code{NULL} invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' update_ds_tabs(session, "my_tabs", selected = "overview")
#' }
update_ds_tabs <- function(session = shiny::getDefaultReactiveDomain(),
                           inputId, selected = NULL) {
  message <- list(selected = selected)
  message <- Filter(Negate(is.null), message)
  session$sendInputMessage(inputId, message)
}
