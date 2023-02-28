library(dplyr)
library(tidytext)
library(stringr)
library(tidyverse)
library(broom)
library(tidyr)

anthem <- read.csv("anthems.csv")

tidy_anthem <- anthem %>%
  unnest_tokens(word, Anthem)

tidy_anthem <- tidy_anthem %>%
  anti_join(stop_words)

anthem_sentiment <- tidy_anthem %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(document, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)





