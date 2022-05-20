# app/main.R

box::use(
  dplyr[arrange, count, filter, mutate, pull],
  shiny[
    actionButton, bindEvent, checkboxInput,
    fluidPage, fluidRow, HTML,
    moduleServer, navbarPage, NS, reactive,
    renderUI, req,
    sidebarLayout, sidebarPanel, textInput,
    titlePanel, uiOutput, wellPanel
  ],
)

box::use(
  app/view/main_panel,
  app/logic/parse_ticker[parse_ticker]
)


exp_tbl <- readRDS("./app/static/sample_security_exposures.rds")
char_tbl <- readRDS("./app/static/2022-05-20 - characterstics.rds")

# move to shiny logic later
# "context" will change which RDS to read for risk summary
# this will allow you to use:
#
# 1 Exposure             exposure_active         195
# 2 Exposure             exposure_bench          195
# 3 Exposure             exposure_port           195
#
# exposure_port, exposure_bench generically
#
# ideas:
#  - make port and bench explicit in risk rds file names
#  - have a variable that holds
#    dir("app/static", pattern = ".rds") |> grep("risk", x = _, value = TRUE)
#    and parses it for port and bench

risk_tbl <- readRDS("./app/static/2022-05-20 - smid risk summary.rds")



#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(

    titlePanel("rhino - stock"),

    sidebarLayout(
      sidebarPanel = sidebarPanel(
        fluidRow(
          textInput(
            ns("ticker"),
            label = "Ticker",
            value = "AAPL"
          )
        ),
        fluidRow(
          actionButton(
            ns("update"),
            label = "Update"
          )
        ),
        fluidRow(
          checkboxInput(
            ns("returns"),
            label = "Show returns",
            value = FALSE
          )
        ),
        fluidRow(
          uiOutput(ns("ticker_summary"))
        ),
        width = 3
      ),
      main_panel$ui(ns("main_panel"))
    )
  )
}

#' @export
server <- function(id) {

  moduleServer(id, function(input, output, session) {

    cur_ticker <- reactive(parse_ticker({input$ticker})) |>
      bindEvent(input$update)
    show_returns <- reactive({input$returns})

    main_panel$server("main_panel", cur_ticker, show_returns, exp_tbl, char_tbl)

    output$ticker_summary <- renderUI({
      req(length(cur_ticker() > 0))
      exp_tbl |>
        filter(ticker %in% cur_ticker()) |>
        count(ticker, security) |>
        mutate(display = paste0(ticker, " - ", security)) |>
        mutate(ticker = factor(ticker, cur_ticker())) |> 
        arrange(ticker) |> 
        pull(display) |>
        paste(collapse = "<br>") |>
        HTML()
    })

  })
}
