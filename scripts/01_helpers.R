# 01 helpers


# function to add a single word given xmin and xmax of textgrid dfs 
add_word = function(x_min, x_max, df)
{
  # subset
  df <- df %>% filter(x_min <= xmin & x_max >= xmax)
  # mutate
  df$word <- df$text[1]
  # bind
  return(df)  
}  


# using 'add_word' function, apply it to all words in df 

add_words <- function(df)
{
new_df <- character()
# subset words 
word_df <-  df %>% 
  filter(tier_name == "ORT-MAU")
# setup loop 
for(thisRun in 1:nrow(word_df))
{
  df_n <- add_word(word_df$xmin[thisRun], word_df$xmax[thisRun], df)
  new_df <- rbind(new_df, df_n)  
}
return(new_df)
}
