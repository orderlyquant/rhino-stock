# app/logic/parse_ticker.R

box::use(
  stringr[str_split, str_remove_all]
)

parse_ticker <- function(tkr) {
  tkr |> str_remove_all(" ") |> str_split(pattern = ",") |> unlist()
}