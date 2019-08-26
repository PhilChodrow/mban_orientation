suppressWarnings(library(tidyverse))

clean_prices <- function(df){
	clean_price <- function(x) gsub('\\$|,', '',x) %>% as.numeric()
	cols <- colnames(df) %>% keep(~grepl('price', .x))
	df %>% mutate_at(cols, clean_price)
}