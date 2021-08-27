#------------------------------------------------------------------------------
# title: 02_load_textgrids
# author: Kyle Parrish
# last eidt: 8/25/2021
# description: this script is to be used after autosegmentation is done in webmaus.
# The script loads all textgrids and uses helper functions to match each segment 
# to a word. It also adds relative speaking rate per utterance. Each utterance is 
# converted from textgrid to df, combined and the output is saved under "eng_corpus_data", 
# ""tidy" and is called "eng_tidy.csv"
#
# WebMaus link: (https://clarin.phonetik.uni-muenchen.de/BASWebServices/interface/WebMAUSBasic)
#------------------------------------------------------------------------------

# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libraries.R"))
source(here::here("scripts", "01_helpers.R"))

# -----------------------------------------------------------------------------

# read all files from specified path with the end "TextGrid" and create a list
# of those files 
list_of_files <- list.files(path = "eng_corpus_data/files", recursive = TRUE,
                            pattern = "\\.TextGrid$", 
                            full.names = TRUE) %>% 
  as.data.frame()

# create empty vector for loop
df_f <- character()

# run a loop reading from the list of files df and using a helper function to
# add words to each segment (so that we know which segment is from which word)
for(thisRun in 1:nrow(list_of_files))
{
  df <- read_textgrid(list_of_files$.[thisRun]) %>%
    add_words()
  df_f <- rbind(df_f, df)  
}

# create rough estimate of speech rate of segments/second 
df_f <- df_f %>% 
  group_by(file) %>% 
  mutate(rate = max(annotation_num)/tier_xmax)

# save output
df_f %>% 
  write.csv(here("eng_corpus_data", "tidy", "eng_tidy.csv"))
