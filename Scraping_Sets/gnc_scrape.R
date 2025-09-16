library(rvest)
library(tidyverse)

url <- "https://www.gnc.com/food/protein-bars/"
page <- read_html(url)

# Grabbing each product box
products <- page |> html_nodes(".product-tile")

# Grabbing brand, flavor, price, ratings, and reviews:
gnc <- tibble(
  Brand  = products |> html_node(".product-brand") |> html_text(trim = TRUE),
  Flavor = products |> html_node(".product-name") |> html_text(trim = TRUE),
  Rating = products |> html_node(".TTratingBox") |> html_attr("data-starrating"),
  Price  = products |> html_node(".product-standard-price") |> html_text(trim = TRUE)
  )

# Clean up columns (I want a flavor column and a "bar amount" column)
gnc2 <- gnc |>
  mutate(
    Bar_Amount = str_extract(Flavor, "\\d+") |> as.numeric(),
    Flavor = str_extract(Flavor, "(?<=- ).*") |>
      str_replace("\\s*\\(.*\\)$", "") |>
      str_replace("\\s*-\\s*\\d+.*$", "") |>
      str_trim(),
    Price = str_replace_all(Price, "\\$", "") |>
      str_trim() |>
      as.numeric())

# Now only keeping

view(gnc2)
write_csv(gnc2, "gnc2_clean.csv")
