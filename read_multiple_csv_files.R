# from @kc_analytics
# https://twitter.com/kc_analytics/status/1345434428059881480
library(tidyverse)
library(data.table)

# 
setwd("read_bind_multiple_files")
# EIKIFJB so is there a better way?!


# to specify CSV files:
df_files <- 
  list.files(pattern = "*.csv") %>%
  map_df(~fread(.))  # note tilde in front of `fread`

# if all the files in the folder are CSV:
df_files <-
  list.files() %>%
  map_df(fread)

# slightly faster:
df_files <-
  rbindlist(lapply(list.files(), fread))


#### ----

# add unique variable value to the resulting file:
# The `.id` argument for `map_df()` function can do this.
# You can add `.id = "source"` and the resulting data.frame will have a 
# variable called "source" with either the list element's name, 
# or its numeric position in the list

df_files <- lapply(list.files(pattern = "*.csv"), function(x) {
  out <- fread(x)
  out$source_file <- x
  return(out)
})

# another solution
df_files <-
  list.files(pattern = "*.csv") %>% 
  map_dfr(read_csv, .id = "source")

tictoc::tic()
tictoc::toc()

# yes indeedly doodly!
data_dir <- here::here("read_bind_multiple_files", "data_csv")

# variant with Excel files
tictoc::tic()
data_dir <- here::here("read_bind_multiple_files", "data_excel")
files <-
  list.files(pattern = "*.xls*") %>% 
  map_dfr(read_excel, .id = "source")
tictoc::toc()

