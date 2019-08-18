
# ----------------------------------------------
# INTRODUCTION
# ----------------------------------------------
# In this section, we'll load our key library, read in the data, and take a look at it. 
# First, let's check that R knows where to look for files. Navigate to 
# Session -> Set Working Directory -> Source File Location

# load the tidyverse library
library(tidyverse)
library(lubridate) # for date manipulation later


# load the data we'll use today
listings <- read_csv('../../data/listings.csv')
calendar <- read_csv('../../data/calendar.csv')

# I'm going to do just a little bit of data cleaning for you. 
# There are a few columns in each data set that should be prices but R will read them as strings. 
# The below three lines fix that. 

source("clean_prices.R")
listings <- clean_prices(listings)
calendar <- clean_prices(calendar)


# Inspect the data
listings

# Use head() to look at just the first rows
head(listings) 

# Use colnames() to get the names of the columns
colnames(listings) 

# Use glimpse() to get a structured overview of the data
glimpse(listings)

# ----------------------------------------------
# WARMUP: The Nicest Spots in JP
# ----------------------------------------------

# Now let's start digging into our data. You have been asked to provide a simple 
# quantitative answer to the following question: 
# > What are the "best" listings in Jamaica Plain?

# For any data scientific question, there are usually many good ways to answer it. 
# This time, our approach will be to construct a list of all listings in Jamaica
# Plain, sorted in descending order by rating. To do this, we'll need to: 

# 1. `Filter` out all listings that aren't in Jamaica Plain.
# 2. `Arrange` the rows of the resulting data frame in descending order by rating. 
# 3. `Select` a small number of columns so that we don't display irrelevant ones. 

# Let's go ahead and do this. We'll start out with a simple but slightly clunky 
# way, and then see how to dramatically simplify it using some syntactical magic. 

# filter() to include only JP listings
jp_only <- filter(listings, neighbourhood == 'Jamaica Plain')
# arrange() to sort in descending order by rating        
jp_sorted  <- arrange(jp_only, desc(review_scores_rating))
# Select only the columns we want to see               
jp_best <- select(jp_sorted, neighbourhood, name, review_scores_rating) 
jp_best

# Problem: this code wastes:
# 1. **Headspace** to think of names for the intermediate steps that we don't 
# actually care about. 
# 2. **Writing time** to write those names and include them in the function calls.
# 3. **Computer memory** to store the intermediate steps. This doesn't matter 
# so much now, but for larger data sets this will rapidly become a problem. 

# Let's see if we can address these problems using nested syntax instead. 

select(arrange(filter(listings, neighbourhood == 'Jamaica Plain'), desc(review_scores_rating)), neighbourhood, name, review_scores_rating)

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

listings %>% 
	filter(neighbourhood == 'Jamaica Plain') %>% 
	arrange(desc(review_scores_rating)) %>%            
	select(neighbourhood, name, review_scores_rating)

# -----------------------------------------------------
# EXERCISE 2: The Biggest Place in Back Bay
# -----------------------------------------------------

# You are going to spend a long weekend in Back Bay with 59 of your closest friends.

# Working with your partner, modify your code slightly to construct a table of the listings in Back Bay, sorted by the number of people who can stay there. Display the price column as well. You may need to use `glimpse` to see which columns you'll want to use. 

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------

listings %>% 
	filter(neighbourhood == 'Back Bay') %>% 
	arrange(desc(accommodates)) %>% 
	select(neighbourhood, name, accommodates, price)

# -----------------------------------------------------------------
# Exploratory Data Analysis
# -----------------------------------------------------------------

# Remember our case study -- we are going to provide recommendations to AirBnB on where to focus their host recruitment efforts. To that end, let's see how to construct a simple summary table in which we'll display the average rating and price-per-guest by neighborhood. We can use the accommodates field as a simple estimate of how many people can fit in a listing. 

listings %>% 
	mutate(price_per = price / accommodates)

# Nifty! Now let's summarize the number of records, mean price_per, and mean rating. 

listings %>% 
	mutate(price_per = price / accommodates)  %>% 
	summarize(n = n(), 
			  mean_rating = mean(review_scores_rating, na.rm = TRUE),
			  price_per = mean(price_per, na.rm = TRUE)) 

# This appears to have worked, but isn't tremendously useful. We usually want to slice and dice our data by values of different variables. We can do that by adding in the group_by() function to our pipeline. Toward our motivating question, we'll group_by(neighbourhood) here. 

listings %>% 
	mutate(price_per = price / accommodates)  %>% 
	group_by(neighbourhood) %>% 
	summarize(n = n(), 
			  mean_rating = mean(review_scores_rating, na.rm = TRUE),
			  price_per = mean(price_per, na.rm = TRUE)) 
	
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

summary_table <- listings %>% 
	mutate(price_per = price / accommodates,
		   weekly_price_per = weekly_price / accommodates)  %>% 
	group_by(neighbourhood, property_type) %>% 
	summarize(n = n(), 
			  mean_rating = mean(review_scores_rating, na.rm = TRUE),
			  price_per = mean(price_per, na.rm = TRUE),
			  weekly_price_per = mean(weekly_price_per, na.rm = TRUE),
			  capacity = sum(beds)) 

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

ranked_summary_table <- summary_table %>% 
	mutate(rank = min_rank(desc(n))) %>% 
	filter(rank <= 3) %>% 
	arrange(neighbourhood, rank)

# -----------------------------------------------------------------
# RELATIONAL DATA
# -----------------------------------------------------------------

# How current is this summary data? Does it reflect how things are NOW, or how things were many months or even years ago? In this section, we're going to see how to use relations to incorporate data from multiple tables. 

# Suppose we're planning a trip for September. We'd like to check what listings have availability during September. This information isn't contained in the listings table, but it is contained in the calendar table: 

calendar

# So, how do we get it out? 

# -----------------------------------------------------
# EXERCISE 5: September Availability
# -----------------------------------------------------

# Construct a table with two columns. The first column should give the listing_id of the listing. The second column should be called nights_available and give the total number of nights of availability in the month of September. Finally, filter the result so that the table only contains listings with at least one available night in September. 
# HINT: you might find it useful to see what the following command returns: 

# month("2019-09-03", label = TRUE)

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------

september_availability <- calendar %>% 
	mutate(month = month(date, label = TRUE)) %>% 
	filter(month == 'Sep') %>% 
	group_by(listing_id) %>% 
	summarise(nights_available = sum(available)) %>% 
	filter(nights_available > 0)


# Our next task is to *join* the september_availability table to the listings table. There are many ways to do this, and we're not going to go through all of them today. We will do a left join, which preserves all rows of listings. We need to provide a correspondence between columns of the two tables. 

listings <- listings %>% 
	left_join(september_availability, by = c('id' = 'listing_id'))

# This operation generates NAs when there's no entry in the september_availability table. Let's filter those out: 

listings_sep <- listings %>% 
	filter(!is.na(nights_available))

# -----------------------------------------------------------------
# GETTING VISUAL
# -----------------------------------------------------------------

# Now that we've seen a bit of the theory behind visualization in R, let's get our hands dirty. 

# Let's start with a simple histogram of the review scores. We'll build up this plot line by line. 

listings %>% 
	ggplot() + 
	aes(x = review_scores_rating) + 
	geom_histogram()

# How about a bar chart? What does this code do? 

summary_table %>% 
	filter(property_type == 'Apartment') %>% 
	ggplot() + 
	aes(x = neighbourhood, y = n) + 
	geom_bar(stat = 'identity')

# Ok, well that looks kind of gross. When you have a bar chart and it's gross, you should usually consider flipping the axes, sorting the data, or both: 

summary_table %>% 
	filter(property_type == 'Apartment') %>% 
	ggplot() + 
	aes(x = reorder(neighbourhood, n), y = n) + 
	geom_bar(stat = 'identity') + 
	coord_flip()

# Next, let's do a simple scatter plot of the number of reviews vs. review score. We'll build up this plot line by line. 

listings %>% 
	ggplot() + 
	aes(x = number_of_reviews, y = review_scores_rating) + 
	geom_point(alpha = .2, color = 'firebrick') + 
	theme_bw() + 
	labs(x='Number of Reviews', y='Review Score',title='Review Volume and Review Quality') 

# -----------------------------------------------------
# EXERCISE 6: TRENDS OVER TIME
# -----------------------------------------------------

# First, inspect the calendar table to get a sense for what fields are available. Compute a table with two columns: a date and an average price per day. Finally, make a line chart using geom_line() to visualize the average trend, with date on the x-axis and mean price on the y-axis. 
	
# ----------------------------------------------
# SOLUTION
# ----------------------------------------------

calendar %>% 
	group_by(date) %>% 
	summarise(mean_price = mean(price, na.rm = TRUE)) %>% 
	ggplot() + 
	aes(x = date, y = mean_price) + 
	geom_line()

# Notice anything interesting? We'll come back to this in October...

# We don't usually just want to look at one set of bars or time-series -- we want to make comparisons. The two most common ways to make comparisons in plots are colors and small multiples. Let's grab that scatterplot we made earlier: 

listings %>% 
	ggplot() + 
	aes(x = number_of_reviews, y = review_scores_rating, color = property_type) + 
	geom_point(alpha = .5) + 
	theme_bw() + 
	labs(x='Number of Reviews', y='Review Score',title='Review Volume and Review Quality') 

# This is ok, but it's kind of hard to read because there are so many property types. 

# -----------------------------------------------------
# EXERCISE 7: I'M ON A BOAT?
# -----------------------------------------------------

# Modify this scatter plot so that all points are the same color, EXCEPT for points for which property_type == "Boat".

# -----------------------------------------------------
# SOLUTION
# -----------------------------------------------------

listings %>% 
	mutate(is_boat = property_type == "Boat") %>% 
	ggplot() + 
	aes(x = number_of_reviews, y = review_scores_rating, color = is_boat) + 
	geom_point(alpha = .5) + 
	theme_bw() + 
	labs(x='Number of Reviews', y='Review Score',title='Review Volume and Review Quality')

# This is technically correct, but it's not that useful because I can't actually see any of the boat listings. We can fix this using small multiples -- we'll separate out the boats into their own, separate plot. 
listings %>% 
	mutate(is_boat = property_type == "Boat") %>% 
	ggplot() + 
	aes(x = number_of_reviews, y = review_scores_rating, color = is_boat) + 
	geom_point(alpha = .5) + 
	theme_bw() + 
	labs(x='Number of Reviews', y='Review Score',title='Review Volume and Review Quality') + 
	facet_wrap(~is_boat)

# -----------------------------------------------------
# EXERCISE 8: PRICE OF BOAT STAYS OVER TIME
# -----------------------------------------------------

# When is the best time to stay on a boat? Does it even matter? Create a version of the price-over-time plot that you did in Exercise 6 to answer this question. There should be one trendline for the price per night to stay in a boat, and another trendline for other property types. This exercise will call on multiple skills we've learned so far. In addition to modifying the code given to you in Exercise 6, you'll probably need to use a left-join as well. 

types <- listings %>% select(id, property_type)

calendar %>% 
	left_join(types, by = c('listing_id' = 'id')) %>% 
	mutate(is_boat = property_type == 'Boat') %>%
	group_by(date, is_boat) %>% 
	summarise(mean_price = mean(price, na.rm = TRUE)) %>% 
	ggplot() + 
	aes(x = date, y = mean_price, color = is_boat) + 
	geom_line()
	
# We've covered some of the most important types of plots -- histograms, bar charts, line plots, and scatterplots, as well as ways to slice-and-dice these using color and small multiples. Now we're going to add a geographic component so we can see *where* listings of interest are located in the city. This is going to come up in a big way when we visualize the solutions of routing problems tomorrow.  

# We can get a "basemap" of Boston using the ggmap package, as in the following code: 

library(ggmap)

boston_coords <- c(left   = -71.1289, 
				   bottom = 42.3201, 
				   right  = -71.0189, 
				   top    = 42.3701)

basemap <- get_map(location = boston_coords,
				maptype = 'terrain')
ggmap(basemap)

# The ggmap with basemap is just the same as any other ggplot object, with pre-built aesthetics: lon on the x axis and lat on the y axis. Let's make a plot of all the listings in our data set: 

ggmap(basemap) + 
	geom_point(aes(x = longitude, y = latitude), 
			   data = listings, 
			   size = .5)

# Great! We've come a long way with our data science tools in R. 
# We're going to take a brief step back to talk about tools for *communicating* with analysis, before jumping into a mini-project. 

