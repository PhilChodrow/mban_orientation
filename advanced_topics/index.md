# Advanced R: Tackling Complex Analyses the Tidy Way


*Instructor: [Phil Chodrow](https://philchodrow.github.io/)*

This is the repository for a half day training on advanced data science in R. Data science is rarely cut-and-dried; each analysis typically provides answers but also raises new questions. This makes the data scientific process fundamentally cyclical:

![](http://r4ds.had.co.nz/diagrams/data-science.png)

*Image credit: Hadley Wickham*

A skilled analyst needs to be able to smoothly transition from data manipulation to visualization to modeling and back. In this session, we focus on advanced use of the `tidyverse` set of packages to smoothly navigate the Cycle of Data Science. 

## Learning Objectives 

Topics covered include:

1. Reinforcement of fundamental wrangling and visualization tools. 
2. Efficient, tidy iterative data pipelines with functional tools. 
3. Tidy model inspection and selection with `broom`. 

While learning these tools, we work a complex case study that will require multiple iterations of manipulation, visualization, and modeling to test a data scientific hypothesis. 

## Preassignment

Prior to Tuesday's session, you must complete the [preassignment](https://philchodrow.github.io/mban_orientation/data_science_intro/preassignment/preassignment.html). This is a short set of instructions to install necessary software and ensure its proper functioning. 

### Install Packages

You should already have installed the `tidyverse` package. If not, 

```{r}
    install.packages('tidyverse')
```

Now we need to install some packages that you may not have used before. Don't forget `type = source` when installing `ggmap` or you may run into errors. 

```{r}
    install.packages('knitr')
    install.packages('ggmap', type = "source")
```

### Test packages

Type or paste the following code into your console and hit "enter." 

```{r}
    library(tidyverse)
    list('To', 'boldly', 'go', 'where', 'no', 'man', 'has', 'gone', 'before') %>% 
        map(nchar) %>% 
        reduce(`*`)
```

Your console should print out `51840`. If you like, take a moment to think about what this code does. 

Next, type or paste the following code into your console and hit "enter." You will need an internet connection for this one. 

```{r}
    library(tidyverse)
    library(ggmap)

    get_map('Boston') %>% ggmap()
```   

A map of the greater Boston area should appear in your viewer pane. 

Please email the instructor if either of these tests do not produce the expected result. 

## Session Materials

You can [download](https://github.com/PhilChodrow/mban_orientation/archive/master.zip) all the course materials as a `.zip` file. If you need to quickly reference individual materials, use the links below. For best results, `git clone` the repository.  

- [Slides](https://philchodrow.github.io/mban_orientation/advanced_topics/slides.html), [source](https://philchodrow.github.io/mban_orientation/advanced_topics/slides.Rmd)
- [Notes](https://philchodrow.github.io/mban_orientation/advanced_topics/notes.html), [source](https://philchodrow.github.io/mban_orientation/advanced_topics/notes.Rmd)
- Case Study: [student version](https://philchodrow.github.io/mban_orientation/advanced_topics/case_study_student.R), [complete version](https://philchodrow.github.io/mban_orientation/advanced_topics/case_study_complete.R)


