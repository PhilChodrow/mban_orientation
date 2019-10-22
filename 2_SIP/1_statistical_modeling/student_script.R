library(tidyverse)     # core data manipulation
library(tidytext)      # text analysis
library(modelr)        # modeling helpers
library(randomForest)  # random forest regression
library(yardstick)     # classification evaluation functions. 
library(cld3)          # language identification
library(kernlab)       # spectral clustering
library(ggmap)         # geospatial viz

# Today we're going to continue working with the AirBnB data set that we introduced back in August. It comes in three pieces. Last time, we worked mainly with the listings data set. This time, we'll use listings and reviews. Next session, we'll focus on the calendar data. 

listings <- read_csv('../data/listings.csv')
calendar <- read_csv('../data/calendar.csv')
reviews  <- read_csv('../data/reviews.csv')

#' Our main problem for today is broadly related to recommender systems. Can we predict whether a user will like a listing? A solution to this problem would allow AirBnB to proactively surface relevant recommendations to users, hopefully prompting them to book more stays and therefore increase revenue. 

#' There are a few things we need to do in order to execute this analysis. 
#' 1. Determine how to measure whether a user likes a listing. 
#' 2. Select or engineer the features we think might be predictive. 
#' 3. Implement one or more models and evaluate their performance on training data. 
#' 4. Evaluate model performance on test data. 
#' Our predictable theme for the session is that "tidy" tools like we used back in August will help us navigate this process in a smooth, reproducible way. 

#' ------------------------------------------------------------
#' DATA CLEANING
#' ------------------------------------------------------------
#' First we're going to do some very basic data cleaning. If you check the "price" columns in the listings and calendar data sets, you'll find that they are character vectors like "$100.00". We'd like to change them to numeric vectors. How can we do this? Here's an elementary way: 



#' That's ok, but it will get repetitive: there are multiple price columns: 


#' Here's a better way, using super-charged variant of our friend, mutate(): 



#' Now all columns whose names contain the word "price" are numeric. We'd like to do the same thing to the calendar data, but we don't want to write the same code twice. What to do? Let's write a *function* that will do this piece of data cleaning for us. 



#' We'll write some more complicated functions later in the session. 



#' ------------------------------------------------------------
#' FEATURE ENGINEERING AND EXPLORATORY DATA ANALYSIS
#' ------------------------------------------------------------

#' We want to recommend listings to users that we think they'll like. So, we would like to design an algorithm that will predict whether a user will like a listing, based on features we can extract from our data. 

#' First problem: we actually don't have a feature that says how much a user liked a listing. What we do have is the review text, in the comments column. 


#' We can turn the review text into a measure of satisfaction using some basic tools from *sentiment analysis*. What we are going to do is look for words that have positive or negative semantic valences associated with them. These valences can be quantified and validated through experiments. The first thing we need to do is get a list of words and their valences, called a *lexicon.* The package tidytext provides the get_sentiments() and unnest_tokens() commands we'll use below. 


#' There are a few other lexicons we could grab as well, but this one is easiest because it assigns numerical scores to words. We'll play with another one later in the session. 


# WARMUP EXERCISE: working with your partner, construct a table giving the number of words with each value. Then, construct a table of the most positive and most negative words. 

# warning: searching out negative values will surface some extremely graphic and offensive language. 


# So, we need to somehow find instances of these words in the reviews. The first step is to reshape the review table by *tokenizing*. Tokenizing creates a single row for each word in each review. This operation may take a few seconds. 




#' Next, we'd like to lookup the sentiment value of each word in the review from the sentiment data frame. Who remembers how?....



#' Next, let's compute a mean sentiment for each review: 



#' Finally, we will add the sentiment column back to the reviews table: 



#' EXERCISE: Working with your partner, make a table containing the top 20 most positive reviews. Inspect the text of the comments. Do these results make sense? 



#' Now we are going to write a function that takes a data frame as an argument and adds the sentiment feature. This will let us compare sentiments between data sets. 








#' Because we wrote a nice function, we can easily add a corresponding feature to a different data set. 

#' MINI-EXERCISE: add a feature called "description_sentiment" to the listings data, based on the "description" column. You can use the rename() function to rename the column. 



#' Unfortunately, we have a bit of a problem in our data. To see it, let's look at some of the "worst" reviews: 



#' Oops. Fortunately, the good folks at Google have written a package for detecting languages in strings. 

detect_language("To boldly go where no one has gone before.")
detect_language("Petit a petit, l’oiseau fait son nid")
detect_language("Det finnes ingen dårlig vær, bare dårlige klær")

#' EXERCISE: filter down reviews_with_sentiments so that it contains only English language reviews (in the comments field). You should be able to do this with one mutate() and one filter() call. Note that this operation may take a little while.  Once you've done that, check whether the lowest-scoring reviews are now in English. 

#' So, now we have the feature we'd like to predict: a measure of how much the user liked their stay. The next thing we want to do is add information about the listing that we can use to make predictions. So, let's add the information from the listings table to the reviews: 



#' Later, we're going to work with the ratings given to the listings. Before going farther, let's drop rows that have NAs in any of the "scores" columns. There's a nice convenience function to do this: 



#' reviews_with_features is now our primary predictive data set. 
#' Now let's see if we can spot a relationship between the description_sentiment and reviewer_sentiment columns: 

#' EXERCISE: Plot reviewer_sentiment against description_sentiment. Using geom_smooth() to add a trendline. What do you see? HINT: you might find it helpful to filter out listings that don't have very many of reviews. This information is captured in the number_of_reviews column. 






#' OPEN_ENDED EXERCISE: Working with your partner, look through the columns in reviews_with_features. Using ggplot, make a plot showing the relationship between the reviewer_sentiment feature and at least one other feature. Depending on the features you try, good geoms might be geom_point(), geom_boxplot(), or geom_violin(). Feel free to do any data manipulation you might need along the way. 

#' Sample Solution 1: experienced hosts




#' Sample Solution 2: review_scores_rating



#' Sample Solution 3: superhost? 




#' Sample Solution 4: time of the year


#' Based on this last observation, let's add a month column to the data


#' ------------------------------------------------------------
#' MODELING
#' ------------------------------------------------------------
#' So, this is the part that people usually call "machine learning." Let's begin with linear regression. If all you want is a plot, ggplot makes this easy: 


#' Normally, we want to extract statistics and get better control, so this isn't really going to work for us. We need to do something systematic. Before we do, we should *split* our data into training, validation, and test sets. 

#' 1. The training set is what we will use to optimize our model. 
#' 2. The validation set will give us an estimate of performance on the test set. 
#' 3. Finally, the test set will serve as the overall measure of quality for the model. 



#' Now let's train a simple linear regression model. 


#' The summary() function provides a useful way to learn more about the model behavior: 


#' Especially important components of the summary include the coefficients in the "Estimate" column, the significance values "Pr(>|t|)", and the Adjusted R-squared, and the residual standard error (RMSE). 

#' However, we don't want to evaluate the model on the training set -- we want to evaluate on the validation (and eventually test) set. Fortunately, there are some nice functions in the modelr package for precisely this kind of task. Let's compute the validation RMSE (root mean square error). To do this, we first need to add the model predictions to the data frame. We can do this easily using add_predictions(). 


#' MINI-EXERCISE: using a single summarise() call, compute the RMSE. The RMSE is defined as the square root of the mean squared difference between the model prediction and the actual value. You can find further discussion of the RMSE, including an explicit formula, here: https://en.wikipedia.org/wiki/Root-mean-square_deviation 




#' How does this compare to the Root Mean Square Error shown by model %>% summary()? What do we conclude? 

#' Let's try to generalize this workflow a little bit. Note that R wants the specification of the dependent and independent variables in the "formula" syntax. For example: 


#' Now let's write a function together that will take in a formula and spit out the validation performance of linear regression with that formula: 




#' MINI-EXERCISE: try regressing reviewer_sentiment against review_scores_rating and month. What do you see? 



#' Now let's try regressing reviewer_sentiment against all the review_scores_* columns. 





#' Is this interpretable? Is the result what we would expect? What could we do to improve the interpretability of this finding?  

#' EXERCISE: Working with your partner, try adding (or removing!) some variables using the formula syntax. Can you beat the validation performance of formula_3? 

#' SOLUTION: 



#' So, linear models are great and all, but they can't capture nonlinear relationships. Fortunately, if we're being tidy about our code, it's easy to incorporate alternative regression functions into our pipeline. 

#' Let's start by training a random forest model. A random forest is a collection of slightly randomized decision trees. They often have excellent predictive performance, but can be expensive to train. 



#' Now let's generalize the lm_rmse function we wrote to take a general regressor. Fortunately, we can do this with only minor modifications to the original code. Feel free to copy/paste and go from there.  






#' Let's test our new function






#' In this section, we built a series of regression models and tested their performance on data. Along the way, we learned how to specify models using R's formula syntax; how to extract model predictions; and how to write functions to efficiently evaluate model performance. Essentially these same principles will go into classification, which we study next. 

#' OPEN-ENDED EXERCISE: Working with your partner, see if you can improve on any of these models. Add features to the formulae, using either random forest or linear regression. Measure your performance on the validation set. Once you have settled on a model, measure performance on the test set. How did you do? 


#' ----------------------------------------------------
#' CLASSIFICATION
#' ----------------------------------------------------

#' In  this section, we are going to focus on basic classification using logistic regression. In particular, we'll try to predict whether a stay went disastrously poorly using some of the predictors we've seen so far. First, let's look at the distribution of sentiment scores. 



#' Ok, let's make a column for "disasters." We'll say that a stay is a disaster if the sentiment is 1 or less. 



#' EXERCISE: Write a one-liner to determine what percentage of stays were "disasters" according to our metrics. 



#' We have added a new feature, so we need to re-partition the data. 



#' Now we're ready for logistic regression. Logistic regression uses the "glm" function with "family = binomial" specified.  



#' As before, we can extract predictions from the model using the add_predictions function. We need to give an extra parameter to specify that the response we want is the modeled probability of being a disaster. 





#' EXERCISE: Create two boxplots showing the distribution of the variable probs depending on whether the stay was a disaster or not. Does it look like we are capturing any signal? 





#' A standard way to summarise the quality of a parameterized prediction algorithm is with the "Area Under the Curve." Which curve? This one! 
#' Note: these functions come from the "yardstick" package. 





#' Hey look, we got almost exactly a straight line! That's good, right? 

#' We can extract the AUC with another convenient function:




#' Ok, so these measures are not good -- 0.5 is the lowest possible AUC score for binary classification. So, we should try a different model. Before we do, let's again write a function that allows us to easily compare models:





#' Let's try a different formula



#' EXERCISE: Try some more formulae. How high can you get the AUC? 



#' Let's see if we can figure out from the data what features of a listing might contribute to a disastrous stay. This formula extracts all the review scores except the overall rating. 




#' Which factors appear to be the most important in determining whether a stay went disastrously wrong? This finding illustrates an important feature of statistical modeling: often we can both make predictions and learn about interpretable patterns in the data. 

#' ----------------------------------------------------
#' UNSUPERVISED LEARNING: CLUSTERING
#' ----------------------------------------------------
#' When performing unsupervised learning like clustering, we don't usually have an objective function that can be used to measure the quality of our model. Often, this requires us to be creative in how we measure the success of a supervised learning model. 
#' We're going to try a fun little task: suppose we don't know anything about the neighborhoods of Boston. Can we "learn" neighborhoods from the AirBnB listings data? That is, can we partition the data in such a way that closely aligns with the listed neighborhoods (without using this column of course!)? 

#' Let's give it a try. For computational and plotting reasons later, we'll stick to the first 1000 listings. 




#' Now let's extract the longitude and latitude and make a matrix out of them. 


#' Let's add two kinds of clusters to the data. 
#' - *K-means* clustering may be familiar to you. When we do k-means, we iteratively move a set of "centers" around in space until they are "aligned" with the data according to a least-squares criterion. 
#' - *Spectral clustering* is a popular form of clustering in the machine learning community. The "secret sauce" is running the data through a big pile of linear algebra first, and then doing k-means in "the projected eigenspace of the normalized graph Laplacian." Don't worry about it. 



#' First, let's plot each of these on a map. 




#' Next, let's get a basemap of Boston from online. This is the same code we used back in August, although I've expanded the bounding box slightly. 




#' EXERCISE: Create a faceted pair of maps, with each pane of the facet corresponding to a clustering method, and color representing the cluster identity. You might find it useful to use color = factor(cluster) in your aesthetic -- the factor() will help ggplot interpret it as categorical, resulting in better colors. You'll probably want to use facet_wrap(~method) somewhere in your pipeline. You might also want to try appearance modifiers like guides(color = FALSE) or theme_void(). 



#' We can also visualize how each clustering algorithm "chopped up" the neighborhoods. For this we'll use geom_tile(), which we haven't done much before.  


#' Which neighborhoods are cleanly "resolved" by each method? 
#' 
#' EXERCISE: Discuss with your partner how you might be able to quantify how successfully each algorithm performed in identifying the neighborhoods of Boston. Are you able to implement your recommendation?