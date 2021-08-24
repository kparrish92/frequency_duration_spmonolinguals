
# Source libs -----------------------------------------------------------------

source(here::here("scripts", "00_libs.R"))
source(here::here("scripts", "01_helpers.R"))

# -----------------------------------------------------------------------------
# attempt to add word vector so that it is known which word each segment comes from

## read in data 
test <- read_textgrid("corpus_data/es_ar_female/arf_00295_00000740990.TextGrid")

t2 <- add_words(test)

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

df_f <- df_f %>% 
  group_by(file) %>% 
  mutate(rate = max(annotation_num)/tier_xmax)

df_f %>% 
  write.csv(here("corpus_data", "tidy", "female_tidy.csv"))

# create rough estimate of speech rate of segments/second 



