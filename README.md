# Introduction to Data Science in R
*Instructors: Daisy Zhuo and Phil Chodrow*

This is the repository for a day-long intensive crash-course on data science in R. Data science is rarely cut-and-dried; each analysis typically provides answers but also raises new questions. This makes the data scientific process fundamentally cyclical:

![](http://r4ds.had.co.nz/diagrams/data-science.png)

*Image credit: Hadley Wickham*

The course aims to familiarize students with the major stages of the circle of data science. The first part of the training covers data preparation and exploratory analysis, including import, data preparation/cleaning, and data visualization. The second part is an in-depth case study that reinforces these skills and introduces elementary statistical modeling methods in the context of answering a complex question using a real-world data set. 

# Packages Covered

This training is fully committed to the Tidyverse, a set of packages that make data science in `R` structured, efficient, and (occasionally) fun. We'll spend most of our time covering: 

- `dplyr`: data wrangling and exploratory summaries 
- `tidyr`: data reshaping and visualization prep
- `ggplot2`: state of the art 2-d data visualization
- `modelr`: convenient, unified syntax for fitting statistical models
- `broom`: convenient, unified syntax for extracting information from statistical models

# Prerequisites

This training does not require any specific theoretical background. However, all students are expected to have: 

1. An installation of the `R` programming language.
2. An installation of `RStudio`.
3. Installations of the following packages: 
    - `tidyverse`
    - `knitr`
    - `flexdashboard`
    - `glmnet`
    - `ROCR`

# Preassignment

To participate in the session, please make sure that you complete the [preassignment](https://philchodrow.github.io/data_science_intro/preassignment/preassignment.html) beforehand. 


- **Test for Machine Learning**: in the RStudio console, type:
```
library(ROCR)
data(ROCR.simple)
pred <- prediction( ROCR.simple$predictions, ROCR.simple$labels)
perf <- performance(pred,"tpr","fpr")
plot(perf)

library(glmnet)
set.seed(1)
x=matrix(rnorm(100*20),100,10)
y=rnorm(100)
fit1=glmnet(x,y)
coef(fit1,s=0.01)
```

You should see a plot in the Plots view and the following in the console without error or warnings:
```
11 x 1 sparse Matrix of class "dgCMatrix"
                       1
(Intercept) -0.158258850
V1           0.098817343
V2           0.165398212
V3           0.116463429
V4           0.058015887
V5           .          
V6          -0.016297388
V7          -0.022790678
V8          -0.173383945
V9           0.006271685
V10          0.053314144
```





