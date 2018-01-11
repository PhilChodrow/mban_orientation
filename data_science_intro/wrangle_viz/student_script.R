
# ----------------------------------------------
# INTRODUCTION
# ----------------------------------------------
# In this section, we'll load our key library, read in the data, and take a look at it. 
# First, let's check that R knows where to look for files. Navigate to 
# Session -> Set Working Directory -> Source File Location

# load the tidyverse library
library(tidyverse)

# load the data we'll use today
listings <- read_csv("../data/listings.csv")
calendar <- read_csv("../data/calendar.csv")
# Inspect the data


# Use head() to look at just the first rows


# Use colnames() to get the names of the columns


# Use glimpse() to get a structured overview of the data


# ----------------------------------------------
# WARMUP: The Nicest Spots in JP
# ----------------------------------------------

# Now let's start digging into our data. You have been asked to provide a simple quantitative answer to the following question: 
# > What are the "best" listings in Jamaica Plain?

# For any data scientific question, there are usually many good ways to answer it. This time, our approach will be to construct a list of all listings in Jamaica Plain, sorted in descending order by rating. To do this, we'll need to: 

# 1. `Filter` out all listings that aren't in Jamacia Plain.
# 2. `Arrange` the rows of the resulting data frame in descending order by rating. 
# 3. `Select` a small number of columns so that we don't display irrelevant ones. 

# Let's go ahead and do this. We'll start out with a simple but slightly clunky way, and then see how to dramatically simplify it using some syntactical magic. 

# filter() to include only JP listings
JP_only <- filter(listings, neighbourhood == "Jamaica Plain")

# arrange() to sort in descending order by rating        
JP_sorted <- arrange(JP_only, -review_scores_rating)

# Select only the columns we want to see               
JP_best <- select(JP_sorted, neighbourhood, name, review_scores_rating)


# Problem: this code wastes:
# 1. **Headspace** to think of names for the intermediate steps that we don't actually care about. 
# 2. **Writing time** to write those names and include them in the function calls.
# 3. **Computer memory** to store the intermediate steps. This doesn't matter so much now, but for larger data sets this will rapidly become a problem. 

# Let's see if we can address these problems using nested syntax instead. 




# Ok, that's no longer wasteful, but it's also illegible. What to do? Back to the slides to discuss the pipe

# -----------------------------------------------------
# EXERCISE 1: The Pipe
# -----------------------------------------------------

# Working with your partner, please rewrite the JP code using the pipe operator. Here's the first line to get you started:

listings %>% 
	filter(neighbourhood == 'Jamaica Plain')

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------






# -----------------------------------------------------
# EXERCISE 2: The Biggest Place in Back Bay
# -----------------------------------------------------

# You are going to spend a long weekend in Back Bay with 50 of your closest friends.

# Working with your partner, modify your code slightly to construct a table of the listings in Back Bay, sorted by the number of people who can stay there. Display the price column as well. You may need to use `glimpse` to see which columns you'll want to use. 

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------








# -----------------------------------------------------------------
# Exploratory Data Analysis
# -----------------------------------------------------------------

# Remember our case study -- we are going to provide recommendations to AirBnB on where to focus their host recruitment efforts. To that end, let's see how to construct a simple summary table in which we'll display the average rating and price-per-guest by neighborhood. To get there, we'll need to do some simple data cleaning, for which we'll introduce some new functions in the slides. 

# We'd like to construct the price-per-person column, but we have an issue: 





# The as.numeric function is useful for converting things that "should be numbers," but it doesn't know how to deal with the "$" sign. We can use a basic string manipulation function to drop the $ signs and commas, allowing us to make a numeric conversion.

listings = listings %>% 
  mutate(price = as.numeric(gsub("\\$|,", "", price)),
         price_per = price/accommodates) %>%
  


# We can place this in the context of our data manipulation pipelines using the mutate() function, which lets us create new columns.





# In fact, we can construct multiple new columns in the same call to mutate()




# Nifty! Now let's summarize the number of records, mean price_per, and mean rating. 




# This appears to have worked, but isn't tremendously useful. We usually want to slice and dice our data by values of different variables. We can do that by adding in the group_by() function to our pipeline. Toward our motivating question, we'll group_by(neighbourhood) here. 




# -----------------------------------------------------
# EXERCISE 3: Summarising Data
# -----------------------------------------------------

# Modify the summary table above as follows: 
# 
# 1. Group by property_type as well as neighborhood. How does this impact the output?
# 2. Add a new column to the table with the average rate per person for WEEKLY rentals, using the weekly_price column. 
# 3. Add a new column giving the total "capacity" for each neighborhood, given as the total number of beds in rentals in that neighborhood. 
# 4. Name the result summary_table

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------





# -----------------------------------------------------
# EXERCISE 4: Grouped Mutate
# -----------------------------------------------------

# If you check `summary_table`, you'll notice that it has exactly one grouping column: `neighbourhood`. Working with your partner, 

# 1. Explain why there is just one grouping column now, considering that we made two groups in Exercise 3.
# 2. Use `mutate` to construct a `rank` column where the top-ranked row has the highest value of `n` (i.e. most popular type). You might want the `min_rank` function and the `desc` function we used when sorting. What behavior do you observe?
# 3. Filter to include only rows of rank 3 or less. 
# 4. Sort the rows in descending order by `n` using `arrange`. What behavior do you observe now? See if you can get the table sorted in descending order by rank, while keeping neighbourhoods grouped together. 

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------




# -----------------------------------------------------------------
# RELATIONAL DATA
# -----------------------------------------------------------------

# How current is this summary data? Does it reflect how things are NOW, or how things were many months or even years ago? In this section, we're going to see how to use data relations to filter the data to only listings with recent, valid listing dates. Let's go back to the slides for a bit to see what we need to do. 

# -----------------------------------------------------
# EXERCISE 5: Keeping Current
# -----------------------------------------------------

# Construct a table from the `calendar` data giving the listings that had a valid listed date between June 1st, 2016 and today. You determine what "valid" means in this context. 

# *Hint:* You can represent a date using the function 

lubridate::mdy('6/1/2016')

# You can also use `lubridate::today()`. You can use `max()` to get the most recent date.

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------






# Now we're ready to relate this table to listings. The left_join() function lets us specify which column(s) in listings correspond to which column(s) in current_table




# Now we can re-run our analysis from above using only the recent listings




# -----------------------------------------------------------------
# GETTING VISUAL
# -----------------------------------------------------------------

# Use the space below to follow along with the introductory visualizations on the slides

# First Plot





# Changing It Up





# -----------------------------------------------------
# EXERCISE 6: TRENDS OVER TIME
# -----------------------------------------------------

# The following code computes the average price of all listings on each day in the data set:

average_price_table <- calendar %>% 
	mutate(price = price %>% gsub('\\$|,', '',.) %>% as.numeric()) %>% 
	group_by(date) %>% 
	summarise(mean_price = mean(price, na.rm = TRUE))

# Use geom_line() to visualize these prices with time on the x-axis and price on the y-axis. 

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------






# -----------------------------------------------------
# EXERCISE 7: Bar Charts
# -----------------------------------------------------

# Using the `summary_table` object you created earlier, make a bar chart showing the number of **apartments** by neighbourhood. In this case, the correct `geom` to use is `geom_bar(stat = 'identity')`. 

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------




# slightly cleaner




# Comparisons: Fill, Color, and Facets





# Optional: breakout by score types



