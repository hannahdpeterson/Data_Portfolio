library(rvest)
library(tidyverse)

url <- "https://hianime.to/top-airing"
page <- read_html(url)

# Grab each anime box
animes <- page %>% html_nodes(".flw-item")

# Extracting title, duration, japanese episodes and dubbed english episode:
anime <- tibble(
  anime_name = animes %>% html_node(".dynamic-name") %>% html_text(trim = TRUE),
  duration_min = animes %>% html_node(".fdi-duration") %>% html_text(trim = TRUE),
  japanese_ep = animes %>% html_node(".tick-item.tick-sub") %>% html_text(trim = TRUE),
  english_ep = animes %>% html_node(".tick-item.tick-dub") %>% html_text(trim = TRUE)
)

# cleaning duration column (do not want the "m" so it stays numerical)
anime <- anime %>%
  mutate(duration_min = str_remove(duration_min, "m") %>% as.numeric())

view(anime)
write_csv(anime, "anime.csv")
