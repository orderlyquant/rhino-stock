# file: app/view/main_panel.R

box::use(
  shiny[
    column, div, fluidRow, h4, mainPanel, moduleServer, NS,
    tabsetPanel, tabPanel
  ]
)

box::use(
  app/logic/calc_dr[calc_dr],
  app/view/characteristics,
  app/view/exposures,
  app/view/price_summary
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  mainPanel(
    tabsetPanel(
      id = ns("main_tabs"),
      tabPanel(
        "Overview",
        div(
          h4("Performance"),
          div(
            class = "components-container-1w",
            div(
              class = "component-box",
              tabsetPanel(
                id = ns("return_tabs"),
                tabPanel("QTD", price_summary$ui(ns("qtd"))),
                tabPanel("YTD", price_summary$ui(ns("ytd"))),
                tabPanel("TTM", price_summary$ui(ns("ttm"))),
              )
            )
          )
        ),
        fluidRow(
          div(
            class = "components-container-2w",
            exposures$ui(ns("cur_exp")),
            characteristics$ui(ns("cur_char"))
          )
        ),
        width = 8),
      tabPanel(
        "Risk"
      )
    )
  )
  
}

#' @export
server <- function(id, tkr, show_returns, exp_tbl, char_tbl, risk_tbl) {
  moduleServer(id, function(input, output, session) {
    price_summary$server("qtd", tkr, calc_dr("qtd"), show_returns)
    price_summary$server("ytd", tkr, calc_dr("ytd"), show_returns)
    price_summary$server("ttm", tkr, calc_dr("ttm"), show_returns)
    exposures$server("cur_exp", tkr, exp_tbl, risk_tbl)
    characteristics$server("cur_char", tkr, char_tbl)
  })
}
