# Basic Designsystemet Shiny Example
# Run with: shiny::runApp(system.file("examples/basic", package = "shinyds"))

library(shiny)
library(bslib)
library(shinyds)

ui <- bslib::page_fluid(
  use_designsystemet(),

  tags$div(
    style = "max-width: 600px; margin: 2rem auto; padding: 1rem;",

    ds_heading("Hello Designsystemet!", level = 1),
    ds_paragraph("A simple example using Norwegian government design components."),

    ds_divider(),

    ds_card(
      ds_card_block(
        ds_heading("Contact Form", level = 2, size = "md"),

        ds_field(
          ds_label("Your name", `for` = "name"),
          ds_input("name", placeholder = "Enter your name")
        ),

        ds_field(
          ds_label("Email address", `for` = "email"),
          ds_input("email", type = "email", placeholder = "name@example.com")
        ),

        ds_checkbox("subscribe", label = "Subscribe to newsletter"),

        tags$div(
          style = "margin-top: 1rem;",
          ds_button("Submit", inputId = "submit", variant = "primary")
        )
      )
    ),

    ds_divider(),

    ds_alert("Your form data will appear below when you interact with the form.", variant = "info"),

    verbatimTextOutput("output")
  )
)

server <- function(input, output, session) {
  output$output <- renderPrint({
    list(
      name = input$name,
      email = input$email,
      subscribe = input$subscribe,
      submit_clicks = input$submit
    )
  })
}

shinyApp(ui, server)
