
# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libraries.R"))

# -----------------------------------------------------------------------------
# corpus data obtained from: https://www.openslr.org/resources.php

# load tidy textgrid data 
f_data <- read.csv(here("corpus_data", "tidy", "female_tidy.csv")) %>% 
  mutate(gender = "f")

m_data <- read.csv(here("corpus_data", "tidy", "male_tidy.csv")) %>% 
  mutate(gender = "m")


# clean up words and detect "ado" participles
f_data$word <- gsub('[[:punct:] ]+',' ',f_data$word)
f_data$word <- tolower(f_data$word)
f_data$word <- trimws(f_data$word)

m_data$word <- gsub('[[:punct:] ]+',' ',m_data$word)
m_data$word <- tolower(m_data$word)
m_data$word <- trimws(m_data$word)


# load frequency data 
corpus <- read.csv(here("lexicalfrequencydata", "subtlex_tidy.csv"))

# join frequency data with textgrid data 

bind_df <- rbind(m_data, f_data) %>% 
  separate(file, into = c("one", "participant", "three", sep = "_"))

# load bigram phonotactic prob data 

prob_df <- read.csv(here("data", "tidy", "prob_df.csv"))


# bind data and add gender info


words_df_temp <- left_join(bind_df, corpus, by = "word") %>% 
  mutate("duration" = xmax - xmin)

words_df <- left_join(words_df_temp, prob_df, by = "word")

merge_df <- words_df %>% 
  filter(tier_name == "ORT-MAU") %>% 
  filter(!word == "") %>% 
  mutate(length = nchar(word)) %>% 
  filter(length == 4:8) %>% 
  filter(!is.na(log_freq)) %>% 
  filter(!prob == 0)



# nested model comparisons 
mod0 <- lmer(duration ~ 1 + (1 | word) + (1 | participant), data = merge_df)
mod1 <- lmer(duration ~ log_freq + (1 | word) + (1 | participant), data = merge_df)
mod2 <- lmer(duration ~ rate + log_freq + (1 | word) + (1 | participant), data = merge_df)
mod3 <- lmer(duration ~ log_freq + rate + length + (1 | word) + (1 | participant), data = merge_df)
mod4 <- lmer(duration ~ log_freq + rate + length + log_spanish + (1 | word) + (1 | participant), data = merge_df)
mod5 <- lmer(duration ~ log_freq + rate + length + log_spanish + gender + (1 | word) + (1 | participant), data = merge_df)

summary(mod2)

merge_df %>% 
  group_by(word) %>% 
  summarise(n = n(), duration = mean(duration))  %>% 
  left_join(., corpus, by = "word") %>%
  mutate(log_freq = log(count)) %>% 
  mutate(length = nchar(word)) %>% 
  ggplot(aes(x = log_freq, y = duration)) + geom_point() + geom_smooth()



merge_df$log_freq_z = scale(merge_df$log_freq)
merge_df$duration_z = scale(merge_df$duration)
merge_df$length_z = scale(merge_df$length)
merge_df$rate_z = scale(merge_df$rate)



merge_df %>% 
  write.csv(here("corpus_data", "tidy", "span_tidy.csv"))

mod_b <- brms::brm(duration_z ~ log_freq_z + rate_z + length_z + (1 | word) + (1 | participant), data = merge_df)

mod_b %>% 
  write_rds(here("corpus_data", "models", "span_model_bayes.RDS"))

fixef(mod_b)




