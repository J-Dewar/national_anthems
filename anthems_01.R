# R script for uhhh....ease?


# load these 
library(tidyverse)
library(rvest)
library(tidytext)
library(textdata)
library(pdftools) #Text Extraction, Rendering and Converting of PDF Documents
library(tm)
library(broom)
library(wordcloud2)
library(devtools)
library(janitor)

# where (initial) data was derived from
# we grabbed the anthems.csv file from this github repo
# https://github.com/lucas-de-sa/national-anthems-clustering

# import data
anthems <- rio::import('data-raw/anthems.csv') %>% 
  janitor::clean_names()

# Data set needs to be verified. Some countries that may not have official
# lyrics have lyrics in this data set. Also, some former nation-states' national
# anthems are not included (e.g., USSR). We may want to include them

# check it out
View(anthems)

# how many continents in this data set?
unique(anthems$continent) 
# Europe
# South America
# North America
# Oceania
# Asia
# Africa

# unnest tokens from data set, making new data set
df2 <- anthems %>% unnest_tokens(word, anthem)

# remove stop words from un-tokenized dataset
df3 <- df2 %>% 
  anti_join(stop_words) %>% 
  filter(!word %in% c("thy", "thee", "thou"))

# view frequency counts of words
df3 %>% count(word, sort = TRUE) %>% View()

# wordcloud of anthem
t_cloud <- df3 %>% count(word, sort = TRUE)

wordcloud2(t_cloud)

# bar plot of top ten most frequent words
df3 %>% count(word, sort = TRUE) %>% head(n = 10) %>% 
  ggplot(aes(x = word, y = n))+
  geom_col()

# save figure of 10 most frequent words in national anthems
ggsave("ten_most_frequent_words.pdf",
       plot = last_plot(),
       device = 'pdf',
       path = "~/R/national_anthems/figures/")


# creating a sentiment data-frame
anthem_sentiment <- df3 %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(country, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

# bar plot of sentiments by country with negative sentiment
anthem_sentiment %>% 
  filter(sentiment < 0 ) %>% 
  ggplot(aes(x = country, y = sentiment))+
  geom_col()+
  coord_flip()

# create data-frame of sentiment by continent
anthem_sentiment_continent <- tidy_anthem %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(continent, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

# facet plot of positive sentiment by continent
anthem_sentiment_continent %>% 
  ggplot(aes(continent, sentiment, fill = continent)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~continent, ncol = 2, scales = "free_x")

# create data-frame of sentiment by continent using 'nrc' sentiment lexicon
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
