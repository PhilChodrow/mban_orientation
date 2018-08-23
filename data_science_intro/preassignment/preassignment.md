---
title: Preassignment
---

# Preassignment

## 1. Install `R` and RStudio

**We are assuming that you have recent versions of `R` and RStudio installed.** In particular, you need `R` version 3.5.1 and RStudio 1.1.456.For this reason, we **strongly recommend** that you download and install both `R` and RStudio, even if both are already on your laptop. 
 
- **Install `R`**: Navigate to [`https://cran.cnr.berkeley.edu/`](https://cran.cnr.berkeley.edu/) and follow the instructions for your operating system. 
- **Download RStudio**: Navigate to [`https://www.rstudio.com/products/rstudio/download/`](https://www.rstudio.com/products/rstudio/download/) and download RStudio Desktop with an Open Source License. 
- **Test Your Installation**: Open RStudio and type 1+2 into the Console window, and press "Enter." 

## 2. Install Packages

In the RStudio console, type 
```
install.packages(c('tidyverse', 'knitr', 'flexdashboard', 'glmnet', 'ROCR', 'nycflights13'))
```

If you encounter any error messages that you are unable to handle, please email Phil at `pchodrow@mit.edu`. 

## 3. Test Packages

### Test for Wrangling and Visualization 

[Download](https://philchodrow.github.io/mban_orientation/data_science_intro/preassignment/preassignment1.Rmd) and open the file `preassignment1.rmd` in RStudio. Click the "Knit" button at the top of the source editor, or press `cmd + shift + k` (`ctrl + shift + k` on Windows). The "Knit" button is the one circled in [this image](http://cinf401.artifice.cc/images/workflow-25.png).

After a few moments, RStudio should pop up with a new window containing a dashboard that looks like [this](https://philchodrow.github.io/mban_orientation/data_science_intro/preassignment/preassignment1.html).  If your dashboard matches the example, move on to the next step. If not, please email Phil (`pchodrow@mit.edu`) with the error message you received. 

### Test for Case Study 

Type or copy/paste the code below into the RStudio console window. 

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

You should see a plot appear in the Plots pane, and the following output appear in the console window. 

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



