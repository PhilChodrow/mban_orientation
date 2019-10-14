## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)

## ----readdata------------------------------------------------------------
library(tidyverse)
listings <- readRDS("../data/listingsML.RDS")

## ----splitData-----------------------------------------------------------
# install.packages("caTools")
library(caTools)
set.seed(123)
spl <- sample.split(listings$price, SplitRatio = 0.7)
listingsTrain <- listings[spl,]
listingsTest <- listings[!spl,]

## ----lm1-----------------------------------------------------------------
lm1 <- lm(price ~ accommodates, data = listingsTrain)

## ----view_lm1------------------------------------------------------------
names(lm1)
lm1$coefficients
summary(lm1)

## ----plotFit-------------------------------------------------------------
# install.packages("modelr")
library(modelr)
listingsTrain %>%	
  add_predictions(lm1) %>%	
  ggplot(aes(x = accommodates)) +	
  geom_point(aes(y = price)) +	
  geom_line(aes(y = pred), color = 'red')

## ----addResiduals--------------------------------------------------------
listingsTrain %>%	
  add_residuals(lm1, var = "resid") %>%	
  group_by(as.factor(accommodates)) %>%	
  ggplot(aes(x = as.factor(accommodates), y = resid)) + 
  geom_boxplot()

## ----OSR2----------------------------------------------------------------
pred_test <- predict(lm1, newdata = listingsTest)
OSR2 <- 1 - sum((pred_test - listingsTest$price) ^ 2) /
  sum((mean(listingsTrain$price) - listingsTest$price) ^ 2)

## ----overfitting---------------------------------------------------------
summary(lm1)
OSR2

## ----exercise1.3---------------------------------------------------------
data <- readRDS("../data/listingsMLwithOutliers.RDS")

## ----moreFeatures--------------------------------------------------------
lm2 <- lm(price ~ ., data = listingsTrain)

## ----OSR2lm2-------------------------------------------------------------
pred_test <- predict(lm2, newdata = listingsTest)
OSR2_2 <- 1 - sum((pred_test - listingsTest$price) ^ 2) /
  sum((mean(listingsTrain$price) - listingsTest$price) ^ 2)

## ----overfitting_lm2-----------------------------------------------------
summary(lm2)$r.squared
OSR2_2

## ----glmnetPackage-------------------------------------------------------
library(glmnet)
?glmnet

## ----modelMatrix---------------------------------------------------------
x <- model.matrix(price ~ ., data = listings)
y <- as.vector(listings$price)

## ----splitLasso----------------------------------------------------------
set.seed(123)
spl <- sample.split(y, SplitRatio = 0.7)
xTrain <- x[spl, ]
xTest <- x[!spl, ]
yTrain <- y[spl]
yTest <- y[!spl]

## ----lasso1--------------------------------------------------------------
lasso1 <- glmnet(xTrain, yTrain)

## ----lassoSummary--------------------------------------------------------
summary(lasso1)

## ----lassoHighLambda-----------------------------------------------------
lasso1$lambda[1]
lasso1$beta[, 1] # How many coefficients are nonzero?	

## ----smallerLambda-------------------------------------------------------
lasso1$lambda[10]	
beta <- lasso1$beta[, 10] 
beta[which(beta != 0)]
	
lasso1$lambda[20]
beta <- lasso1$beta[, 20]
beta[which(beta != 0)]

## ----lassoCV-------------------------------------------------------------
lasso2 <- cv.glmnet(xTrain, yTrain)
summary(lasso2) # What does the model object look like?	

## ----lassoPlotCV---------------------------------------------------------
plot.cv.glmnet(lasso2)

## ----predictLassoCV------------------------------------------------------
?predict.cv.glmnet
pred_train <- predict.cv.glmnet(lasso2, newx = xTrain, s = "lambda.1se")
pred_test <- predict.cv.glmnet(lasso2, newx = xTest, s = "lambda.1se")

## ----lassoCV_R2----------------------------------------------------------
R2_lasso <- 1 - sum((pred_train - yTrain) ^ 2) /
  sum((mean(yTrain) - yTrain) ^ 2)
OSR2_lasso <- 1 - sum((pred_test - yTest) ^ 2) /
  sum((mean(yTrain) - yTest) ^ 2)
R2_lasso
OSR2_lasso

## ----lassoCVcoefficients-------------------------------------------------
lambdaIndex <- which(lasso2$lambda == lasso2$lambda.1se)
beta <- lasso2$glmnet.fit$beta[,lambdaIndex]
beta[which(beta != 0)]

## ----logRegExample-------------------------------------------------------
x <- seq(-10, 10, 0.25)
y <- exp(x) / (1 + exp(x))
plot(x, y)

## ----elevatorSplit-------------------------------------------------------
set.seed(123)
spl <- sample.split(listings$amenity_Elevator_in_Building, SplitRatio = 0.7)
elevatorTrain <- listings[spl,]
elevatorTest <- listings[!spl,]

## ----logReg--------------------------------------------------------------
logReg1 <- glm(amenity_Elevator_in_Building ~ price,
            family = "binomial", data = elevatorTrain)
summary(logReg1)

## ----confusionMatrix-----------------------------------------------------
# Training Confusion Matrix
pred_train <- predict(logReg1, newdata = elevatorTrain)
confusionMatrixTrain <- table(elevatorTrain$amenity_Elevator_in_Building,
                         ifelse(pred_train > 0.5, "pred = 1", "pred = 0"))
confusionMatrixTrain
# Training Accuracy
sum(diag(confusionMatrixTrain)) / nrow(elevatorTrain)
# Testing Confusion Matrix
pred_test <- predict(logReg1, newdata = elevatorTest)
confusionMatrixTest <- table(elevatorTest$amenity_Elevator_in_Building,
                         ifelse(pred_test > 0.5, "pred = 1", "pred = 0"))
confusionMatrixTest
# Testing Accuracy
sum(diag(confusionMatrixTest)) / nrow(elevatorTest)

## ----logRegAUC-----------------------------------------------------------
# install.packages("ROCR")
library(ROCR)
pred_test <- predict(logReg1, newdata = elevatorTest, type = "response")	
pred_obj <- prediction(pred_test, elevatorTest$amenity_Elevator_in_Building)

# Creating a prediction object for ROCR
perf <- performance(pred_obj, 'tpr', 'fpr')	
plot(perf, colorize = T) # ROC curve
performance(pred_obj, 'auc')@y.values[[1]] # AUC - a scalar measure of performance	

