rm(list = ls())

# Getting my own list of National Anthems across the world by web scraping

library(rvest)
library(tidyverse)
library(stringr)

# I am scraping the list of national anthems from the CIA world factbook

countries <- read_html("https://www.cia.gov/the-world-factbook/field/national-anthem/") %>%
  html_elements("li") 

# there are 240 countries listed (though not all have unique anthems)

d <- countries %>%
  
  # scraping by the 'h2' html element,
  html_elements("h2") %>%
  
  # extracting the text,
  html_text2() %>%
  
  # and making it into a dataframe (enframe converts named atomic vectors into lists or one- or two column data frames)
  enframe("count", "country")

# I managed to get all the 240 countries listed, but I want the names of each
# national anthem the names of each anthem are contained within <p> html
# elements as '#text" however, the best solution I found was to go to the url
# page, inspect element, and copy xpath.
# I didn't need the whole path, just the first line of 'text()'

names <- countries %>%
  html_elements("p") %>%
  html_elements(xpath = 'text()[1]') %>%
  html_text2()

# binding the countries to the names of their national anthems
df <- bind_cols(d, "anthem_names" = names)

# I don't need that 'count' column variable
df <- df %>%
  select(country, anthem_names)

write.csv(df, file = "data-raw/national_anthems_240.csv")
save(df, file= "data-raw/national_anthems.Rdata")

# I need the actual lyrics for each national anthem still. 

#####
# The cia site did this annoying thing where they didn't standardize the lists
# underneath each country, and added various facts about each
# country's anthem. So some countries have [name, lyrics/music, note],
# while others have [name, note, note note] or some shit.
# They also added random non-countries like "World" 
# I didn't run the stuff below but this gives you an idea

# writers_composers <- countries %>%
#   html_elements("p") %>%
#   html_elements(xpath = 'text()[2]') %>%
#   html_text2()
# 
# notes <- countries %>%
#   html_elements("p") %>%
#   html_elements(xpath = 'text()[3]') %>%
#   html_text2()
#####

