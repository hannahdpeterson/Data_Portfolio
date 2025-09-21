library(rvest)
library(tidyverse)
library(readr)
# everytime we reload this tibble, it will be for the losers of the day
# run again and for the new day and it will add to the history
url <- "https://stockanalysis.com/markets/losers/"
page <- read_html(url)

# Grabbing each loser row
l_stock_line <- page |> html_nodes("#main-table > tbody > tr")

# Grabbing losing stocks:
l_stocks <- tibble(
  number  = l_stock_line |> html_node("td:nth-child(1)") |> html_text(trim = TRUE),
  symbol  = l_stock_line |> html_node("td.sym.svelte-1ro3niy") |> html_text(trim = TRUE),
  company = l_stock_line |> html_node("td.slw.svelte-1ro3niy") |> html_text(trim = TRUE),
  perc_change = l_stock_line |> html_node("td.rr.svelte-1ro3niy") |> html_text(trim = TRUE),
  price   = l_stock_line |> html_node("td:nth-child(5)") |> html_text(trim = TRUE),
  volume  = l_stock_line |> html_node("td:nth-child(6)") |> html_text(trim = TRUE),
  market_cap = l_stock_line |> html_node("td:nth-child(7)") |> html_text(trim = TRUE)
)

# Clean up columns (I want these to be classed as numeric and character, respectfully)
l_stocks <- l_stocks |>
  mutate(
    number = as.numeric(number),
    symbol = as.character(symbol),
    company = as.character(company),
    perc_change = parse_number(perc_change), # remove percent symbols
    price = parse_number(price),
    volume = parse_number(volume), # removes commas
    market_cap = parse_number(market_cap) * 1e6, # converst to millions, removes M
    date = Sys.Date()) # adding the date for continuity

# file
file <- "L_Stocks_History.csv"

# combining with old data if theres old data present
if (file.exists(file)) {old <- read_csv(file, show_col_types = FALSE)
  
  old <- old |> # assuring same type of data so it properly combines
    mutate(
      number = as.numeric(number),
      symbol = as.character(symbol),
      company = as.character(company),
      perc_change = as.numeric(perc_change),
      price = as.numeric(price),
      volume = as.numeric(volume),
      market_cap = as.numeric(market_cap),
      date = as.Date(date))
  
  if (!Sys.Date() %in% old$date) { # just in case this is being reused on a date
    combined <- bind_rows(old, l_stocks) # that is already saved
    write_csv(combined, file)} else {message("
    Today's dates already exist in the file. No additions made."
                                             )}} else 
                                               {write_csv(l_stocks, file)}

