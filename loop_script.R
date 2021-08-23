library(dplyr)
library(tidyverse)
library(h2o)
library(sjmisc)
library(here)
#### description 

# load in utterance data 

female <- read.table("corpus_data/line_index_female.tsv",
                     sep="\t", header=FALSE)

freq <- read.csv("lexicalfrequencydata/subtlex.csv")

freq1 <- freq %>% 
  dplyr::select(Word, `Freq..count`, `Freq..per.million`, `Log.freq.`)

freq2 <- freq %>% 
  dplyr::select(Word.1, `Freq..count.1`, `Freq..per.million.1`, `Log.freq..1`)

freq3 <- freq %>% 
  dplyr::select(Word.2, `Freq..count.2`, `Freq..per.million.2`, `Log.freq..2`)

names(freq1)[1] <- "word"
names(freq2)[1] <- "word"
names(freq3)[1] <- "word"

names(freq1)[2] <- "count"
names(freq2)[2] <- "count"
names(freq3)[2] <- "count"

names(freq1)[3] <- "count_per_mil"
names(freq2)[3] <- "count_per_mil"
names(freq3)[3] <- "count_per_mil"

names(freq1)[4] <- "log_freq"
names(freq2)[4] <- "log_freq"
names(freq3)[4] <- "log_freq"

freq_df <- rbind(freq1, freq2, freq3)


# pivot data so that each word is in its own cell

female %>% 
  pivot_longer(c(`V1`, `V2`), names_to = "word", values_to = "participant")

df <- character()

for(thisRun in 1:nrow(female)) {                                           # Head of for-loop
  x1 <- strsplit(female$V2[thisRun], " ") %>% 
    as.data.frame(col.names = "word") %>% 
    mutate("participant" = female$V1[thisRun])
  # Code block
  print(x1)
  df <- rbind(df, x1) %>% 
    as.data.frame()
}


# remove commas 

df$word <- gsub('[[:punct:] ]+',' ',df$word)
df$word <- tolower(df$word)
df$word <- trimws(df$word)
df$word2 <- str_detect(df$word, "ado")
df$word3 <- str_detect(df$word, "ado.") 

# get number of unique words 

n_words <- unique(df$word) %>% 
  as.data.frame() %>% 
  nrow()

occurences_df <- df %>% 
  filter(word2 == "TRUE" & word3 == "FALSE") %>%
  group_by(word) %>%
  summarise(n = n()) 


words_df <- left_join(occurences_df, freq_df, by = "word")
words_df$log_freq

# plot to see the 
words_df %>% 
  ggplot(aes(x = n, y = log_freq)) + geom_point()

hist(words_df$log_freq)
hist(words_df$n)

# produce participants who produce participles 

tokens <- df %>% 
  filter(word %in% word_vector)



# loop to create txt files based on annotation data 

for(thisRun in 1:nrow(female))
{
filename <- female$V1[thisRun]  
direc <- "txt_files/"
path <- paste0(direc,filename)
fileConn<-file(paste0(path))
writeLines(female$V2[thisRun], fileConn)
close(fileConn)
}

