# Old Faithful - Designsystemet edition
# Inspired by https://shiny.posit.co/r/gallery/start-simple/faithful/
#
# Run with: shiny::runApp(system.file("examples/faithful", package = "shinyds"))

library(shiny)
library(bslib)
library(shinyds)

ui <- bslib::page_fluid(
  use_designsystemet(),

  tags$div(
    style = "max-width: 900px; margin: 0 auto; padding: 2rem 1rem;",

    ds_heading("Old Faithful Geyser", level = 1, size = "xl"),
    ds_paragraph(
      "Explore eruption duration and waiting time data from the Old Faithful geyser
       in Yellowstone National Park.",
      size = "md"
    ),

    tags$div(style = "margin: 1.5rem 0;",
      ds_tabs("main_tabs",
        ds_tablist(
          ds_tab("Histogram", value = "histogram", selected = TRUE),
          ds_tab("Scatter plot", value = "scatter"),
          ds_tab("Summary", value = "summary")
        ),

        # --- Histogram tab ---
        ds_tabpanel(
          value = "histogram",
          tags$div(style = "padding: 1.5rem 0;",
            bslib::layout_sidebar(
              fill   = FALSE,
              border = FALSE,
              sidebar = bslib::sidebar(
                width = 260,
                ds_card(
                  ds_card_block(
                    ds_heading("Controls", level = 3, size = "sm"),
                    ds_field(
                      ds_label("Number of bins", `for` = "bins"),
                      sliderInput("bins", label = NULL,
                        min = 5, max = 50, value = 25, step = 1)
                    ),
                    tags$div(style = "margin-top: 1rem;",
                      ds_field(
                        ds_label("Variable", `for` = "hist_var"),
                        ds_select("hist_var",
                          choices = c(
                            "Eruption duration (min)" = "eruptions",
                            "Waiting time (min)"      = "waiting"
                          )
                        )
                      )
                    ),
                    tags$div(style = "margin-top: 1.5rem;",
                      ds_alert(
                        tags$strong("272 observations"),
                        " collected from 1990.",
                        variant = "info"
                      )
                    )
                  )
                )
              ),
              plotOutput("hist_plot", height = "380px")
            )
          )
        ),

        # --- Scatter tab ---
        ds_tabpanel(
          value = "scatter",
          tags$div(style = "padding: 1.5rem 0;",
            bslib::layout_sidebar(
              fill   = FALSE,
              border = FALSE,
              sidebar = bslib::sidebar(
                width = 260,
                ds_card(
                  ds_card_block(
                    ds_heading("Controls", level = 3, size = "sm"),
                    ds_field(
                      ds_label("Point size", `for` = "point_size"),
                      sliderInput("point_size", label = NULL,
                        min = 0.5, max = 4, value = 1.5, step = 0.5)
                    ),
                    tags$div(style = "margin-top: 1rem;",
                      ds_checkbox("show_smooth", label = "Show trend line",
                        value = TRUE)
                    ),
                    tags$div(style = "margin-top: 0.5rem;",
                      ds_checkbox("show_rug", label = "Show rug plot")
                    )
                  )
                )
              ),
              plotOutput("scatter_plot", height = "380px")
            )
          )
        ),

        # --- Summary tab ---
        ds_tabpanel(
          value = "summary",
          tags$div(style = "padding: 1.5rem 0;",
            bslib::layout_columns(
              col_widths = c(6, 6, 12),
              ds_card(
                ds_card_block(
                  ds_heading("Eruption duration (min)", level = 3, size = "sm"),
                  verbatimTextOutput("summary_eruptions")
                )
              ),
              ds_card(
                ds_card_block(
                  ds_heading("Waiting time (min)", level = 3, size = "sm"),
                  verbatimTextOutput("summary_waiting")
                )
              ),
              ds_card(
                ds_card_block(
                  ds_heading("Correlation", level = 3, size = "sm"),
                  tags$p(
                    "Eruptions and waiting time have a correlation of ",
                    tags$strong(textOutput("correlation", inline = TRUE)),
                    ", suggesting longer eruptions tend to follow longer waiting periods."
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {

  output$hist_plot <- renderPlot({
    var     <- input$hist_var %||% "eruptions"
    n_bins  <- input$bins %||% 25
    x       <- faithful[[var]]
    label   <- if (var == "eruptions") "Eruption duration (min)" else "Waiting time (min)"

    breaks <- seq(min(x), max(x), length.out = n_bins + 1)

    hist(x,
      breaks  = breaks,
      col     = "#0062BA",
      border  = "white",
      main    = NULL,
      xlab    = label,
      ylab    = "Frequency",
      las     = 1
    )
  })

  output$scatter_plot <- renderPlot({
    cex <- input$point_size %||% 1.5

    plot(faithful$waiting, faithful$eruptions,
      pch  = 19,
      cex  = cex,
      col  = adjustcolor("#0062BA", alpha.f = 0.6),
      xlab = "Waiting time (min)",
      ylab = "Eruption duration (min)",
      main = NULL,
      las  = 1
    )

    if (isTRUE(input$show_smooth)) {
      fit <- loess(eruptions ~ waiting, data = faithful)
      xs  <- seq(min(faithful$waiting), max(faithful$waiting), length.out = 100)
      lines(xs, predict(fit, data.frame(waiting = xs)),
        col = "#C01B33", lwd = 2)
    }

    if (isTRUE(input$show_rug)) {
      rug(faithful$waiting, side = 1, col = "#0062BA")
      rug(faithful$eruptions, side = 2, col = "#0062BA")
    }
  })

  output$summary_eruptions <- renderPrint(summary(faithful$eruptions))
  output$summary_waiting   <- renderPrint(summary(faithful$waiting))

  output$correlation <- renderText({
    round(cor(faithful$eruptions, faithful$waiting), 3)
  })

  # Render outputs even when their tab panel is hidden
  outputOptions(output, "scatter_plot",      suspendWhenHidden = FALSE)
  outputOptions(output, "summary_eruptions", suspendWhenHidden = FALSE)
  outputOptions(output, "summary_waiting",   suspendWhenHidden = FALSE)
  outputOptions(output, "correlation",       suspendWhenHidden = FALSE)
}

shinyApp(ui, server)
