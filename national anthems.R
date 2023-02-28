library(dplyr)
library(tidytext)
library(stringr)
library(tidyverse)
library(broom)
library(tidyr)
library(textdata)

anthem <- rio::import("data-raw/anthems.csv") %>% 
  janitor::clean_names()

tidy_anthem <- anthem %>%
  unnest_tokens(word, anthem)

tidy_anthem <- tidy_anthem %>%
  anti_join(stop_words)

anthem_sentiment <- tidy_anthem %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(Country, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

saveRDS(anthem_sentiment, "anthem_sentiments.rds")


anthem_sentiment_continent <- tidy_anthem %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(continent, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

saveRDS(anthem_sentiment_continent, "anthem_sentiments continent.rds")


p2 <- ggplot(anthem_sentiment_continent, aes(continent, sentiment, fill = continent)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~continent, ncol = 2, scales = "free_x")

nrc_anthem_sentiment_continent <- tidy_anthem %>%
  inner_join(get_sentiments("nrc"), by="word") %>%
  count(continent, sentiment) %>% 
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0)

# make another data frame of the NRC sentiment stuff in long format
nrc_senti_long <- tidy_anthem %>%
  inner_join(get_sentiments("nrc"), by="word") %>%
  count(continent, sentiment)


# convert sentiment variable from character class to factor 
nrc_senti_long$sentiment <- nrc_senti_long$sentiment %>% 
  unique() %>%
  as_factor()

# check to see if all 10 levels of sentiment are in factor
levels(nrc_senti_long$sentiment)

# create facet plot of raw counts of nrc sentiment by continent
p3 <- nrc_senti_long %>%
  ggplot(aes(x = continent, y = n))+
  geom_col() + 
  scale_x_discrete(guide = guide_axis(angle = 45))+ # this angles the x-axis labels by 45 degrees
  facet_wrap(vars(sentiment), scales = "free_x")

# save as pdf in 'figures' folder
ggsave('nrc_sentiment_by_continent_counts.pdf',
       plot = p3,
       device = "pdf",
       path = "~/R/national_anthems/figures/")



ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity", position=position_dodge())