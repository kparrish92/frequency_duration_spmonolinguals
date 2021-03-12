# This folder contains stim lists for experiments


## This is the list of stimuli words

```{r}
# load libs
source(here::here("scripts", "00_libraries.R"))

# load stim
stim <- readxl::read_excel("stim.xlsx")

stim %>% 
  kable(., format = "pandoc")
```