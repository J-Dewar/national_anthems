library(dplyr)
library(tidytext)
library(stringr)
library(tidyverse)
library(broom)
library(tidyr)

anthem <- read.csv("anthems.csv")

anthem_sentiment <- anthem_tidy %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(document, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)





