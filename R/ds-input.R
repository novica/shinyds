#' Text Input Component
#'
#' Create a styled text input using Designsystemet styles.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param value Initial value
#' @param type Input type ("text", "email", "password", "number", "tel", "url")
#' @param placeholder Placeholder text
#' @param size Size variant ("sm", "md", "lg")
#' @param readonly If TRUE, makes the input read-only
#' @param disabled If TRUE, disables the input
#' @param invalid If TRUE, shows invalid state
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_input("name", placeholder = "Enter your name")
#' ds_input("email", type = "email", placeholder = "your@email.com")
ds_input <- function(inputId, value = "", type = "text",
                     placeholder = NULL, size = NULL,
                     readonly = FALSE, disabled = FALSE,
                     invalid = FALSE, ...) {

  attribs <- list(
    id = inputId,
    name = inputId,
    class = "ds-input ds-shiny-input",
    type = type,
    value = value,
    placeholder = placeholder,
    `data-size` = size,
    readonly = if (readonly) NA else NULL,
    disabled = if (disabled) NA else NULL,
    `aria-invalid` = if (invalid) "true" else NULL,
    ...
  )

  attribs <- Filter(Negate(is.null), attribs)

  tag <- htmltools::tag("input", attribs)
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Textarea Component
#'
#' Create a styled textarea using Designsystemet styles.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param value Initial value
#' @param placeholder Placeholder text
#' @param rows Number of visible rows
#' @param size Size variant ("sm", "md", "lg")
#' @param readonly If TRUE, makes the textarea read-only
#' @param disabled If TRUE, disables the textarea
#' @param invalid If TRUE, shows invalid state
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
ds_textarea <- function(inputId, value = "", placeholder = NULL,
                        rows = 3, size = NULL,
                        readonly = FALSE, disabled = FALSE,
                        invalid = FALSE, ...) {

  attribs <- list(
    id = inputId,
    name = inputId,
    class = "ds-input ds-shiny-input",
    placeholder = placeholder,
    rows = rows,
    `data-size` = size,
    readonly = if (readonly) NA else NULL,
    disabled = if (disabled) NA else NULL,
    `aria-invalid` = if (invalid) "true" else NULL,
    ...
  )

  attribs <- Filter(Negate(is.null), attribs)

  tag <- htmltools::tag("textarea", c(attribs, list(value)))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Checkbox Component
#'
#' Create a styled checkbox using Designsystemet styles.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param label The checkbox label
#' @param value Initial checked state
#' @param size Size variant ("sm", "md", "lg")
#' @param disabled If TRUE, disables the checkbox
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_checkbox("agree", "I agree to the terms", value = FALSE)
ds_checkbox <- function(inputId, label, value = FALSE,
                        size = NULL, disabled = FALSE, ...) {

  input_el <- htmltools::tag("input", list(
    id = inputId,
    name = inputId,
    class = "ds-input ds-shiny-input",
    type = "checkbox",
    checked = if (value) NA else NULL,
    `data-size` = size,
    disabled = if (disabled) NA else NULL,
    ...
  ))

  label_el <- htmltools::tag("label", list(
    `for` = inputId,
    label
  ))

  tag <- htmltools::tagList(input_el, label_el)
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Radio Button Component
#'
#' Create a styled radio button using Designsystemet styles.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param label The radio button label
#' @param value The value for this radio button
#' @param name The name grouping radio buttons together
#' @param checked If TRUE, this radio is initially selected
#' @param size Size variant ("sm", "md", "lg")
#' @param disabled If TRUE, disables the radio button
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
ds_radio <- function(inputId, label, value, name,
                     checked = FALSE, size = NULL,
                     disabled = FALSE, ...) {

  input_el <- htmltools::tag("input", list(
    id = inputId,
    name = name,
    class = "ds-input",
    type = "radio",
    value = value,
    checked = if (checked) NA else NULL,
    `data-size` = size,
    disabled = if (disabled) NA else NULL,
    ...
  ))

  label_el <- htmltools::tag("label", list(
    `for` = inputId,
    label
  ))

  htmltools::tagList(input_el, label_el)
}

#' Select Component
#'
#' Create a styled select dropdown using Designsystemet styles.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param choices Named vector of choices (names are labels, values are values)
#' @param selected Initially selected value
#' @param size Size variant ("sm", "md", "lg")
#' @param disabled If TRUE, disables the select
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_select("country",
#'   choices = c("Norway" = "no", "Sweden" = "se", "Denmark" = "dk"),
#'   selected = "no"
#' )
ds_select <- function(inputId, choices, selected = NULL,
                      size = NULL, disabled = FALSE, ...) {

  # Handle both named and unnamed vectors
  if (is.null(names(choices))) {
    names(choices) <- choices
  }

  options <- lapply(seq_along(choices), function(i) {
    val <- choices[[i]]
    label <- names(choices)[i]
    htmltools::tag("option", list(
      value = val,
      selected = if (identical(val, selected)) NA else NULL,
      label
    ))
  })

  tag <- htmltools::tag("select", c(
    list(
      id = inputId,
      name = inputId,
      class = "ds-input ds-shiny-input",
      `data-size` = size,
      disabled = if (disabled) NA else NULL,
      ...
    ),
    options
  ))

  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Update Text Input
#'
#' Change the value from the server.
#'
#' @param session The Shiny session object
#' @param inputId The input ID
#' @param value The new value
#'
#' @export
update_ds_input <- function(session = shiny::getDefaultReactiveDomain(),
                            inputId, value = NULL) {
  message <- list(value = value)
  message <- Filter(Negate(is.null), message)
  session$sendInputMessage(inputId, message)
}

#' Update Checkbox
#'
#' Change the checked state from the server.
#'
#' @param session The Shiny session object
#' @param inputId The input ID
#' @param value The new checked state (TRUE/FALSE)
#'
#' @export
update_ds_checkbox <- function(session = shiny::getDefaultReactiveDomain(),
                               inputId, value = NULL) {
  message <- list(value = value)
  message <- Filter(Negate(is.null), message)
  session$sendInputMessage(inputId, message)
}

#' Update Select
#'
#' Change the selected value or choices from the server.
#'
#' @param session The Shiny session object
#' @param inputId The input ID
#' @param value The new selected value
#' @param choices New named vector of choices
#'
#' @export
update_ds_select <- function(session = shiny::getDefaultReactiveDomain(),
                             inputId, value = NULL, choices = NULL) {
  message <- list(value = value, choices = choices)
  message <- Filter(Negate(is.null), message)
  session$sendInputMessage(inputId, message)
}
