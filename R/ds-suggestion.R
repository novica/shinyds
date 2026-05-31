#' Suggestion/Autocomplete Component
#'
#' Create an autocomplete input with suggestions.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param choices Character vector of suggestion choices
#' @param value Initial value
#' @param placeholder Placeholder text
#' @param size Size variant ("sm", "md", "lg")
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_suggestion("city",
#'   choices = c("Oslo", "Bergen", "Trondheim", "Stavanger"),
#'   placeholder = "Search for a city..."
#' )
ds_suggestion <- function(inputId, choices = NULL, value = "",
                          placeholder = NULL, size = NULL, ...) {

  # data-shiny-no-bind-input: Shiny's bindInputs() explicitly skips elements
  # with this attribute. Without it, the <ds-field> behaviour module assigns
  # a :ds:N id to this unlabelled input, and Shiny's built-in TextInputBinding
  # (which finds ALL input[type=text] with no class restriction) would send
  # that colon-prefixed name to the server, crashing with:
  #   "No handler registered for type :ds:1"
  # A pre-assigned id prevents the :ds:N assignment in the first place.
  input_el <- htmltools::tag("input", list(
    id = paste0(inputId, "-input"),
    `data-shiny-no-bind-input` = NA,
    type = "text",
    class = "ds-input",
    value = value,
    placeholder = placeholder,
    `data-size` = size
  ))

  # Pre-assign the datalist id so the bundle's b() function does not assign
  # a :ds:N id to it (Sa() calls b(list) to set popovertarget on the input).
  datalist_id <- paste0(inputId, "-list")
  datalist_el <- if (!is.null(choices) && length(choices) > 0) {
    htmltools::tag("datalist", c(
      list(id = datalist_id),
      lapply(choices, function(choice) {
        htmltools::tag("option", list(value = choice))
      })
    ))
  } else {
    htmltools::tag("datalist", list(id = datalist_id))
  }

  tag <- htmltools::tag("ds-suggestion", list(
    id = inputId,
    class = "ds-suggestion ds-shiny-input",
    input_el,
    datalist_el,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Update Suggestion Input
#'
#' Change the value or choices from the server.
#'
#' @param session The Shiny session object
#' @param inputId The input ID of the suggestion component
#' @param value The new value
#' @param choices New character vector of choices
#'
#' @return Called for its side effect. Returns \code{NULL} invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' update_ds_suggestion(session, "fruit", value = "Apple")
#' }
update_ds_suggestion <- function(session = shiny::getDefaultReactiveDomain(),
                                  inputId, value = NULL, choices = NULL) {
  message <- list(value = value, choices = choices)
  message <- Filter(Negate(is.null), message)
  session$sendInputMessage(inputId, message)
}
