# app/view/main_panel.R

box::use(
  shiny[
    fluidRow,
    mainPanel,
    moduleServer, NS,
    renderText,
    tags,
    textOutput
  ]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  mainPanel(
    tags$h3(
      textOutput(ns("message"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$message <- renderText("Hello!")
  })
}
