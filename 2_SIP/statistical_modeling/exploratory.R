library(tidyverse)
library(stringr)
library(tidytext)
library(textdata)
library(modelr)

listings <- read_csv('../data/listings.csv') 
calendar <- read_csv('../data/calendar.csv') 
reviews <- read_csv('../data/reviews.csv') 

# clean up the price columns
listings <- listings %>% 
	mutate_at(vars(matches('price')), parse_number)

calendar <- calendar %>% 
	mutate_at(vars(matches('price')), parse_number)

# Some Sentiment Analysis

sentiments <- get_sentiments('afinn')

review_sentiment_values <- reviews %>% 
	unnest_tokens(word, comments) %>% 
	left_join(sentiments) %>% 
	group_by(listing_id) %>% 
	summarise(m = mean(value, na.rm = T))

review_sentiment_values %>% 
	ggplot() + 
	aes(x = m) + 
	geom_density() + 
	geom_rug()

listings_to_analyze <- listings %>% 
	left_join(review_sentiment_values, by = c('id' = 'listing_id')) %>% 
	filter(!is.na(m), !is.na(review_scores_rating), number_of_reviews > 50) 

listings_to_analyze %>% 
	ggplot() + 
	aes(x = m, y = review_scores_rating) + 
	geom_point(alpha = .1) + 
	geom_smooth(span = .05, method = 'loess')

listings_to_analyze %>% 
	lm(m~price + review_scores_rating, data = .) %>% 
	summary()

# CANDIDATE EXERCISE: Compute sentiment behind the host descriptions of their spaces. Add the result as a feature to the regression. Does the host description appear to have any relationship to the sentiment of the review? 

# Solution

tokenized_descriptions <- listings %>% 
	select(id,description) %>% 
	unnest_tokens(word, description) %>% 
	left_join(sentiments) %>% 
	group_by(id) %>% 
	summarize(val = mean(value, na.rm = T))

listings_analysis <- listings_to_analyze %>% 
	left_join(tokenized_descriptions, by = c('id' = 'id'))

listings_analysis %>% 
	lm(m~price + review_scores_rating + val, data = .) %>% 
	summary()
	
to_kmeans <- calendar %>% 
	select(listing_id, date, price) %>% 
	group_by(listing_id) %>% 
	filter(n() == 365) %>% 
	arrange(listing_id, date) %>% 
	mutate(cprice = cumsum(price), 
				 cprice = cprice / max(cprice)) %>% 
	ungroup()
	

to_kmeans <- to_kmeans %>% 
	select(-price) %>% 
	spread(key = date, value = cprice, fill = 1)

ids <- to_kmeans$listing_id
to_kmeans <- to_kmeans %>% 
	select(-listing_id) 

clust <- kmeans(na.omit(to_kmeans), centers = 5)

to_kmeans %>% 
	mutate(clust = clust$cluster,
				 id = ids) %>% 
	gather(key = date, value = cprice, -clust, -id) %>% 
	mutate(date = lubridate::ymd(date)) %>% 
	group_by(id) %>% 
	arrange(date) %>% 
	mutate(price = lead(cprice) - cprice) %>% 
	ggplot() + 
	aes(group = id, color = clust, x = date, y = price) + 
	geom_line() + 
	facet_wrap(~clust) + 
	ylim(c(0,NA))



to_kmeans <- listings %>% 
	select_at(vars(contains('review_scores'))) %>% 
	select(-review_scores_rating) %>% 
	na.omit()

set.seed(7)
clust <- kmeans(to_kmeans, centers = 7)

clust$centers %>% 
	as_tibble() %>% 
	gather(key = metric, value = rating) %>% 
	mutate(metric = stringr::str_replace(metric, 'review_scores_', '')) %>% 
	group_by(metric) %>% 
	mutate(r = row_number()) %>% 
	ungroup() %>% 
	ggplot() + 
	aes(x = metric, y = r) + 
	geom_tile(aes(fill = rating)) + 
	# theme_void() + 
	viridis::scale_fill_viridis()
