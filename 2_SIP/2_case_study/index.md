# Advanced R: Tackling Complex Analyses the Tidy Way

*Instructor: [Phil Chodrow](https://philchodrow.github.io/)*

This is the repository for a half day training on advanced data science in R. Data science is rarely cut-and-dried; each analysis typically provides answers but also raises new questions. This makes the data scientific process fundamentally cyclical:

![](http://r4ds.had.co.nz/diagrams/data-science.png)

*Image credit: Hadley Wickham*

In this session, we will work through a complex case study that requires multiple iterations of manipulation, visualization, and modeling in order to test a data scientific hypothesis. Along the way, we will learn how to use advanced tools from the `tidyverse` set of packages to smoothly transition between these stages of the data-scientific methods. 

## Learning Objectives 

By the end of this session, students will be able to:

1. Pose a data scientific hypothesis and plan analyses by which test it. 
2. Use advanced data manipulation and visualization to explore complex data sets. 
3. Craft efficient, tidy, and iterative data pipelines using basic functional programming tools. 
4. Perform tidy model inspection and selection with `broom`. 

## Preassignment

Prior to the session, you must complete the preassignment below. This is a short set of instructions to install necessary software and ensure its proper functioning. 

### Install Packages

You should already have installed the `tidyverse` package. If not, 

```{r}
install.packages('tidyverse')
```

Now we need to install some packages that you may not have used before. 

```{r}
install.packages('knitr')
install.packages('leaflet')
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
    library(leaflet)

    m <- leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12)
    m %>% addTiles()
```   

A map of the greater Boston area should appear in your viewer pane. 

Please email the instructor if either of these tests do not produce the expected result. 

## Session Materials

You can [download](https://github.com/PhilChodrow/mban_orientation/archive/master.zip) all the course materials as a `.zip` file. If you need to quickly reference individual materials, use the links below. For best results, `git clone` the repository.  

- [Slides](https://philchodrow.github.io/mban_orientation/advanced_topics/slides.html), [source](https://philchodrow.github.io/mban_orientation/advanced_topics/slides.Rmd)
- Case Study: [student version](https://philchodrow.github.io/mban_orientation/advanced_topics/case_study_student.R), [complete version](https://philchodrow.github.io/mban_orientation/advanced_topics/case_study_complete.R)


