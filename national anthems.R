library(dplyr)
library(tidytext)
library(stringr)
library(tidyverse)
library(broom)
library(tidyr)
library(textdata)

anthem <- read.csv("anthems.csv")

tidy_anthem <- anthem %>%
  unnest_tokens(word, Anthem)

tidy_anthem <- tidy_anthem %>%
  anti_join(stop_words)

anthem_sentiment <- tidy_anthem %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(Country, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

saveRDS(anthem_sentiment, "anthem_sentiments")


anthem_sentiment_continent <- tidy_anthem %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(Continent, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

saveRDS(anthem_sentiment_continent, "anthem_sentiments continent")


p2 <- ggplot(anthem_sentiment_continent, aes(Continent, sentiment, fill = Continent)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~Continent, ncol = 2, scales = "free_x")


nrc_anthem_sentiment_continent <- tidy_anthem %>%
  inner_join(get_sentiments("nrc"), by="word") %>%
  count(Continent, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0)

df2 <- data.frame(t(nrc_anthem_sentiment_continent[-1]))
colnames(df2) <- continent_names

continent_names <- c("Africa","Asia","Europe", "North America","Oceania",
                     "South America")



p3 <- ggplot(anthem_sentiment_continent, aes(, fill = Continent)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~continent_names, ncol = 2, scales = "free_x")

ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity", position=position_dodge())