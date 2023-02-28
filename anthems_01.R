# R script for uhhh....ease?


# load these 
library(tidyverse)
library(rvest)
library(tidytext)
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

# check it out
View(anthems)

# unnest tokens from data set, making new data set
df2 <- anthems %>% unnest_tokens(word, anthem)


df3 <- df2 %>% 
  anti_join(stop_words)


df3 %>% count(word, sort = TRUE) %>% View()

# bar plot of top ten most frequent words
df3 %>% count(word, sort = TRUE) %>% head(n = 10) %>% 
  ggplot(aes(x = word, y = n))+
  geom_col()

# how many continets in this data set?
unique(anthems$continent) 


