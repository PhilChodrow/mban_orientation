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

tokenized_reviews <- reviews %>% unnest_tokens(word, comments)

# sentiments assigned to numerical scores
sentiments <- get_sentiments('afinn')

tokenized_reviews <- tokenized_reviews %>% 
	left_join(sentiments)

review_sentiment_values <- tokenized_reviews %>% 
	group_by(listing_id) %>% 
	summarise(m = mean(value, na.rm = T))

review_sentiment_values %>% 
	ggplot() + 
	aes(x = m) + 
	geom_density() + 
	geom_rug()

listings <- listings %>% 
	left_join(review_sentiment_values, by = c('id' = 'listing_id'))

listings_analysis <- listings %>% 
	filter(!is.na(m), !is.na(review_scores_rating), number_of_reviews > 50) 

listings_analysis %>% 
	ggplot() + 
	aes(x = m, y = review_scores_rating) + 
	geom_point(alpha = .1) + 
	geom_smooth(span = .05, method = 'loess')

listings_analysis %>% 
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

listings_analysis <- listings_analysis %>% 
	left_join(tokenized_descriptions, by = c('id' = 'id'))

listings_analysis %>% 
	lm(m~price + review_scores_rating + val, data = .) %>% 
	summary()
	



	


