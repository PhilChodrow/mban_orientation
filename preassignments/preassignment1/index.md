---
title: "Preassignment: Days 1 and 2"
---

This is a **long** preassignment that involves lots of software installation and testing. Please leave a total of at least **2 hours** to complete this preassignment. That may seem like a long time, but once you've done it you'll have a powerful suite of software that you can use through your career at MIT and beyond. 



# Version Control: Git and GitHub

`git` is a powerful system for collaborating on and publishing software. It is standard in the worlds of data science and software development. Learning to use `git` will help you manage your own work; collaborate with colleagues; and access useful tools. 

## Install `git`

Get started by installing `git`. You can follow the relevant instructions for your operating system [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). For Windows 10 users, we suggest installing and interacting with `git` either via the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or via the [GitHub Desktop Client](https://desktop.github.com).

## Make an Account on GitHub.com

[GitHub](https://github.com/) is a hosting service for `git` that makes it easy to share your code. 

1. Sign up for an account -- remember to keep track of your username and password. 
2. Link your GitHub.com credentials to your local `git` installation.  

## Test Your Installation

INSERT TEST

# Data Analysis: `R` and RStudio

## Install `R` and RStudio

**We are assuming that you have recent versions of `R` and RStudio installed.** In particular, you need `R` version 3.5.1 and RStudio 1.1.456. For this reason, we **strongly recommend** that you download and install both `R` and RStudio, even if both are already on your laptop. 
 
- **Install `R`**: Navigate to [`https://cran.cnr.berkeley.edu/`](https://cran.cnr.berkeley.edu/) and follow the instructions for your operating system. 
- **Download RStudio**: Navigate to [`https://www.rstudio.com/products/rstudio/download/`](https://www.rstudio.com/products/rstudio/download/) and download RStudio Desktop with an Open Source License. 
- **Test Your Installation**: Open RStudio and type 1+2 into the Console window, and press "Enter." If you see the expected result, you are ready to move on. 

## Install Packages

In the RStudio console, type 
```
install.packages(c('tidyverse', 'knitr', 'flexdashboard', 'glmnet', 'ROCR', 'nycflights13', 'caToools', 'quantreg'))
```

If you encounter any error messages that you are unable to handle, please email Phil at `pchodrow@mit.edu`. 

## Test Packages

## Test Packages

[Download](https://philchodrow.github.io/mban_orientation/data_science_intro/preassignment/preassignment1.Rmd) and open the file `preassignment1.rmd` in RStudio. Click the "Knit" button at the top of the source editor, or press `cmd + shift + k` (`ctrl + shift + k` on Windows). The "Knit" button is the one circled in [this image](http://cinf401.artifice.cc/images/workflow-25.png).

After a few moments, RStudio should pop up with a new window containing a dashboard that looks like [this](https://philchodrow.github.io/mban_orientation/data_science_intro/preassignment/preassignment1.html).  If your dashboard matches the example, move on to the next step. If not, please email Phil (`pchodrow@mit.edu`) with the error message you received. 


# Optimization: Julia and JuMP

