# file: app/logic/calc_dr

box::use(
  dplyr[all_of, any_of, arrange, filter, left_join, mutate, relocate, rename, select, tibble],
  gt[gt, fmt_missing, fmt_number, tab_header],
  gtExtras[gt_theme_nytimes],
  oqthemes[scale_fill_oq],
  stringr[str_replace],
  tidyr[pivot_longer, pivot_wider]
)

#' @export
tbl_characteristics <- function(tkr, tbl) {

  key_characteristics <- tibble(
    codes = c(
      "current_market_value", "fql_beta_r1kg", "pe_ntm", "p_bk",
      "free_cash_flow_margin", "free_cash_flow_yield"
    ),
    names =c(
      "Market Cap (bn)", "Beta", "P/E (NTM)", "P/B",
      "FCF Margin", "FCF Yield"
    )
  )
  
  # Fix for BRK-B and BRK-A, others?
  tkr <- str_replace(tkr, "-", ".")
  
  tbl <- tbl |> 
    rename(ticker = company_symbol)
  
  key_char_tbl <- tbl |>
    filter(ticker %in% tkr) |>
    select(all_of(c("ticker", key_characteristics$codes))) |>
    mutate(
      current_market_value = current_market_value / 1000
    ) |> 
    pivot_longer(cols = -ticker, names_to = "codes") |> 
    mutate(
      codes = factor(codes, key_characteristics$codes),
      ticker = factor(ticker, tkr)
    ) |> 
    arrange(codes, ticker) |> 
    pivot_wider(names_from = ticker, values_from = value) |> 
    left_join(key_characteristics, by = "codes") |> 
    select(-codes) |> 
    relocate(names) |> 
    gt(rowname_col = "names") |> 
    # tab_header(title = "Key Fundamentals") |> 
    fmt_number(
      columns = any_of(tkr),
      decimals = 1
    ) |> 
    fmt_number(
      columns = any_of(tkr),
      rows = all_of(c("Beta")),
      decimals = 2
    ) |> 
    fmt_missing(columns = any_of(tkr)) |> 
    gt_theme_nytimes()
  
}
