# app/view/main_panel.R

box::use(
  shiny[
    fluidRow,
    mainPanel,
    moduleServer, NS,
    plotOutput, renderPlot,
    renderText,
    tags,
    textOutput
  ]
)

box::use(
  app/view/price_summary
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  mainPanel(
    price_summary$ui(ns("ytd"))
  )
}

#' @export
server <- function(id, tkr) {
  moduleServer(id, function(input, output, session) {
    price_summary$server("ytd", tkr)
  })
}
