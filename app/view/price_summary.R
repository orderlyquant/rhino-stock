# app/view/price_summary

box::use(
  shiny[
    fluidPage, fluidRow,
    moduleServer,
    NS,
    plotOutput,
    renderPlot, renderText,
    tags,
    textOutput
  ]
)

box::use(
  app/logic/viz_price_chart
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      tags$h3(
        textOutput(ns("ticker"))
      )
    ),
    fluidRow(
      plotOutput(ns("price_chart"))
    )
  )
}

#' @export
server <- function(id, tkr) {
  moduleServer(id, function(input, output, session) {
    output$ticker <- renderText(tkr())
    output$price_chart <- renderPlot(
      viz_price_chart$viz_price_chart(tkr(), from = "2021-12-31", to = "2022-05-13")
    )
  })
}
