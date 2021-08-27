
# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libraries.R"))

# -----------------------------------------------------------------------------
# corpus data obtained from: https://www.openslr.org/resources.php

# load tidy textgrid data 
f_data <- read.csv(here("corpus_data", "tidy", "female_tidy.csv"))


# clean up words and detect "ado" participles
f_data$word <- gsub('[[:punct:] ]+',' ',f_data$word)
f_data$word <- tolower(f_data$word)
f_data$word <- trimws(f_data$word)
f_data$word2 <- str_detect(f_data$word, "ante")
f_data$word3 <- str_detect(f_data$word, "ante.")

# load frequency data 
corpus <- read.csv(here("lexicalfrequencydata", "subtlex_tidy.csv"))

# join frequency data with textgrid data 


words_df <- left_join(f_data, corpus, by = "word") %>% 
  mutate("duration" = xmax - xmin)


merge_df <- words_df %>% 
  filter(tier_name == "ORT-MAU") %>% 
  filter(!word == "") %>% 
  mutate(length = nchar(word)) %>% 
  filter(length == 4:8)

mod <- lmer(duration ~ log_freq + rate + length + (1 | word), data = merge_df)

mod <- brms::brm(duration ~ log_freq + rate + length + (1 | word), data = merge_df)

fixef(mod)

merge_df %>% 
  write.csv(here("corpus_data", "tidy", "span_tidy.csv"))

mod_s <- mod %>% 
  as.data.frame()

mod %>% 
  write_rds(here("corpus_data", "models", "span_model_bayes.RDS"))

brms::hdi(mod$

summary(mod)

merge_df %>% 
  group_by(word) %>% 
  summarise(n = n(), duration = mean(duration))  %>% 
  left_join(., corpus, by = "word") %>%
  mutate(log_freq = log(count)) %>% 
  mutate(length = nchar(word)) %>% 
  ggplot(aes(x = log_freq, y = duration)) + geom_point() + geom_smooth()









