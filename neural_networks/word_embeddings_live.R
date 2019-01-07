# Load the packages we'll need for this session
library(keras)
library(tidyverse)

#### Data ####
imdb <- dataset_imdb()

# Get the train-test split
X_train <- imdb$train$x
y_train <- imdb$train$y
X_test <- imdb$test$x
y_test <- imdb$test$y

#### Exploratory Analysis ####

# The data is in a somewhat unusual format; let's take a look at how it's 
# currently formated and how we'll need to adjust it to be used by Keras
X_train[[1]]

## Exercise 1 ##

# Typically, natural language processing problems are very skewed -- namely, a
# small number of words cover most of the uses in the data. If this is true, 
# then this typically implies we can shrink the vocabulary without paying a 
# big price in terms of model performance while significantly speeding up 
# computation time (similar to PCA). To check this hypothesis, our first 
# exercise for this project will be to look at the distribution of words in the
# data. Specifically, I would like you to create a histogram displaying the word
# usage distribution in each of the reviews. To do this, you will need to 
# represent the training data as a DataFrame and use this DataFrame to make a 
# histogram.

# Fill in the create_word_df function

# An example of a valid output for this function would look like

# sample_num_vect | words
# -----------------------
# 1               | 15
# 1               | 27
# 1               | 3
# ...

create_word_df = function(word_vect, sample_num) {
  # Repeat the sample_num an appropriate number of times
  
  # Return a DataFrame with two columns: the sample_num_vect and the words
}

# Apply the user-created function to each element of the X_train list
# hence we will need purrr's map (please think about what this code is doing
# you will be using it quite a bit in the next session)
word_df = map2_df(.x = X_train, .y = 1:length(X_train), 
                  .f = ~ create_word_df(.x, .y))

# Using the DataFrame we just created to plot the distribution of words in 
# the data

## Exercise 2 ##

# Before we can use a word embedding model, each of the word vectors need to
# have the same size; therefore, we need to see the distribution of review
# lengths in the data. Please generate a boxplot using ggplot and dplyr
# techniques

# HINT: n() is a function which tells you how many rows are in a group

# HINT: When calling boxplots in ggplot with only one group, it is not
# necessary to provide an x variable

#### Data Pre-Processing ####

# Grab our data again with the constraints described above
imdb <- dataset_imdb(num_words = 5000, maxlen = 500, seed = 17)
X_train <- imdb$train$x
y_train <- imdb$train$y
X_test <- imdb$test$x
y_test <- imdb$test$y

# Pad our sequences if they're less than 500
X_train <- pad_sequences(sequences = X_train, maxlen = 500)
X_test <- pad_sequences(sequences = X_test, maxlen = 500)

# Let's check to make sure our data looks correct
X_train[1, ]

#### Word Embeddings ####

## Exercise 3 ##

# For this exercise, using the Keras API and the following layers:
# layer_embedding and layer_global_average_pooling_1d() generate a neural network
# with the following hyper-parameters

# Embedding layer with 32 dimensional word vectors
# Default layer_global_average_pooling_1d()
# One dense layer with 64 units

# HINT: when you have a binary output, the final activation function is "sigmoid"
# and only has one unit

# Now that we have defined the model, let's compile and fit it
model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = optimizer_sgd(),
  metrics = c('accuracy')
)

res = model %>% fit(
  x = X_train, y = y_train,
  epochs = 5, batch_size = 128, 
  validation_split = 0.25
)

# Evaluate the performance of the model
model %>% evaluate(X_test, y_test)

#### Optimizers ####

## Exercise 4 ##

# Using the optimization algorithm that was assigned to your group, define and
# train an embedding model that has the same specifications as before; plot
# the history and report the final test error. Remember to type out the
# neural network and do not just copy-paste
