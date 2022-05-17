# app/view/price_summary

box::use(
  shiny[
    fluidRow, moduleServer, NS, plotOutput, renderPlot
  ]
)

box::use(
  app/logic/viz_price_chart[viz_price_chart]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidRow(
    plotOutput(ns("price_chart"))
  )
}

#' @export
server <- function(id, tkr, dr, show_returns) {
  moduleServer(id, function(input, output, session) {
    output$price_chart <- renderPlot(
      viz_price_chart(tkr(), dr, show_returns())
    )
  })
}
