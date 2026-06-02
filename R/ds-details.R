#' Details/Accordion Component
#'
#' Create an expandable details section using Designsystemet styles.
#'
#' @param summary The summary/title text shown when collapsed
#' @param ... Content shown when expanded
#' @param open If TRUE, the details are initially open
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_details(
#'   summary = "Click to expand",
#'   ds_paragraph("Hidden content goes here.")
#' )
ds_details <- function(summary, ..., open = FALSE, class = NULL) {
  tag <- htmltools::tag("details", list(
    class = .ds_classes("ds-details", class),
    open = if (open) NA else NULL,
    htmltools::tag("summary", list(summary)),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Dialog Component
#'
#' Create a modal dialog using Designsystemet styles. Place `ds_dialog()` in
#' your UI and open/close it from the server with [show_ds_dialog()] and
#' [hide_ds_dialog()].
#'
#' @param ... Dialog content
#' @param id Dialog ID for opening/closing via [show_ds_dialog()]
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_dialog(
#'   id = "my-dialog",
#'   ds_heading("Dialog Title", level = 2),
#'   ds_paragraph("Dialog content here."),
#'   ds_button("Close", onclick = "this.closest('dialog').close()")
#' )
ds_dialog <- function(..., id = NULL, class = NULL) {
  tag <- htmltools::tag("dialog", list(
    id = id,
    class = .ds_classes("ds-dialog", class),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Open a dialog from the server
#'
#' Sends a message to the browser to call `showModal()` on a `ds_dialog()`
#' element already present in the UI.
#'
#' @param id The `id` of the `ds_dialog()` to open.
#' @param session Shiny session object.
#'
#' @return Called for side effects.
#' @export
#'
#' @examples
#' \dontrun{
#' observeEvent(input$open_btn, {
#'   show_ds_dialog("confirm-dialog")
#' })
#' }
show_ds_dialog <- function(id, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage("ds_dialog_show", list(id = id))
}

#' Close a dialog from the server
#'
#' Sends a message to the browser to call `close()` on a `ds_dialog()` element.
#'
#' @param id The `id` of the `ds_dialog()` to close.
#' @param session Shiny session object.
#'
#' @return Called for side effects.
#' @export
#'
#' @examples
#' \dontrun{
#' observeEvent(input$cancel_btn, {
#'   hide_ds_dialog("confirm-dialog")
#' })
#' }
hide_ds_dialog <- function(id, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage("ds_dialog_hide", list(id = id))
}

#' Dropdown Component
#'
#' Create a dropdown menu using Designsystemet styles.
#'
#' @param trigger The trigger element (usually a button)
#' @param ... Dropdown content
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_dropdown(
#'   trigger = ds_button("Options"),
#'   ds_list(ds_list_item("Edit"), ds_list_item("Delete"))
#' )
ds_dropdown <- function(trigger, ..., class = NULL) {
  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-dropdown", class),
    trigger,
    htmltools::tag("div", list(
      class = "ds-dropdown__content",
      ...
    ))
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Search Component
#'
#' Create a search input using Designsystemet styles.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param value Initial value
#' @param placeholder Placeholder text
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_search("search", placeholder = "Search…")
ds_search <- function(inputId, value = "", placeholder = NULL,
                      size = NULL, class = NULL, ...) {
  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-search", class),
    `data-size` = size,
    htmltools::tag("input", list(
      id = inputId,
      name = inputId,
      class = "ds-input ds-shiny-input",
      type = "search",
      value = value,
      placeholder = placeholder,
      ...
    ))
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Toggle Group Component
#'
#' Create a toggle button group using Designsystemet styles.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param ... Toggle buttons
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' \dontrun{
#' ds_toggle_group(
#'   "view_mode",
#'   tags$button(class = "ds-button", `data-variant` = "secondary",
#'               `aria-pressed` = "true",  value = "list", "List"),
#'   tags$button(class = "ds-button", `data-variant` = "secondary",
#'               `aria-pressed` = "false", value = "grid", "Grid")
#' )
#' }
ds_toggle_group <- function(inputId, ..., size = NULL, class = NULL) {
  tag <- htmltools::tag("div", list(
    id = inputId,
    class = .ds_classes("ds-toggle-group", class),
    `data-size` = size,
    role = "group",
    ...
  ))

  # Reactivity via Shiny.setInputValue rather than InputBinding, because the
  # @digdir/designsystemet-web behaviour module also operates on this element
  # and conflicts with binding-based approaches.
  script <- htmltools::tags$script(htmltools::HTML(sprintf(
    '$(document).one("shiny:sessioninitialized", function() {
       var btn = document.querySelector("#%1$s [aria-pressed=\'true\']");
       if (btn) Shiny.setInputValue("%1$s", btn.value || btn.textContent.trim());
     });
     $(document).on("click", "#%1$s button", function() {
       $("#%1$s button").attr("aria-pressed", "false");
       $(this).attr("aria-pressed", "true");
       Shiny.setInputValue("%1$s", this.value || this.textContent.trim());
     });',
    inputId
  )))

  result <- htmltools::tagList(tag, script)
  htmltools::attachDependencies(result, ds_dependencies())
}
