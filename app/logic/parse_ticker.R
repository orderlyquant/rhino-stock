# app/logic/parse_ticker.R

box::use(
  stringr[str_remove_all, str_split, str_to_upper]
)

parse_ticker <- function(tkr) {
  tkr |> str_to_upper() |> str_remove_all(" ") |> str_split(pattern = ",") |> unlist()
}