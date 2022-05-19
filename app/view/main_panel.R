# file: app/view/main_panel.R

box::use(
  shiny[
    column, div, fluidRow, h3, mainPanel, moduleServer, NS,
    tabsetPanel, tabPanel
  ]
)

box::use(
  app/logic/calc_dr[calc_dr],
  app/view/exposures,
  app/view/price_summary
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  mainPanel(
    fluidRow(
      tabsetPanel(
        id = ns("return-tabs"),
        tabPanel("QTD", price_summary$ui(ns("qtd"))),
        tabPanel("YTD", price_summary$ui(ns("ytd"))),
        tabPanel("TTM", price_summary$ui(ns("ttm"))),
      )
    ),
    fluidRow(
      column(6, h3("Exposures"), exposures$ui(ns("current")))
    ),
    width = 8
  )
}

#' @export
server <- function(id, tkr, show_returns, exp_tbl) {
  moduleServer(id, function(input, output, session) {
    price_summary$server("qtd", tkr, calc_dr("qtd"), show_returns)
    price_summary$server("ytd", tkr, calc_dr("ytd"), show_returns)
    price_summary$server("ttm", tkr, calc_dr("ttm"), show_returns)
    exposures$server("current", tkr, exp_tbl)
  })
}
