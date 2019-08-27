## Analysis packages
library(tidyverse)
library(lubridate) 
source("../2_data_science/code/clean_prices.R")

## Script parameters
# We start by setting values for the variables that we need to choose to determine the output of the script. These values go at the top of the script so that they are easy to find and change. If we want to turn this script into a function, these parameters would be our input arguments.

# These parameters indicate the criteria we will use to filter the listings
min_score <- 90
min_reviews <- 5
allowed_neighbourhoods <- c("Downtown","Back Bay","Chinatown")

# These parameters describe the dates and length of stay for which we want to check availibility.
nights <- 3
args = commandArgs(trailingOnly=TRUE)
dates = ymd(args[[1]])
print(dates)
# If you want to run this script in RStudio, set the dates manually
#dates <- ymd(c("2019-08-30","2019-09-27","2019-10-25", "2019-11-25"))


# These parameters the amenities that we will add as columns in our data
amenities <- c("Kitchen","Air conditioning")

## content


# load the data we'll use today and address the 'prices-as-strings' issue. 
listings <- read_csv('../data/listings.csv') %>%  clean_prices()
calendar <- read_csv('../data/calendar.csv') %>% clean_prices()

# first, filter the listings to remove any that don't meet our criteria

filtered_listings <- listings %>% 
  filter(neighbourhood %in% allowed_neighbourhoods,
  			 review_scores_rating >= min_score,
  			 number_of_reviews >= min_reviews ) 

# now, find out which listings are available on each of our potential check-in dates. 
# First step: construct a helper data frame that contains the dates of the stays we want.

date_df <- tibble(
	stay = rep(1:length(dates), nights), 
	date = dates + rep(1:nights, each = length(dates)) - 1) 

# calculate the prices for available listings. 
# The result is a data_frame with columns for each of the stays we want -- a listing is included if it is available for at least one of them. 
#calendar$available = calendar$available=='t'

availability <- calendar %>% 
	filter(available == TRUE, 
				 minimum_nights <= nights) %>% 
	inner_join(date_df, by = c('date' = 'date')) %>% 
	group_by(listing_id, stay) %>% 
	filter(sum(available) == nights) %>% 
	summarise(total_price = sum(price)) %>% 
	mutate(stay = paste('stay', stay)) %>% 
	spread(key = stay, value = total_price, fill = NA)
	
# add these prices to the listings data set
# using inner_join() ensures that only listings with availability for at least one of the desired stays are contained in the data set. 

filtered_listings <- filtered_listings %>% 
	inner_join(availability, by = c('id' = 'listing_id'))

# finally, search for the listed amenities and add extra columns to the listing data
# in general, for-loops are highly discouraged in R, but this method does appear to be by far the most concise way. 
for(a in amenities){
  filtered_listings[,gsub(" ","_",a)] = as.numeric(grepl(a,filtered_listings$amenities))
}


# write out the data
filtered_listings %>% 
	write_csv('filtered_listings.csv')

print("Success!")
