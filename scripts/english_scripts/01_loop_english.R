#------------------------------------------------------------------------------
# title: 01_loop_english
# author: Kyle Parrish
# last eidt: 8/25/2021
# description: this script (1) reads a txt file provided by a corpus of all utterances 
# and participants, then (2) and uses a loop to give each word its own row and also
# (3) creates individual txt files for autosegmentation and saves them with the .wav files.
#------------------------------------------------------------------------------

# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libraries.R"))
source(here::here("scripts", "01_helpers.R"))

# -----------------------------------------------------------------------------

# read in data 
eng_data <- read.delim("eng_corpus_data/files/text.txt", header = FALSE, sep = "\t", dec = ".") %>% 
  mutate(V1 = str_remove(V1, ".wav"))

# create empty vector for loop
df <- character()

# loop to create dataframe with one word per row and save the output
for(thisRun in 1:nrow(eng_data)) {                                           
  x1 <- strsplit(eng_data$V2[thisRun], " ") %>% 
    as.data.frame(col.names = "word") %>% 
    mutate("participant" = eng_data$V1[thisRun])
  # Code block
  print(x1)
  df <- rbind(df, x1) %>% 
    as.data.frame()
}

# save output of loop
df %>% 
  write.csv(here("eng_corpus_data", "tidy", "eng_words.csv"))

# a second loop to write text files and save them with .wav files for auto-segmentation
for(thisRun in 1:nrow(eng_data))
{
  filename <- eng_data$V1[thisRun]  
  direc <- "eng_corpus_data/files/"
  end <- ".txt"
  path <- paste0(direc,filename,end)
  fileConn<-file(paste0(path))
  writeLines(eng_data$V2[thisRun], fileConn)
  close(fileConn)
}

