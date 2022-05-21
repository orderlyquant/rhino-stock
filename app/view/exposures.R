# app/view/exposures

box::use(
  shiny[
    div, h4, moduleServer, NS, plotOutput, renderPlot, req, tagList
  ]
)

box::use(
  app/logic/viz_exposures[viz_exposures]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(
      h4(class = "component-title", "Exposures"),
      div(
        class = "component-box",
        plotOutput(ns("exposures_chart"))
      )
    )
  )
}

#' @export
server <- function(id, tkr, exp_tbl, risk_tbl) {
  moduleServer(id, function(input, output, session) {
    
    output$exposures_chart <- renderPlot({
      req(length(tkr() > 0))
      viz_exposures(tkr(), exp_tbl, risk_tbl)
    })
  })
}
