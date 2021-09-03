
# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libs.R"))
source(here::here("scripts", "01_helpers.R"))

# -----------------------------------------------------------------------------


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

freq_df <- rbind(freq1, freq2, freq3) %>% 
  write.csv(here("lexicalfrequencydata", "subtlex_tidy.csv"))


# pivot data so that each word is in its own cell


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


# loop to create txt files based on annotation data 

for(thisRun in 1:nrow(female))
{
filename <- female$V1[thisRun]  
direc <- "txt_files/"
end <- ".txt"
path <- paste0(direc,filename,end)
fileConn<-file(paste0(path))
writeLines(female$V2[thisRun], fileConn)
close(fileConn)
}

