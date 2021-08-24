### This is a script to derive stimuli grouped by lexical frequency based on the data
### made available by Ceutos et al. (2011). They estimate Spanish word frequencies based on
### data from movie subtitles. The manuscript for this study can by found in the repo under
### 'previous_studies', and their data under 'lexical frequency data' 

## Load libraries 

library(tidyverse)
library(dplyr)
library(languageR)


## Read in data 

data = read.csv("./lexicalfrequencydata/test.csv") 

## tidy data and visualize the distribution of log frequency 
## Also filtered for 6 letter words, we can choose other lengths too, but this 
## is just to experimentally control for orthographic word length. We could also
## include other length words statistically control for length. 

six_letterwords = data %>% 
  janitor::clean_names() %>% 
  filter(nchar(as.character(i_word)) == 6)

hist(six_letterwords$log_freq)

