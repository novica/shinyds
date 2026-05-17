#' Divider Component
#'
#' Create a horizontal divider using Designsystemet styles.
#'
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_divider()
ds_divider <- function(class = NULL) {
  tag <- htmltools::tag("hr", list(
    class = .ds_classes("ds-divider", class)
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Badge Component
#'
#' Create a count-indicator badge using Designsystemet styles.
#'
#' The badge is a small circle that sits on top of another element (e.g. a
#' button) to show a numeric count.  Wrap the target element with a
#' \code{ds_badge_position()} container and place \code{ds_badge()} inside it.
#'
#' The circle text comes from \code{count}; \code{...} is the accessible label
#' for the element being badged (rendered as invisible span text).
#'
#' @param count Numeric or character value shown inside the badge circle.
#'   Pass \code{NULL} for a plain dot.
#' @param color Color context: one of \code{"info"}, \code{"success"},
#'   \code{"warning"}, \code{"danger"}, \code{"accent"}, \code{"neutral"},
#'   \code{"brand1"}, \code{"brand2"}.  Maps to the DS \code{data-color}
#'   attribute.
#' @param variant Structural variant: \code{"tinted"} for a muted background.
#'   Colour variants belong in \code{color}, not here.
#' @param size Size variant (\code{"sm"}, \code{"md"}, \code{"lg"}).
#' @param class Additional CSS classes.
#' @param ... Additional attributes passed to the \code{<span>}.
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' # Count badge on a button (typical use)
#' htmltools::tags$span(
#'   class = "ds-badge--position",
#'   ds_button("Inbox"),
#'   ds_badge(count = 4, color = "danger")
#' )
#'
#' # Standalone dot with no count
#' ds_badge(color = "success")
ds_badge <- function(count = NULL, color = NULL, variant = NULL,
                     size = NULL, class = NULL, ...) {
  tag <- htmltools::tag("span", list(
    class       = .ds_classes("ds-badge", class),
    `data-color`   = color,
    `data-variant` = variant,
    `data-size`    = size,
    `data-count`   = if (!is.null(count)) as.character(count) else NULL,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Badge Position Wrapper
#'
#' Wraps an element so that a \code{ds_badge()} can be positioned on top of it.
#'
#' @param ... The target element followed by a \code{ds_badge()}.
#' @param placement Badge placement: \code{"top-right"} (default),
#'   \code{"top-left"}, \code{"bottom-right"}, \code{"bottom-left"}.
#' @param overlap Set to \code{"circle"} when the target is a circular avatar.
#' @param class Additional CSS classes.
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_badge_position(
#'   ds_button("Inbox"),
#'   ds_badge(count = 3, color = "danger"),
#'   placement = "top-right"
#' )
ds_badge_position <- function(..., placement = "top-right",
                              overlap = NULL, class = NULL) {
  tag <- htmltools::tag("span", list(
    class            = .ds_classes("ds-badge--position", class),
    `data-placement` = placement,
    `data-overlap`   = overlap,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Tag Component
#'
#' Create a text label tag using Designsystemet styles.
#'
#' Tags are the right component for standalone text status labels such as
#' "New", "Beta" or "Active".  For numeric count indicators, use
#' \code{\link{ds_badge}}.
#'
#' @param ... Tag content (text or child elements).
#' @param color Color context: one of \code{"info"}, \code{"success"},
#'   \code{"warning"}, \code{"danger"}, \code{"accent"}, \code{"neutral"},
#'   \code{"brand1"}, \code{"brand2"}.  Maps to the DS \code{data-color}
#'   attribute.
#' @param variant Structural variant: \code{"outline"} adds a subtle border.
#' @param size Size variant (\code{"sm"}, \code{"md"}, \code{"lg"}).
#' @param class Additional CSS classes.
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_tag("New")
#' ds_tag("Active",  color = "success")
#' ds_tag("Warning", color = "warning", variant = "outline")
ds_tag <- function(..., color = NULL, variant = NULL, size = NULL,
                   class = NULL) {
  tag <- htmltools::tag("span", list(
    class          = .ds_classes("ds-tag", class),
    `data-color`   = color,
    `data-variant` = variant,
    `data-size`    = size,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Chip Component
#'
#' Create an interactive chip using Designsystemet styles.
#'
#' @param ... Chip content
#' @param variant Chip variant
#' @param size Size variant ("sm", "md", "lg")
#' @param selected If TRUE, shows selected state
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
ds_chip <- function(..., variant = NULL, size = NULL,
                    selected = FALSE, class = NULL) {
  tag <- htmltools::tag("button", list(
    class = .ds_classes("ds-chip", class),
    `data-variant` = variant,
    `data-size` = size,
    `aria-pressed` = if (selected) "true" else "false",
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Spinner Component
#'
#' Create a loading spinner using Designsystemet styles.
#'
#' @param title Accessibility title for the spinner
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_spinner(title = "Loading...")
ds_spinner <- function(title = "Laster...", size = NULL, class = NULL) {
  tag <- htmltools::tag("span", list(
    class = .ds_classes("ds-spinner", class),
    `data-size` = size,
    `aria-label` = title,
    role = "status"
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Skeleton Component
#'
#' Create a loading skeleton placeholder using Designsystemet styles.
#'
#' @param variant Skeleton variant ("text", "circle", "rectangle")
#' @param width Width of the skeleton
#' @param height Height of the skeleton
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_skeleton(variant = "text", width = "200px")
#' ds_skeleton(variant = "circle", width = "50px", height = "50px")
ds_skeleton <- function(variant = "text", width = NULL, height = NULL,
                        class = NULL) {
  style <- NULL
  if (!is.null(width) || !is.null(height)) {
    style_parts <- c()
    if (!is.null(width)) style_parts <- c(style_parts, paste0("width:", width))
    if (!is.null(height)) style_parts <- c(style_parts, paste0("height:", height))
    style <- paste(style_parts, collapse = ";")
  }

  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-skeleton", class),
    `data-variant` = variant,
    style = style,
    `aria-hidden` = "true"
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Avatar Component
#'
#' Create an avatar using Designsystemet styles.
#'
#' @param ... Avatar content (typically an image or initials)
#' @param variant Avatar variant
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
ds_avatar <- function(..., variant = NULL, size = NULL, class = NULL) {
  tag <- htmltools::tag("span", list(
    class = .ds_classes("ds-avatar", class),
    `data-variant` = variant,
    `data-size` = size,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Avatar Stack Component
#'
#' Create a stack of avatars using Designsystemet styles.
#'
#' @param ... Avatar elements
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
ds_avatar_stack <- function(..., class = NULL) {
  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-avatar-stack", class),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Skip Link Component
#'
#' Create an accessibility skip link using Designsystemet styles.
#'
#' @param ... Link content
#' @param href Target anchor
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_skip_link("Skip to main content", href = "#main")
ds_skip_link <- function(..., href = "#main", class = NULL) {
  tag <- htmltools::tag("a", list(
    class = .ds_classes("ds-skip-link", class),
    href = href,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Validation Message Component
#'
#' Create a validation message using Designsystemet styles.
#'
#' @param ... Message content
#' @param variant Message variant ("error", "warning")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_validation_message("This field is required")
ds_validation_message <- function(..., variant = "error", class = NULL) {
  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-validation-message", class),
    `data-variant` = variant,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Combobox Component
#'
#' Create a combobox container using Designsystemet styles. Unlike
#' \code{ds_suggestion}, this is a pure CSS component — keyboard navigation
#' and dropdown behaviour must be implemented by the caller.
#'
#' @param inputId The input slot for Shiny reactivity
#' @param ... Child elements (input wrapper, options wrapper, etc.)
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_combobox("mycombo",
#'   htmltools::tags$div(class = "ds-combobox__input__wrapper",
#'     htmltools::tags$input(class = "ds-combobox__input", type = "text")
#'   ),
#'   htmltools::tags$div(class = "ds-combobox__options-wrapper")
#' )
ds_combobox <- function(inputId, ..., size = NULL, class = NULL) {
  size_class <- if (!is.null(size)) paste0("ds-combobox--", size) else NULL
  tag <- htmltools::tag("div", list(
    id = inputId,
    class = .ds_classes("ds-combobox", size_class, class),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Popover Component
#'
#' Create a popover using Designsystemet styles.
#'
#' @param ... Popover content
#' @param variant Popover variant ("default", "tinted")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_popover("Helpful information about this field.")
#' ds_popover("Highlighted note", variant = "tinted")
ds_popover <- function(..., variant = NULL, class = NULL) {
  tag <- htmltools::tag("div", list(
    class = .ds_classes("ds-popover", class),
    `data-variant` = variant,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}
