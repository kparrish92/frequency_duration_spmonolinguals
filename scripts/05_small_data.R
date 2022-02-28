library(here)
library(tidyverse)
# load needed data 
span_data <- read.csv(here("corpus_data", "tidy", "span_tidy.csv"))
eng_data <- read.csv(here("corpus_data", "tidy", "eng_tidy.csv"))
span_model  <- read_rds(here("corpus_data", "models", "span_model_bayes.RDS"))
eng_model <- read_rds(here("corpus_data", "models", "eng_model_bayes.RDS"))
fixef_df_span <- fixef(span_model) %>% 
  as.data.frame()
fixef_df_eng <- fixef(eng_model) %>% 
  as.data.frame()
span_model_df <- span_model %>% 
  as.data.frame()
hdi_span <- hdi(span_model_df$b_log_freq_z) 

# calculate range of difference from most to least frequent tokens 
low = (fixef(span_model)[2,1]*min(span_data$log_freq, na.rm=TRUE) + fixef(span_model)[1,1])*1000 %>% 
  as.data.frame()
high = (fixef(span_model)[2,1]*max(span_data$log_freq, na.rm=TRUE) + fixef(span_model)[1,1])*1000 %>% 
  as.data.frame()
low_e = (fixef(eng_model)[2,1]*min(eng_data$log_freq, na.rm=TRUE) + fixef(eng_model)[1,1])*1000 %>% 
  as.data.frame()
high_e = (fixef(eng_model)[2,1]*max(eng_data$log_freq, na.rm=TRUE) + fixef(eng_model)[1,1])*1000 %>% 
  as.data.frame()

low_obs_e <- min(eng_data$log_freq, na.rm=TRUE)
slope_e <- fixef(eng_model)[2,1]
int_e <- fixef(eng_model)[1,1]

low_obs_s <- min(span_model$log_freq, na.rm=TRUE)
slope_s <- fixef(span_model)[2,1]
int_s <- fixef(span_model)[1,1]
# when x = 10.27, y = .559
# what does y equal when x = 0?
# multiple low_obs by slope minus intercept 
y_int_e <- (low_obs_e*slope_e)*-1 + int_e
y_int_s <- (slope_s*slope_s)*-1 + int_s

fixef_df_eng <- fixef(eng_model) %>% 
  as.data.frame()
eng_model_df <- eng_model %>% 
  as.data.frame()
hdi_eng <- hdi(eng_model_df$b_log_freq) 

corpus <- read.csv(here("lexicalfrequencydata", "subtlex_tidy.csv"))
freq <- read.csv(here("eng_corpus_data", "tidy", "unigram_freq.csv"))

# for plots 
span_post <- as_tibble(span_model) %>% 
  select(int = b_Intercept, b = b_log_freq_z)
eng_post <- as_tibble(eng_model) %>% select(int = b_Intercept, b = b_log_freq_z) 
