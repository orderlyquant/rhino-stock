# app/logic/calc_dr

box::use(
  dplyr[case_when],
  lubridate[floor_date, years]
)

calc_dr <- function(pd) {
  yday <- Sys.Date() - 1
  case_when(
    pd == "qtd" ~ c(floor_date(yday, "quarter"), yday),
    pd == "ytd" ~ c(floor_date(yday, "year"), yday),
    pd == "ttm" ~ c(yday - years(1), yday)
  )
}
