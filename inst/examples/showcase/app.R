# Designsystemet Shiny Showcase
# Run with: shiny::runApp(system.file("examples/showcase", package = "shinyds"))

library(shiny)
library(bslib)
library(shinyds)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

fn_tag <- function(...) {
  tags$span(
    style = paste(
      "font-family: monospace; font-size: 0.78rem;",
      "background: #f3f4f6; border: 1px solid #d1d5db;",
      "border-radius: 4px; padding: 2px 8px; color: #374151;",
      "margin: 0 4px 4px 0; display: inline-block;"
    ),
    ...
  )
}

demo_card <- function(title, fns, ..., warn = FALSE) {
  ds_card(
    ds_card_block(
      tags$div(
        style = "display:flex; align-items:center; gap:0.5rem; flex-wrap:wrap; margin-bottom:0.25rem;",
        ds_heading(title, level = 3, size = "sm"),
        if (warn) ds_tag("⚠ behaviour module", color = "warning")
      ),
      tags$div(style = "margin-bottom:0.75rem;", lapply(fns, fn_tag)),
      ...
    )
  )
}

row_sep <- tags$hr(style = "border:none; border-top:1px solid #eee; margin:0.75rem 0;")

flex_row <- function(..., gap = "0.75rem", wrap = TRUE) {
  tags$div(
    style = sprintf(
      "display:flex; gap:%s; align-items:center;%s",
      gap,
      if (wrap) " flex-wrap:wrap;" else ""
    ),
    ...
  )
}

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

ui <- bslib::page_fluid(
  use_designsystemet(),

  # Make the bslib sidebar sticky and full-height
  tags$style(HTML("
    .bslib-sidebar-layout {
      align-items: flex-start;
    }
    .bslib-sidebar-layout > .sidebar {
      position: sticky;
      top: 1rem;
      max-height: calc(100vh - 2rem);
      overflow-y: auto;
    }
    .bslib-sidebar-layout > .sidebar .sidebar-content {
      padding: 0.75rem;
    }
    .bslib-sidebar-layout > .sidebar pre {
      font-size: 0.72rem;
      margin: 0;
    }
  ")),

  tags$div(
    style = "max-width: 1280px; margin: 0 auto; padding: 1.5rem 1rem 3rem;",

    ds_skip_link("Skip to main content", href = "#main"),

    # ── Header ──────────────────────────────────────────────────────────────
    tags$header(
      style = "margin-bottom: 1.5rem;",
      ds_heading("shinyds Component Showcase", level = 1, size = "2xl"),
      ds_paragraph(
        "Live reference for all ",
        ds_link("Designsystemet", href = "https://designsystemet.no"),
        " components in the shinyds package.",
        size = "lg"
      ),
      tags$div(
        style = "display:flex; gap:0.5rem; flex-wrap:wrap; margin-top:0.5rem;",
        ds_tag("interactive inputs are reactive", color = "info"),
        ds_tag("⚠ = behaviour-only JS module",   color = "warning")
      )
    ),

    ds_divider(),
    tags$div(style = "height:1.25rem;"),

    # ── Main: sidebar layout ────────────────────────────────────────────────
    tags$main(
      id = "main",

      bslib::layout_sidebar(
        fill      = FALSE,
        border    = FALSE,
        sidebar   = bslib::sidebar(
          title    = "Input values",
          position = "right",
          width    = 310,
          bg       = "#f8f9fa",
          verbatimTextOutput("values")
        ),

        # ── Tabs ────────────────────────────────────────────────────────────
        ds_tabs(
          "main_tabs",
          ds_tablist(
            ds_tab("Inputs",     value = "inputs",     selected = TRUE),
            ds_tab("Typography", value = "typography"),
            ds_tab("Feedback",   value = "feedback"),
            ds_tab("Layout",     value = "layout"),
            ds_tab("Overlays",   value = "overlays")
          ),

          # ── Inputs ────────────────────────────────────────────────────────
          ds_tabpanel(
            value = "inputs",
            tags$div(style = "padding:1.25rem 0;",

              demo_card("Button", list("ds_button()"),
                ds_paragraph("Three variants, three sizes, plus disabled and loading states."),
                row_sep,
                tags$p(ds_label("Variants")),
                flex_row(
                  ds_button("Primary",   inputId = "btn_primary",   variant = "primary"),
                  ds_button("Secondary", inputId = "btn_secondary", variant = "secondary"),
                  ds_button("Tertiary",  inputId = "btn_tertiary",  variant = "tertiary")
                ),
                row_sep,
                tags$p(ds_label("Sizes")),
                flex_row(
                  ds_button("Small",  inputId = "btn_sm", size = "sm"),
                  ds_button("Medium", inputId = "btn_md", size = "md"),
                  ds_button("Large",  inputId = "btn_lg", size = "lg")
                ),
                row_sep,
                tags$p(ds_label("States")),
                flex_row(
                  ds_button("Disabled",   variant = "primary",   disabled  = TRUE),
                  ds_button("Loading…", variant = "secondary", loading = TRUE),
                  ds_button("Full width", inputId = "btn_full",
                            variant = "secondary", fullwidth = TRUE)
                )
              ),

              demo_card("Text Input", list("ds_input()", "ds_field()", "ds_label()"),
                ds_paragraph("Wrapping ds_input() in ds_field() with ds_label() is the standard pattern."),
                row_sep,
                bslib::layout_column_wrap(
                  width = "220px",
                  ds_field(
                    ds_label("Text", `for` = "inp_text"),
                    ds_input("inp_text", placeholder = "Plain text")
                  ),
                  ds_field(
                    ds_label("Email", `for` = "inp_email"),
                    ds_input("inp_email", type = "email", placeholder = "you@example.com")
                  ),
                  ds_field(
                    ds_label("Password", `for` = "inp_pwd"),
                    ds_input("inp_pwd", type = "password", placeholder = "Min 8 characters"),
                    ds_validation_message("Must be at least 8 characters", variant = "error")
                  ),
                  ds_field(
                    ds_label("Number", `for` = "inp_num"),
                    ds_input("inp_num", type = "number", placeholder = "0")
                  )
                )
              ),

              demo_card("Textarea", list("ds_textarea()"),
                ds_field(
                  ds_label("Message", `for` = "inp_msg"),
                  ds_textarea("inp_msg", placeholder = "Type your message…", rows = 4)
                )
              ),

              demo_card("Checkbox & Radio", list("ds_checkbox()", "ds_radio()"),
                bslib::layout_column_wrap(
                  width = "180px",
                  tags$div(
                    ds_label("Checkbox"),
                    tags$div(style = "margin-top:0.25rem;",
                      ds_checkbox("chk1", label = "Option A"),
                      ds_checkbox("chk2", label = "Option B", value = TRUE),
                      ds_checkbox("chk3", label = "Disabled", disabled = TRUE)
                    )
                  ),
                  tags$div(
                    ds_label("Radio group"),
                    tags$div(style = "margin-top:0.25rem;",
                      ds_radio("radio_a", label = "Choice A", value = "a",
                               name = "radio_grp", checked = TRUE),
                      ds_radio("radio_b", label = "Choice B", value = "b",
                               name = "radio_grp"),
                      ds_radio("radio_c", label = "Choice C (disabled)", value = "c",
                               name = "radio_grp", disabled = TRUE)
                    )
                  )
                )
              ),

              demo_card("Select", list("ds_select()"),
                bslib::layout_column_wrap(
                  width = "200px",
                  ds_field(
                    ds_label("Country", `for` = "sel_country"),
                    ds_select("sel_country",
                      choices  = c("Norway" = "no", "Sweden" = "se",
                                   "Denmark" = "dk", "Finland" = "fi"),
                      selected = "no"
                    )
                  ),
                  ds_field(
                    ds_label("Size sm", `for` = "sel_sm"),
                    ds_select("sel_sm",
                      choices = c("Apple", "Banana", "Cherry"),
                      size    = "sm"
                    )
                  )
                )
              ),

              demo_card("Fieldset", list("ds_fieldset()"), warn = TRUE,
                ds_paragraph("Groups related controls under a shared legend."),
                ds_fieldset(
                  legend = "Notification preferences",
                  ds_checkbox("notif_email", label = "Email"),
                  ds_checkbox("notif_sms",   label = "SMS"),
                  ds_checkbox("notif_push",  label = "Push")
                )
              ),

              demo_card("Search & Suggestion", list("ds_search()", "ds_suggestion()"),
                bslib::layout_column_wrap(
                  width = "220px",
                  ds_field(
                    ds_label("Search", `for` = "inp_search"),
                    ds_search("inp_search", placeholder = "Search…")
                  ),
                  ds_field(
                    ds_label("Autocomplete", `for` = "inp_suggest"),
                    ds_suggestion(
                      "inp_suggest",
                      choices = c("Apple", "Banana", "Cherry", "Date", "Elderberry",
                                  "Fig", "Grape"),
                      placeholder = "Start typing a fruit…"
                    )
                  )
                )
              ),

              demo_card("Combobox", list("ds_combobox()"),
                ds_paragraph(
                  "A CSS-only container for custom combobox implementations.",
                  " Keyboard behaviour and option list are caller-supplied."
                ),
                ds_combobox(
                  "demo_combo",
                  tags$div(
                    class = "ds-combobox__input__wrapper",
                    tags$input(
                      class        = "ds-combobox__input",
                      type         = "text",
                      placeholder  = "Pick an option…",
                      autocomplete = "off"
                    )
                  ),
                  tags$div(
                    class = "ds-combobox__options-wrapper",
                    style = "display:none;"
                  )
                )
              ),

              demo_card("Toggle Group", list("ds_toggle_group()"), warn = TRUE,
                ds_paragraph("Reactivity is handled via Shiny.setInputValue() rather than an InputBinding."),
                ds_toggle_group(
                  "view_mode",
                  tags$button(class = "ds-button", `data-variant` = "secondary",
                              `aria-pressed` = "true",  value = "list", "List"),
                  tags$button(class = "ds-button", `data-variant` = "secondary",
                              `aria-pressed` = "false", value = "grid", "Grid"),
                  tags$button(class = "ds-button", `data-variant` = "secondary",
                              `aria-pressed` = "false", value = "map",  "Map")
                )
              )
            )
          ),

          # ── Typography ────────────────────────────────────────────────────
          ds_tabpanel(
            value = "typography",
            tags$div(style = "padding:1.25rem 0;",

              demo_card("Heading", list("ds_heading()"),
                ds_paragraph("Seven size tokens from 2xl down to 2xs, any heading level."),
                row_sep,
                ds_heading("Heading 2XL", level = 2, size = "2xl"),
                ds_heading("Heading XL",  level = 2, size = "xl"),
                ds_heading("Heading LG",  level = 2, size = "lg"),
                ds_heading("Heading MD",  level = 3, size = "md"),
                ds_heading("Heading SM",  level = 4, size = "sm"),
                ds_heading("Heading XS",  level = 5, size = "xs"),
                ds_heading("Heading 2XS", level = 6, size = "2xs")
              ),

              demo_card("Paragraph", list("ds_paragraph()"),
                ds_paragraph("Large — introductions and hero text.", size = "lg"),
                ds_paragraph("Medium (default) — regular body copy."),
                ds_paragraph("Small — captions and secondary information.", size = "sm")
              ),

              demo_card("Label", list("ds_label()"),
                ds_paragraph("Companion to form inputs. Rendered as <label>."),
                row_sep,
                tags$div(
                  style = "display:flex; flex-direction:column; gap:0.4rem;",
                  ds_label("Form label (default)"),
                  ds_label("Label for an input", `for` = "demo_label_input"),
                  tags$input(id = "demo_label_input", type = "text",
                             placeholder = "Click the label above to focus me",
                             style = "padding:4px 8px; border:1px solid #ccc; border-radius:4px; width:260px;")
                )
              ),

              demo_card("Link", list("ds_link()"),
                ds_paragraph(
                  "Use ",
                  ds_link("ds_link()", href = "https://designsystemet.no"),
                  " inside paragraphs or standalone. Opens in same tab by default."
                )
              ),

              demo_card("List", list("ds_list()", "ds_list_item()"),
                bslib::layout_column_wrap(
                  width = "160px",
                  tags$div(
                    ds_label("Unordered"),
                    ds_list(
                      ds_list_item("First item"),
                      ds_list_item("Second item"),
                      ds_list_item("Third item")
                    )
                  ),
                  tags$div(
                    ds_label("Ordered"),
                    ds_list(
                      ds_list_item("Step one"),
                      ds_list_item("Step two"),
                      ds_list_item("Step three"),
                      ordered = TRUE
                    )
                  )
                )
              )
            )
          ),

          # ── Feedback ──────────────────────────────────────────────────────
          ds_tabpanel(
            value = "feedback",
            tags$div(style = "padding:1.25rem 0;",

              demo_card("Alert", list("ds_alert()"),
                tags$div(
                  style = "display:flex; flex-direction:column; gap:0.5rem;",
                  ds_alert("Informational — neutral context.", variant = "info"),
                  ds_alert("Success — operation completed.", variant = "success"),
                  ds_alert("Warning — review before proceeding.", variant = "warning"),
                  ds_alert("Danger — something went wrong.", variant = "danger")
                )
              ),

              demo_card("Badge", list("ds_badge()", "ds_badge_position()"),
                ds_paragraph(
                  "A count indicator that overlays another element.",
                  " The circle text comes from ", tags$code("count"),
                  "; use ", tags$code("color"), " for semantic colour."
                ),
                row_sep,
                tags$p(ds_label("Positioned on a button")),
                flex_row(
                  ds_badge_position(
                    ds_button("Inbox", variant = "secondary"),
                    ds_badge(count = 4, color = "danger")
                  ),
                  ds_badge_position(
                    ds_button("Alerts", variant = "secondary"),
                    ds_badge(count = 12, color = "warning")
                  ),
                  ds_badge_position(
                    ds_button("Done", variant = "secondary"),
                    ds_badge(count = 0, color = "success")
                  )
                ),
                row_sep,
                tags$p(ds_label("Color variants")),
                flex_row(
                  ds_badge_position(
                    tags$span(style = "width:2rem; height:2rem; display:inline-block;"),
                    ds_badge(count = 1)
                  ),
                  ds_badge_position(
                    tags$span(style = "width:2rem; height:2rem; display:inline-block;"),
                    ds_badge(count = 2, color = "info")
                  ),
                  ds_badge_position(
                    tags$span(style = "width:2rem; height:2rem; display:inline-block;"),
                    ds_badge(count = 3, color = "success")
                  ),
                  ds_badge_position(
                    tags$span(style = "width:2rem; height:2rem; display:inline-block;"),
                    ds_badge(count = 4, color = "warning")
                  ),
                  ds_badge_position(
                    tags$span(style = "width:2rem; height:2rem; display:inline-block;"),
                    ds_badge(count = 5, color = "danger")
                  )
                )
              ),

              demo_card("Tag", list("ds_tag()"),
                ds_paragraph(
                  "Standalone text label. Use ", tags$code("color"),
                  " for semantic colour (not ", tags$code("variant"),
                  " — that controls the outline border)."
                ),
                row_sep,
                tags$p(ds_label("Colors")),
                flex_row(
                  ds_tag("Default"),
                  ds_tag("Info",    color = "info"),
                  ds_tag("Success", color = "success"),
                  ds_tag("Warning", color = "warning"),
                  ds_tag("Danger",  color = "danger"),
                  ds_tag("Neutral", color = "neutral")
                ),
                row_sep,
                tags$p(ds_label("Outline variant")),
                flex_row(
                  ds_tag("Info",    color = "info",    variant = "outline"),
                  ds_tag("Success", color = "success", variant = "outline"),
                  ds_tag("Warning", color = "warning", variant = "outline"),
                  ds_tag("Danger",  color = "danger",  variant = "outline")
                ),
                row_sep,
                tags$p(ds_label("Sizes")),
                flex_row(
                  ds_tag("Small",  size = "sm"),
                  ds_tag("Medium"),
                  ds_tag("Large",  size = "lg")
                )
              ),

              demo_card("Chip", list("ds_chip()"),
                ds_paragraph("Toggle-style filter chips."),
                flex_row(
                  ds_chip("React",    selected = TRUE),
                  ds_chip("Vue"),
                  ds_chip("Angular"),
                  ds_chip("Svelte"),
                  ds_chip("Disabled", disabled = TRUE)
                )
              ),

              demo_card("Spinner", list("ds_spinner()"),
                flex_row(
                  tags$div(
                    style = "text-align:center;",
                    ds_spinner(title = "Small",  size = "sm"),
                    tags$p(ds_label("sm"))
                  ),
                  tags$div(
                    style = "text-align:center;",
                    ds_spinner(title = "Medium", size = "md"),
                    tags$p(ds_label("md"))
                  ),
                  tags$div(
                    style = "text-align:center;",
                    ds_spinner(title = "Large",  size = "lg"),
                    tags$p(ds_label("lg"))
                  )
                )
              ),

              demo_card("Skeleton", list("ds_skeleton()"),
                ds_paragraph("Loading-state placeholders."),
                row_sep,
                tags$div(style = "max-width:400px;",
                  ds_skeleton(variant = "text", width = "100%"),
                  tags$div(style = "height:0.3rem;"),
                  ds_skeleton(variant = "text", width = "80%"),
                  tags$div(style = "height:0.3rem;"),
                  ds_skeleton(variant = "text", width = "60%")
                ),
                row_sep,
                flex_row(
                  ds_skeleton(variant = "circle",    width = "48px", height = "48px"),
                  ds_skeleton(variant = "rectangle", width = "120px", height = "48px")
                )
              ),

              demo_card("Validation Message", list("ds_validation_message()"),
                flex_row(
                  ds_validation_message("This field is required.", variant = "error"),
                  ds_validation_message("Value looks unusual.",    variant = "warning")
                )
              ),

              demo_card("Error Summary", list("ds_error_summary()"),
                ds_paragraph("Placed at the top of a form to list all validation errors."),
                ds_error_summary(
                  heading = "Fix the following errors:",
                  tags$ul(
                    tags$li(ds_link("Name is required",    href = "#inp_text")),
                    tags$li(ds_link("Email must be valid", href = "#inp_email")),
                    tags$li(ds_link("Password too short",  href = "#inp_pwd"))
                  )
                )
              )
            )
          ),

          # ── Layout ────────────────────────────────────────────────────────
          ds_tabpanel(
            value = "layout",
            tags$div(style = "padding:1.25rem 0;",

              demo_card("Card", list("ds_card()", "ds_card_block()"),
                bslib::layout_column_wrap(
                  width = "200px",
                  ds_card(
                    ds_card_block(
                      ds_heading("Default card", level = 4, size = "sm"),
                      ds_paragraph("Standard card style.")
                    )
                  ),
                  ds_card(
                    variant = "tinted",
                    ds_card_block(
                      ds_heading("Tinted card", level = 4, size = "sm"),
                      ds_paragraph("Alternate background.")
                    )
                  )
                )
              ),

              demo_card("Divider", list("ds_divider()"),
                ds_paragraph("Above the divider."),
                ds_divider(),
                ds_paragraph("Below the divider.")
              ),

              demo_card("Table", list(
                "ds_table()", "ds_thead()", "ds_tbody()",
                "ds_tr()", "ds_th()", "ds_td()"
              ),
                ds_table(
                  ds_thead(
                    ds_tr(ds_th("Name"), ds_th("Role"), ds_th("Status"))
                  ),
                  ds_tbody(
                    ds_tr(
                      ds_td("Alice"),   ds_td("Developer"),
                      ds_td(ds_tag("Active", color = "success"))
                    ),
                    ds_tr(
                      ds_td("Bob"),     ds_td("Designer"),
                      ds_td(ds_tag("Active", color = "success"))
                    ),
                    ds_tr(
                      ds_td("Charlie"), ds_td("Manager"),
                      ds_td(ds_tag("Away", color = "warning"))
                    )
                  )
                )
              ),

              demo_card("Breadcrumbs", list("ds_breadcrumbs()"),
                ds_breadcrumbs(
                  tags$ol(
                    tags$li(ds_link("Home",     href = "#")),
                    tags$li(ds_link("Products", href = "#")),
                    tags$li(tags$span("Current Page"))
                  )
                )
              ),

              demo_card("Pagination", list("ds_pagination()"),
                ds_pagination("page_nav", current = 3, total = 10)
              ),

              demo_card("Avatar & Avatar Stack", list("ds_avatar()", "ds_avatar_stack()"),
                tags$p(ds_label("Sizes")),
                flex_row(
                  ds_avatar("AB", size = "sm"),
                  ds_avatar("CD", size = "md"),
                  ds_avatar("EF", size = "lg")
                ),
                row_sep,
                tags$p(ds_label("Stack")),
                ds_avatar_stack(
                  ds_avatar("AB"),
                  ds_avatar("CD"),
                  ds_avatar("EF"),
                  ds_avatar("GH")
                )
              ),

              demo_card("Skip Link", list("ds_skip_link()"),
                ds_paragraph(
                  "Renders as a visually-hidden link that becomes visible on keyboard focus.",
                  " One is already present at the top of this page: press",
                  tags$kbd(" Tab "),
                  " after page load to see it."
                )
              )
            )
          ),

          # ── Overlays ──────────────────────────────────────────────────────
          ds_tabpanel(
            value = "overlays",
            tags$div(style = "padding:1.25rem 0;",

              demo_card("Tooltip", list("ds_tooltip()"),
                ds_paragraph("Hover over each button to see the tooltip placement."),
                flex_row(
                  ds_tooltip(
                    ds_button("Top",    inputId = "btn_tt_top"),
                    text = "Tooltip on top", placement = "top"
                  ),
                  ds_tooltip(
                    ds_button("Right",  inputId = "btn_tt_right",  variant = "secondary"),
                    text = "Tooltip on right", placement = "right"
                  ),
                  ds_tooltip(
                    ds_button("Bottom", inputId = "btn_tt_bottom", variant = "secondary"),
                    text = "Tooltip on bottom", placement = "bottom"
                  ),
                  ds_tooltip(
                    ds_button("Left",   inputId = "btn_tt_left",   variant = "secondary"),
                    text = "Tooltip on left", placement = "left"
                  )
                )
              ),

              demo_card("Popover", list("ds_popover()"), warn = TRUE,
                ds_paragraph("Click a button to open its popover."),
                flex_row(
                  tags$div(
                    style = "position:relative;",
                    ds_button("Default popover", inputId = "btn_pop1",
                              `popovertarget` = "pop1"),
                    ds_popover(
                      id = "pop1", popover = NA,
                      ds_heading("Popover title", level = 3, size = "sm"),
                      ds_paragraph("Some helpful contextual information.")
                    )
                  ),
                  tags$div(
                    style = "position:relative;",
                    ds_button("Tinted popover", inputId = "btn_pop2",
                              variant = "secondary", `popovertarget` = "pop2"),
                    ds_popover(
                      id = "pop2", popover = NA, variant = "tinted",
                      ds_heading("Tinted popover", level = 3, size = "sm"),
                      ds_paragraph("Same structure, alternate background.")
                    )
                  )
                )
              ),

              demo_card("Details / Accordion", list("ds_details()"), warn = TRUE,
                ds_details(
                  summary = "What is Designsystemet?",
                  ds_paragraph(
                    "A Norwegian government design system providing accessible,",
                    " consistent UI components."
                  )
                ),
                ds_details(
                  summary = "How do I use it in Shiny?",
                  open    = TRUE,
                  ds_paragraph(
                    "Call use_designsystemet() in your UI, then use ds_* functions."
                  )
                ),
                ds_details(
                  summary = "Which components are reactive?",
                  ds_paragraph(
                    "Components marked with ⚠ use behaviour-only JS modules.",
                    " Add reactivity with Shiny.setInputValue() and observeEvent()",
                    " rather than InputBinding — see CLAUDE.md."
                  )
                )
              ),

              demo_card("Dialog", list("ds_dialog()"), warn = TRUE,
                tags$button(
                  class = "ds-button", `data-variant` = "primary",
                  onclick = "document.getElementById('demo-dialog').showModal()",
                  "Open dialog"
                ),
                ds_dialog(
                  id = "demo-dialog",
                  ds_heading("Dialog Title", level = 2, size = "md"),
                  ds_paragraph(
                    "This is the dialog content.",
                    " Press Escape or a button below to close."
                  ),
                  tags$div(
                    style = "display:flex; gap:0.75rem; margin-top:1rem;",
                    tags$button(
                      class = "ds-button", `data-variant` = "primary",
                      onclick = "document.getElementById('demo-dialog').close()",
                      "Confirm"
                    ),
                    tags$button(
                      class = "ds-button", `data-variant` = "secondary",
                      onclick = "document.getElementById('demo-dialog').close()",
                      "Cancel"
                    )
                  )
                )
              ),

              demo_card("Dropdown", list("ds_dropdown()"),
                ds_dropdown(
                  trigger = ds_button("Open Menu", inputId = "btn_dropdown",
                                      variant = "secondary"),
                  ds_list(
                    ds_list_item(ds_link("Profile",  href = "#")),
                    ds_list_item(ds_link("Settings", href = "#")),
                    ds_list_item(ds_link("Log out",  href = "#"))
                  )
                )
              )
            )
          )
        )  # end ds_tabs
      )    # end layout_sidebar
    )      # end main
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------

server <- function(input, output, session) {
  output$values <- renderPrint({
    tab <- input$main_tabs %||% "inputs"

    switch(tab,
      inputs = list(
        buttons = list(
          primary   = input$btn_primary,
          secondary = input$btn_secondary,
          tertiary  = input$btn_tertiary
        ),
        text = list(
          text    = input$inp_text,
          email   = input$inp_email,
          number  = input$inp_num,
          message = input$inp_msg,
          search  = input$inp_search,
          suggest = input$inp_suggest
        ),
        selection = list(
          chk_a        = input$chk1,
          chk_b        = input$chk2,
          notif_email  = input$notif_email,
          notif_sms    = input$notif_sms,
          notif_push   = input$notif_push,
          country      = input$sel_country
        ),
        view_mode = input$view_mode
      ),
      layout = list(
        pagination = input$page_nav
      ),
      list(tab = tab, note = "no reactive inputs on this tab")
    )
  })
}

shinyApp(ui, server)
