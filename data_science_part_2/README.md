# Data Science in R: Part 2
*Instructors: Colin Pawlowski, Omar Skali Lami*

This repository contains materials for the MBAn SIP week session 9am-12pm on October 26, 2018.  The session covers both basic and advanced topics on data science in R, including data wrangling, feature-engineering from text data, and tree-based models (CART, Random Forest, and Boosting).  It is intended to be the follow-up session to the MBAn day-long crash-course on data science in R, available [here](https://github.com/PhilChodrow/mban_orientation/tree/master/data_science_intro).  

# Objectives

The objectives of this session are two-fold.  First, the goal is to teach practical data wrangling in R, and revisit some of the concepts that we saw in the first R session.  In particular, we will see how the `tidyverse` is a powerful tool for creating data pipelines.  Second, the goal is to explore how some advanced machine learning methods can be easily implemented in R.  We will look at some popular open-source packages and apply these to a real-world data set.  


We will focus on some widely used tree-based models: CART, Random Forest, and Boosting.  



# Preassignment

1.  From the MBAn orientation, you probably already have recent versions of R (version 3.5.1+) and RStudio (version 1.1.456+)
installed on your computer.  If not, then you can install them from the following websites:

 - https://cran.cnr.berkeley.edu/ (R)
 - https://www.rstudio.com/products/rstudio/download/ (RStudio)



2.  For this session, we will use several R packages, which you can install by running the following commands in R:

install.packages("tidyverse")

install.packages("rpart")

install.packages("rpart.plot")

install.packages("xgboost")

install.packages("ROCR")


If you encounter any error messages that you are unable to handle, please email Colin at cpawlows@mit.edu.

