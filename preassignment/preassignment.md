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

- **Test for Wrangling and Visualization**: Open the file `wrangle_viz/preassignment_1.rmd` in RStudio. Click the "Knit" button at the top of the source editor, or press `cmd + shift + k` (`ctrl + shift + k` on Windows). After a few moments, RStudio should pop up with a new window containing a dashboard that looks like [this](https://philchodrow.github.io/data_science_intro/wrangle_viz/preassignment_1.html).  If your dashboard matches the example, move on to the next step. If not, please email the instructors with the error message you received. 
