# from @kc_analytics
# https://twitter.com/kc_analytics/status/1345434428059881480
library(tidyverse)
library(data.table)
library(tictoc) # to check speed

# 
setwd("data_csv")
# EIKIFJB so is there a better way?!


# to specify CSV files:
df_files <- 
  list.files(pattern = "*.csv") %>%
  map_df(~fread(.))  # note tilde in front of `fread`

# if all the files in the folder are CSV:
tic()
df_files <-
  list.files() %>%
  map_df(fread)
toc()

# slightly faster:
tic()
df_files <-
  rbindlist(lapply(list.files(), fread))
toc()

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


#### ----

# VARIATIONS ON A THEME

# variant with Excel files
tictoc::tic()
data_dir <- here::here("read_bind_multiple_files", "data_excel")
files <-
  list.files(pattern = "*.xls*") %>% 
  map_dfr(read_excel, .id = "source")
tictoc::toc()


# another CSV variation with `here`, creating a nested tibble
# https://twitter.com/TDTran333/status/1345567646184599552?s=20
data_dir <- here::here("data_csv")
files <- list.files(path = data_dir, pattern = "\\.csv$")

df_datafiles <- tibble(filename = files) %>% 
  mutate(file_contents = map(filename, ~read_csv(file.path(data_dir, .))))

# examine your handywork
df_datafiles
unnest(df_datafiles) # now throws warning
unnest(df_datafiles, cols = c(file_contents))
