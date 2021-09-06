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
  filter(length == 4:8) %>% 
  filter(!is.na(log_freq))

filt$log_freq_z = scale(filt$log_freq)
filt$duration_z = scale(filt$duration)
filt$length_z = scale(filt$length)
filt$rate_z = scale(filt$rate)


mod <- brms::brm(duration_z ~ log_freq_z + length_z + rate_z + (1 | word), data = filt)
fixef(mod)

mod %>% 
  write_rds(here("corpus_data", "models", "eng_model_bayes.RDS"))

filt %>% 
  write.csv(here("corpus_data", "tidy", "eng_tidy.csv"))


# conwell (2018) https://journals-sagepub-com.proxy.libraries.rutgers.edu/doi/pdf/10.1177/0023830917737108
### word duration was distinct, but not vowel duration. 