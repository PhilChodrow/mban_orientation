# This is the script used for the live coding session. Some of the 
# portions have already been filled for you, but others you will have to do
# yourself as exercises. These will be clearly marked

#### Data ####
# We need to load the Keras library and get the Boston data
library(keras)
boston = dataset_boston_housing()

# Get the training and test sets
X_train = boston$train$x
y_train = boston$train$y
X_test = boston$test$x
y_test = boston$test$y


#### Exploratory Analysis ####

# Before we start working with neural networks, to both gain some intuition 
# about what's going on with this data as well as give a good warm-up to R,
# let's start with some exercises; I have provided the column names for the
# Boston data
library(tidyverse)
col_names = c('CRIM', 'ZN', 'INDUS', 'CHAS', 'NOX', 'RM', 'AGE', 
              'DIS', 'RAD', 'TAX', 'PTRATIO', 'B', 'LSTAT')

train_df = as_tibble(X_train)
colnames(train_df) = col_names
train_df$PRICE = y_train

mu_vect = apply(X_train, 2, mean)
sigma_vect = apply(X_train, 2, sd)

X_train = sweep(X_train, 2, mu_vect, "-", check.margin = F)
X_train = sweep(X_train, 2, sigma_vect, "/", check.margin = F)

X_test = sweep(X_test, 2, mu_vect, "-", check.margin = F)
X_test = sweep(X_test, 2, sigma_vect, "/", check.margin = F)


model = keras_model_sequential()

# The first component of the Keras API is defining a model. This can be done
# by typing
model %>% 
  layer_dense(units = 32, activation = "relu",  
              input_shape = dim(X_train)[2]) %>% 
  layer_dense(units = 1, activation = "linear")




# After we have defined our model, we can look at what we have instantiated by
# typing
summary(model)

# The next thing a Keras model needs is a compiler -- specifically it needs
# to know how the model should be optimized
model %>% compile(
  loss = 'mse',
  optimizer = optimizer_sgd()
)

# Finally we need to tell the API how we want to train the model. This can 
# be done by typing
model %>% fit(
  x = X_train, y = y_train,
  epochs = 10, verbose = 1,
  validation_split = 0.25,
  batch_size = 128
)

model %>% evaluate(X_test, y_test)





