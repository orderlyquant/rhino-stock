# file: app/logic/calc_dr

box::use(
  dplyr[case_when],
  lubridate[floor_date, years]
)

#' @export
calc_dr <- function(pd) {

  # this date convention works with tq_get, which returns
  # pricing up until the previous day
  today <- Sys.Date()
  case_when(
    pd == "qtd" ~ c(floor_date(today, "quarter") - 1, today),
    pd == "ytd" ~ c(floor_date(today, "year") - 1, today),
    pd == "ttm" ~ c(today - years(1), today)
  )
}
