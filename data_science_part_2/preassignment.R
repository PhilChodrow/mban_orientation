install.packages("tidyverse")
install.packages("modelr")
install.packages("ROCR")
install.packages("tm")
install.packages("SnowballC")
install.packages("caTools")
install.packages("rpart")
install.packages("rpart.plot")
install.packages("randomForest")
install.packages("xgboost")
install.packages("sp")
install.packages("maps")
install.packages("devtools")
install.packages("RgoogleMaps")
install.packages("png")
install.packages("jpeg")
devtools::install_github("dkahle/ggmap") # Select 21 if prompted
install.packages("RColorBrewer")

library(tidyverse)
library(modelr)
library(ROCR)
library(tm)
library(SnowballC)
library(caTools)
library(rpart)
library(rpart.plot)
library(randomForest)
library(xgboost)
library(ggmap)
library(RColorBrewer)

bag_of_words_ex <- "Twelve astronauts have walked on the moon, and over five hundred people have been in outer space.  Currently, two astronauts from the USA are aboard the International Space Station."
small_corpus <- Corpus(VectorSource(bag_of_words_ex)) %>%
  tm_map(tolower) %>%
  tm_map(PlainTextDocument) %>%
  tm_map(removePunctuation) %>%
  tm_map(stemDocument)
ex_frequencies <- DocumentTermMatrix(small_corpus)
inspect(ex_frequencies)
# The output should match up with "bag-of-words.png"
