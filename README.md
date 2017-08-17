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

## 1. Install `R` and RStudio

**We are assuming that you have recent versions of `R` and RStudio installed.** In particular, you need `R` version 3.3.2 or later, and RStudio 1.0.44 or later. For this reason, we **strongly recommend** that you download and install both `R` and RStudio, even if both are already on your laptop. 
 
- **Install `R`**: Navigate to [`https://cran.cnr.berkeley.edu/`](https://cran.cnr.berkeley.edu/) and follow the instructions for your operating system. 
- **Download RStudio**: Navigate to [`https://www.rstudio.com/products/rstudio/download/`](https://www.rstudio.com/products/rstudio/download/) and download RStudio Desktop with an Open Source License. 
- **Test Your Installation**: Open RStudio and type 1+2 into the Console window, and press "Enter." 

## 2. Install Packages

In the RStudio console, type 
```
install.packages(c('tidyverse', 'knitr', 'flexdashboard' 'glmnet', 'ROCR'))
```

## 3. Test Packages

- **Test for Wrangling and Visualization**: Open the file `wrangle_viz/preassignment_1.rmd` in RStudio. Click the "Knit" button at the top of the source editor, or press `cmd + shift + k` (`ctrl + shift + k` on Windows). After a few moments, RStudio should pop up with a new window containing a dashboard that looks like [this](preassignment_1.html).  If your dashboard matches the example, move on to the next step. If not, please email the instructors with the error message you received. 








