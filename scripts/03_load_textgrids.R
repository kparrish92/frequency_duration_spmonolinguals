
# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libraries.R"))
source(here::here("scripts", "01_helpers.R"))

# -----------------------------------------------------------------------------
# attempt to add word vector so that it is known which word each segment comes from

## read in data 

list_of_files <- list.files(path = "corpus_data/es_ar_female", recursive = TRUE,
                            pattern = "\\.TextGrid$", 
                            full.names = TRUE) %>% 
  as.data.frame()

df_f <- character()
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
  write.csv(here("corpus_data", "tidy", "female_tidy.csv"))




# male data 

list_of_files <- list.files(path = "corpus_data/es_ar_male", recursive = TRUE,
                            pattern = "\\.TextGrid$", 
                            full.names = TRUE) %>% 
  as.data.frame()

df_f <- character()
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
  write.csv(here("corpus_data", "tidy", "male_tidy.csv"))

