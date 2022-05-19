# app/view/exposures

box::use(
  shiny[
    moduleServer, NS, plotOutput, renderPlot, req
  ]
)

box::use(
  app/logic/viz_exposures[viz_exposures]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  plotOutput(ns("exposures_chart"))

}

#' @export
server <- function(id, tkr, tbl) {
  moduleServer(id, function(input, output, session) {

    output$exposures_chart <- renderPlot({
      req(length(tkr() > 0))
      viz_exposures(tkr(), tbl)
    })
  })
}
