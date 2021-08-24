
# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libs.R"))

# -----------------------------------------------------------------------------
# corpus data obtained from: https://www.openslr.org/resources.php

# load tidy textgrid data 
f_data <- read.csv(here("corpus_data", "tidy", "female_tidy.csv"))

# clean up words and detect "ado" participles
f_data$word <- gsub('[[:punct:] ]+',' ',f_data$word)
f_data$word <- tolower(f_data$word)
f_data$word <- trimws(f_data$word)
f_data$word2 <- str_detect(f_data$word, "ado")
f_data$word3 <- str_detect(f_data$word, "ado.")

# load frequency data 
corpus <- read.csv(here("lexicalfrequencydata", "subtlex_tidy.csv"))

# join frequency data with textgrid data 
words_df <- left_join(f_data, corpus, by = "word") %>% 
  mutate("duration" = xmax - xmin)

# subset "ado" participles 
ado_df <- words_df %>% 
  filter(word2 == "TRUE" & word3 == "FALSE") %>% 
  filter(text == "a") %>% 
  group_by(word, file) %>% 
  filter(xmin == max(xmin))

# model 

mod1 <- glm(duration ~ log_freq, data = ado_df)
mod2 <- glm(duration ~ log_freq*rate, data = ado_df)

summary(mod1)
summary(mod2)
# plot 
ado_df %>% 
  ggplot(aes(x = log_freq, y = duration)) + geom_point() + geom_smooth()




mod <- glm(duration ~ log_freq, data = words_df)
modb <- glm(duration ~ log_freq*rate, data = words_df)
summary(mod)
summary(modb)



words_df %>% 
  ggplot(aes(x = log_freq, y = duration, color = rate)) + geom_point() + geom_smooth()


words_df %>% 
  ggplot(aes(x = rate, y = duration)) + geom_point() + geom_smooth() + ylim(0,1)