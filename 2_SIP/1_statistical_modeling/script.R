library(tidyverse)
library(tidytext)
library(modelr)
library(randomForest)
library(yardstick)
library(cld3)
library(kernlab)
library(ggmap)


# Today we're going to continue working with the AirBnB data set that we introduced back in August. It comes in three pieces, and this time we'll work with all three: 

listings <- read_csv('../data/listings.csv')
calendar <- read_csv('../data/calendar.csv')
reviews  <- read_csv('../data/reviews.csv')

#' Our main problem for today is broadly related to recommender systems. Can we predict whether a user will like a listing? A solution to this problem would allow AirBnB to proactively surface relevant recommendations to users, hopefully prompting them to book more stays and therefore increase revenue. 

#' There are a few things we need to do in order to execute this analysis. 
#' 1. Determine how to measure whether a user likes a listing. 
#' 2. Select or engineer the features we think might be predictive. 
#' 3. Implement one or more models and evaluate their performance on training data. 
#' 4. Evaluate model performance on test data. 
#' Our predictable theme is that "tidy" tools like we used back in August will help us navigate this process in an easy, reproducible way. 

#' ------------------------------------------------------------
#' CLEANING
#' ------------------------------------------------------------
#' First we're going to do some very basic data cleaning. If you check the "price" columns in the listings and calendar data sets, you'll find that they are character vectors like "$100.00". We'd like to change them to numeric vectors. How can we do this? Here's an elementary way: 

listings %>% 
	mutate(price = parse_number(price)) %>% 
	select(price)

#' That's ok, but it will get repetitive: there are multiple price columns: 
listings %>% 
	colnames() %>% 
	keep(grepl('price',.))

#' Here's a better way, using super-charged variant of our friend, mutate(): 

listings %>% 
	mutate_at(vars(contains('price')), 
						parse_number)

#' Now all columns whose names contain the word "price" are numeric. We'd like to do the same thing to the calendar data, but we don't want to write the same code twice. What to do?

clean_prices <- function(df){
	df %>% 
		mutate_at(vars(contains('price')), parse_number)
}

listings <- listings %>% 
	clean_prices()

calendar <- calendar %>%
	clean_prices()


#' ------------------------------------------------------------
#' FEATURE ENGINEERING AND EXPLORATORY DATA ANALYSIS
#' ------------------------------------------------------------

# We want to recommend listings to users that we think they'll like. So, we would like to design an algorithm that will predict whether a user will like a listing, based on features we can extract from our data. 

# First problem: we actually don't have a feature that says how much a user liked a listing. What we do have is the review text. 

reviews %>% glimpse()

# We can turn the review text into a measure of satisfaction using some basic tools from *sentiment analysis.* What we are going to do is look for words that have positive or negative semantic valences associated with them. These valences can be quantified and validated through experiments. The first thing we need to do is get a list of words and their valences, called a "lexicon." The package tidytext provides the get_sentiments() and unnest_tokens() commands we'll use below. 

sentiment <- get_sentiments('afinn')

# There are a few other lexicons we could grab as well, but this one is easiest because it assigns numerical scores to words. We'll play with another one later in the session. 

sentiment

# WARMUP EXERCISE: working with your partner, construct a table giving the number of words with each value. Then, construct a table of the most positive and most negative words. 

sentiment %>%
	group_by(value) %>% 
	summarise(n = n())

sentiment %>% filter(value == 5) # warning: changing 5 to -5 will surface some extremely graphic and offensive language. 

# So, we need to somehow find instances of these words in the reviews. The first step is to reshape the review table by *tokenizing*. Tokenizing creates a single row for each word in each review. This operation may take a few seconds. 

reviews_tokenized <- reviews %>% 
	unnest_tokens(word, comments)

reviews_tokenized

#' Next, we'd like to lookup the sentiment value of each word in the review from the sentiment data frame. Who remembers how?....

words_with_sentiments <- reviews_tokenized %>% 
	left_join(sentiment)

#' Next, let's compute a mean sentiment for each review: 

review_sentiments <- words_with_sentiments %>% 
	group_by(id) %>% 
	summarise(sentiment = mean(value, na.rm = TRUE)) 

#' Finally, we will add the sentiment column back to the reviews table: 

reviews_with_sentiments <- reviews %>% 
	left_join(review_sentiments)

#' EXERCISE: Working with your partner, make a table containing the top 20 most positive reviews. Inspect the text of the comments. Do the results make sense to you? 

reviews_with_sentiments %>% 
	arrange(desc(sentiment)) %>% 
	head(20) %>% 
	select(comments)

#' Now we are going to write a function that takes a data frame as an argument and adds the sentiment feature. This will let us compare sentiments between data sets. 

add_sentiment_feature <- function(df, id_col, text_col){
	
	sentiment_df <- get_sentiments('afinn')
	
	sentiments <- df %>% 
		unnest_tokens_('word', text_col) %>% 
		left_join(sentiment_df) %>% 
		group_by_(id_col) %>% 
		summarise(sentiment = mean(value, na.rm = TRUE))
	
	df %>% 
		left_join(sentiments, by = c(id_col)) 
}

listings <- add_sentiment_feature(listings, id_col = 'id', text_col = 'description') %>% 
	rename(description_sentiment = sentiment)

reviews <- add_sentiment_feature(reviews, id_col = 'id', text_col = 'comments') %>% 
	rename(reviewer_sentiment = sentiment) 

reviews <- reviews %>% 
	drop_na(reviewer_sentiment)

#' So, now we have the feature we'd like to predict: a measure of how much the user liked their stay. The next thing we want to do is add information about the listing that we can use to make predictions. So, let's add the information from the listings table to the reviews: 

reviews_with_features <- reviews %>% 
	left_join(listings, by = c('listing_id' = 'id')) 

reviews_with_features <- reviews_with_features %>% 
	drop_na(contains('scores'))

#' Next, we have a bit of a problem with the review texts. 
#' 
#' EXERCISE: Find the 20 reviews with the lowest value of "reviewer_sentiment." What's the problem?


reviews_with_features <- reviews_with_features %>%
	mutate(language = detect_language(comments))

reviews_with_features <- reviews_with_features %>% 
	filter(language == 'en')


#' reviews_with_features is now our primary predictive data set. 
#' Now let's see if we can spot a relationship between the description_sentiment and reviewer_sentiment columns: 

reviews_with_features %>% 
	filter(number_of_reviews > 10,
				 description_sentiment >= 1) %>% 
	ggplot() + 
	aes(x = description_sentiment, y = reviewer_sentiment) + 
	geom_point(alpha = .1) + 
	geom_smooth()

#' OPEN_ENDED EXERCISE: Working with your partner, look through the columns in reviews_with_features. Using ggplot, make a plot showing the relationship between the sentiment feature and at least one other feature. Depending on the features you try, good geoms might be geom_point(), geom_boxplot(), or geom_violin(). Feel free to do any data manipulation you might need along the way. 

#' Sample Solution 1

reviews_with_features %>% 
	# filter(number_of_reviews > 10) %>% 
	ggplot() + 
	aes(x = host_listings_count, y = reviewer_sentiment) + 
	geom_boxplot(aes(group = host_listings_count)) + 
	geom_smooth() + 
	scale_x_continuous(trans = 'log10')

#' Sample Solution 2

p <- reviews_with_features %>% 
	filter(number_of_reviews > 10) %>% 
	ggplot() + 
	aes(x = review_scores_rating, y = reviewer_sentiment) + 
	geom_boxplot(aes(group = review_scores_rating)) 

p

#' Sample Solution 3

reviews_with_features %>% 
	mutate(month = lubridate::month(date, label = TRUE, abbr = TRUE)) %>% 
	ggplot() + 
	aes(x = month, y = reviewer_sentiment) + 
	geom_boxplot()
			
#' Based on this last observation, let's add a month column to the data
reviews_with_features <- reviews_with_features %>% 
	mutate(month = lubridate::month(date, label = TRUE, abbr = TRUE))

#' ------------------------------------------------------------
#' MODELING
#' ------------------------------------------------------------
#' So, this is the part that people usually call "machine learning." Let's begin with linear regression. If all you want is a plot, ggplot makes this easy: 

p + geom_smooth(method = 'lm')
	 
#' Normally, we want to extract statistics and get better control, so this isn't really going to work for us. We need to do something systematic. Before we do, we should *split* our data into training, validation, and test sets. 
#' 
#' 1. The training set is what we will use to optimize our model. 
#' 2. The validation set will give us an estimate of performance on the test set. 
#' 3. Finally, the test set will serve as the overall measure of quality for the model. 

partition <- resample_partition(reviews_with_features, c(train = .6, validation = .2, test = .2))

partition$train 
partition$train %>% as_data_frame()

#' Now let's train a simple linear regression model. 

lm_model <- lm(reviewer_sentiment~review_scores_rating, data = partition$train)

#' The summary() function provides a useful way to learn more about the model behavior: 

lm_model %>% summary()

#' However, we don't want to evaluate the model on the training set -- we want to evaluate on the test set. Fortunately, there are some nice functions in the modelr package for precisely this kind of task. 

modeled <- partition$validation %>% 
	as_data_frame() %>% 
	add_predictions(lm_model)

model_rmse <- modeled %>% 
	summarise(rmse = sqrt(mean((reviewer_sentiment - pred )^2)))

model_rmse

#' Let's try to generalize this workflow a little bit. Note that R wants the specification of the dependent and independent variables in the "formula" syntax. For example: 

formula <- as.formula(reviewer_sentiment~review_scores_rating)
formula

#' Now let's write a function together that will take in a formula and spit out the validation performance of linear regression with that formula: 

lm_rmse <- function(formula){
	model <- lm(formula, data = partition$train)
	rmse <- partition$validation %>% 
		as_data_frame() %>% 
		add_predictions(model) %>% 
		mutate(.resid = reviewer_sentiment - pred) %>% 
		summarise(rmse = sqrt(mean(.resid^2))) %>% 
		unlist() # change from data frame to number
	return(list(model = model, rmse = rmse))
}

model_output <- lm_rmse(formula)
model_output$rmse
model_output$model %>% summary()


formula_2 <- as.formula(reviewer_sentiment~review_scores_rating+month)
lm_rmse(formula_2)$rmse

formula_3 <- as.formula(paste0(
	"reviewer_sentiment~",
	paste0(colnames(reviews_with_features) %>% 
				 	keep(grepl('scores', .)) ,
				 collapse='+')
))
lm_rmse(formula_3)$rmse

#' It's worthwhile to investigate the coefficients in here: 

formula_3 %>% 
	lm(data = partition$train) %>% 
	summary()

#' EXERCISE: Working with your partner, try adding (or removing!) some variables using the formula syntax. Can you beat the validation performance of formula_3? 

#' SOLUTION: 

formula_4 <- as.formula(reviewer_sentiment~month+review_scores_rating+review_scores_location+review_scores_value)

lm_rmse(formula_4)$rmse

#' So, linear models are great and all, but they can't capture nonlinear relationships. Fortunately, if we're being tidy about our code, it's easy to incorporate alternative regression functions into our pipeline. 

#' Let's start by training a random forest model

rf <- randomForest(formula, data = partition$train, ntree = 50)

partition$validation %>% 
	as_data_frame() %>% 
	add_predictions(rf) 

modelr::rmse(rf, partition$validation)

#' Now let's generalize the lm_rmse function we wrote to take a general regressor: 

regressor_rmse <- function(formula, model_class, ...){
	model <- model_class(formula, data = partition$train, ...)
	rmse <- partition$validation %>% 
		as_data_frame() %>% 
		add_predictions(model) %>% 
		mutate(.resid = reviewer_sentiment - pred) %>% 
		summarise(rmse = sqrt(mean(.resid^2))) %>% 
		unlist() # change from data frame to number
	return(list(model = model, rmse = rmse))
}

regressor_rmse(formula, lm)$rmse
regressor_rmse(formula, randomForest, ntree = 5)$rmse

regressor_rmse(formula_4, lm)$rmse
regressor_rmse(formula_4, randomForest, ntree = 50)$rmse # this call might take a little while

#' In this section, we built a series of regression models and tested their performance on data. Along the way, we learned how to specify models using R's formula syntax; how to extract model predictions; and how to write functions to efficiently evaluate model performance. Essentially these same principles will go into classification, which we study next. 


#' ----------------------------------------------------
#' CLASSIFICATION
#' ----------------------------------------------------

#' In  this section, we are going to focus on basic classification. We'll focus on binary classification using logistic regression. In particular, we'll try to predict whether a stay went disastrously poorly using some of the predictors we've seen so far. First, let's look at the distribution of sentiment scores. 

reviews_with_features %>% 
	ggplot() + 
	aes(x = reviewer_sentiment) + 
	geom_histogram()

#' Ok, let's make a column for "disasters." We'll say that a stay is a disaster if the sentiment is 1 or less. 

reviews_with_features <- reviews_with_features %>% 
	mutate(is_disaster = reviewer_sentiment < 1)

#' EXERCISE: Write a one-liner to determine what percentage of stays were "disasters" according to our metrics. 

reviews_with_features %>% summarise(mean(is_disaster))

#' We have added a new feature, so we need to re-partition the data. 

partition <- resample_partition(reviews_with_features, c(train = .6, validation = .2, test = .2))

#' Now we're ready for logistic regression. Logistic regression uses the "glm" function with "family = binomial" specified.  

model <- glm(is_disaster~description_sentiment, data = partition$train, family = 'binomial')

#' As before, we can extract predictions from the model using the add_predictions function: 

modeled <- partition$validation %>% 
	as_data_frame() %>% 
	add_predictions(model, var = 'probs', type = 'response') 

#' EXERCISE: Create two boxplots showing the distribution of the variable probs depending on whether the stay was a disaster or not. 

modeled %>% 
	ggplot() + 
	aes(x = is_disaster, y = probs, group = is_disaster) + 
	geom_boxplot()

#' A standard way to summarise the quality of a parameterized prediction algorithm is with the "Area Under the Curve." 

#' Before we start messing with the model, let's write a function to assess model quality. A standard one is AUC, or "Area Under the Curve." What curve? This one! 
#' Note: these functions come from the "yardstick" package. 

modeled %>% 
	roc_curve(factor(is_disaster), probs) %>% 
	autoplot()

#' We can extract the AUC with another convenient function:

modeled %>% 
	roc_auc(factor(is_disaster), probs)

#' Like before, we'll write a function that allows us to easily compare models:

classifier_AUC <- function(formula, model_class, ...){
	model <- model_class(formula, data = partition$train,...)
	AUC <- partition$validation %>% 
		as_data_frame() %>% 
		add_predictions(model, var = 'probs') %>% 
		yardstick::roc_auc(truth = factor(is_disaster), probs) 
	return(list(model = model, AUC = AUC))
}

formula_1 <- as.formula(is_disaster~description_sentiment+host_is_superhost)

classifier_AUC(formula_1, glm, family = 'binomial')$AUC

formula_2 <- as.formula(is_disaster~review_scores_rating+description_sentiment+host_is_superhost)

classifier_AUC(formula_3, glm, family='binomial')

#' Let's see if we can figure out from the data what features of a home might contribute to a disastrous stay. This formula extracts all the review scores except the overall rating. 

formula_3 <- as.formula(paste0(
	"is_disaster~",
	paste0(colnames(reviews_with_features) %>% 
				 	keep(grepl('scores', .)) %>% 
				 	discard(grepl('rating',.)),
				 collapse='+')
))

classifier_AUC(formula_3, glm, family = 'binomial')$model %>%
	summary()

#' Confusion matrix
validation_with_preds <- partition$validation %>% 
	as_data_frame() %>% 
	mutate(pred = predict(model, 
												newdata=., 
												type = 'response'))

#' EXERCISE: Experiment with adding, subtracting, and changing features. Can you improve the model? 

#' ----------------------------------------------------
#' UNSUPERVISED LEARNING: CLUSTERING
#' ----------------------------------------------------
#' When performing unsupervised learning like clustering, we don't usually have an objective function that can be used to measure the quality of our model. Often, this requires us to be creative in how we measure the success of a supervised learning model. 
#' We're going to try a fun little task: suppose we don't know anything about the neighborhoods of Boston. Can we "learn" neighborhoods from the AirBnB listings data? That is, can we partition the data in such a way that closely aligns with the listed neighborhoods (without using this column of course!)? 

#' Let's give it a try. For computational and plotting reasons later, we'll stick to the first 1000 listings. 

listings_sub <- listings %>% 
	head(1000)

#' Now let's extract the longitude and latitude and make a matrix out of them. 

geo <- listings_sub %>% 
	select(longitude, latitude) %>% 
	as.matrix()

#' Let's add two kinds of clusters to the data. 
#' - *K-means* clustering may be familiar to you. When we do k-means, we iteratively move a set of "centers" around in space until they are "aligned" with the data according to a least-squares criterion. 
#' - *Spectral clustering* is a popular form of clustering in the machine learning community. The "secret sauce" is running the data through a big pile of linear algebra first, and then doing k-means in "the projected eigenspace of the normalized graph Laplacian." Don't worry about it. 

k <- 20

clustered <- listings_sub %>% 
	mutate(kmeans = kmeans(geo, k)$cluster,
				 spectral = c(specc(geo, k)))

#' First, let's plot each of these on a map. 

to_plot <- clustered %>% 
	select(longitude, latitude, kmeans, spectral, neighbourhood) %>% 
	gather(key = method, value = cluster, -longitude, -latitude, -neighbourhood) 

#' Next, let's get a basemap of Boston from online. This is the same code we used back in August, although I've expanded the bounding box slightly. 

boston_coords <- c(left   = -71.1589, 
									 bottom = 42.2601, 
									 right  = -71.0189, 
									 top    = 42.3901)

basemap <- get_map(location = boston_coords,
									 maptype = 'terrain')

#' EXERCISE: Create a facetted pair of maps, with each pane of the facet corresponding to a clustering method, and color representing the cluster identity. You might find it useful to use color = factor(cluster) in your aesthetic -- the factor() will help ggplot interpret it as categorical, resulting in better colors. You'll probably want to use facet_wrap(~method) somewhere in your pipeline. You might also want to try appearance modifiers like guides(color = FALSE) or theme_void(). 

ggmap(basemap) + 
	geom_point(aes(x = longitude, 
								 y = latitude, 
								 color = factor(cluster)), 
						 data = to_plot) + 
	theme_void() + 
	guides(color = FALSE) + 
	facet_wrap(~method)

#' We can also visualize how each clustering algorithm "chopped up" the neighborhoods. For this we'll use geom_tile(), which we haven't done much before.  

to_plot %>% 
	group_by(cluster, neighbourhood, method) %>% 
	summarise(n = n()) %>% 
	ggplot() + 
	aes(x = cluster, y = neighbourhood, fill = n) + 
	geom_tile() + 
	facet_wrap(~method) + 
	theme_minimal()

#' Which neighborhoods are cleanly "resolved" by each method? 
#' 
#' EXERCISE: Discuss with your partner how you might be able to quantify how successfully each algorithm performed in identifying the neighborhoods of Boston. Are you able to implement your recommendation?








