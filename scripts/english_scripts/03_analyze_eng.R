#------------------------------------------------------------------------------
# title: 03_analyze_eng
# author: Kyle Parrish
# last edit: 8/25/2021
# description: 
#------------------------------------------------------------------------------

freq <- read.csv(here("eng_corpus_data", "tidy", "unigram_freq.csv"))

eng_tidy <- read.csv(here("eng_corpus_data", "tidy", "eng_tidy.csv"))


eng_tidy$word <- gsub('[[:punct:] ]+',' ',eng_tidy$word)
eng_tidy$word <- tolower(eng_tidy$word)
eng_tidy$word <- trimws(eng_tidy$word)

merge_df <- left_join(eng_tidy, freq, by = "word") %>% 
  mutate(log_freq = log(count), duration = xmax - xmin)


filt <- merge_df %>% 
  filter(tier_name == "ORT-MAU") %>% 
  filter(!word == "") %>% 
  mutate(length = nchar(word)) %>% 
  filter(length == 4:8)

mod <- lmer(duration ~ log_freq + rate + length + (1 | word), data = filt)
mod <- brms::brm(duration ~ log_freq*length*rate + (1 | word), data = filt)
fixef(mod)

mod %>% 
  write_rds(here("corpus_data", "models", "eng_model_bayes.RDS"))

filt %>% 
  write.csv(here("corpus_data", "tidy", "eng_tidy.csv"))

summary(mod)

fixef <- fixef(mod) %>% as.data.frame()

# change in duration for every unit of log freq 

fixef$.[1] # duration when log freq is 10
fixef$.[2] # change in ms per 1 unit log frequency

# on average, a decrease of 1.5ms per 1 unit log frequency 

filt %>% 
  group_by(word) %>% 
  summarise(n = n(), duration = mean(duration))  %>% 
  left_join(., freq, by = "word") %>%
  mutate(log_freq = log(count)) %>% 
  mutate(length = nchar(word)) %>% 
  ggplot(aes(x = log_freq, y = duration)) + geom_point() + geom_smooth() 


filt %>% 
  group_by(word) %>% 
  #summarise(n = n(), duration = mean(duration))  %>% 
  #left_join(., freq, by = "word") %>%
  #mutate(log_freq = log(count)) %>% 
  #mutate(length = nchar(word)) %>% 
  ggplot(aes(x = log_freq, y = duration)) + geom_point() + geom_smooth()






sound_df <- merge_df %>% 
  group_by(text) %>% 
  summarise(n = n())

mean_df <- merge_df %>% 
  group_by(word) %>% 
  summarise(n = n(), duration_m = mean(duration), duration_sd = sd(duration)) %>% 
  left_join(., freq, by = "word") %>% 
  mutate(log_freq = log(count))


# run model for a particular segment 
mod_df <- merge_df %>% 
  filter(text == "red") 

mod <- merge_df %>% 
  filter(text == "read") 

mean(mod_df$duration)
sd(mod_df$duration)
mean(mod$duration)
sd(mod$duration)

t.test(mod_df$duration, mod$duration)

words <- mod_df %>% 
  group_by(word) %>% 
  summarise(n = n()) %>%  
  left_join(., freq, by = "word") %>% 
  mutate(log_freq = log(count))


word1 <- merge_df %>% 
  filter(text == "i:") %>% 
  filter(word == "think")

word2 <- merge_df %>% 
  filter(text == "i:") %>% 
  filter(word == "see")

t.test(word1$duration, word2$duration)

mod_df %>% 
  

mod <- lmer(duration ~ log_freq*rate + (1 | word), data = mod_df)

summary(mod)
# conwell (2018) https://journals-sagepub-com.proxy.libraries.rutgers.edu/doi/pdf/10.1177/0023830917737108
### word duration was distinct, but not vowel duration. 