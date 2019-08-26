
# ----------------------------------------------
# INTRODUCTION
# ----------------------------------------------
# In this section, we'll load our key library, read in the data, and take a look at it. 
# First, let's check that R knows where to look for files. Navigate to 
# Session -> Set Working Directory -> Source File Location

# load the tidyverse library


# load the data we'll use today


# Inspect the data


# Use head() to look at just the first rows


# Use colnames() to get the names of the columns


# Use glimpse() to get a structured overview of the data


# Let's try to compute the mean of the prices. What happens? What's the problem? 


# I'm going to do just a little bit of data cleaning for you. 
# There are a few columns in each data set that should be prices (i.e. numbers) but R will read them as strings. 
# The below three lines fix that. 

# Load in a custom R  file. By the end of today you'll be able to understand most  of it. 
      

# Apply the "clean_prices" custom function to each data set. 


# Now let's check again 


# Good to go! 

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

# arrange() to sort in descending order by rating        

# Select only the columns we want to see               


# Problem: this code wastes:
# 1. **Headspace** to think of names for the intermediate steps ("jp_only", "jp_sorted") that we don't 
# actually care about. 
# 2. **Writing time** to type those names and include them in the function calls.
# 3. **Computer memory** to store the intermediate steps. This doesn't matter 
# so much now, but for larger data sets this will rapidly become a problem. 

# Let's see if we can address these problems using nested syntax instead. 
# Nested syntax refers to simply writing function calls inside other functions. 



# Ok, that's no longer wasteful, but it's also illegible -- hard to write, hard to troubleshoot. What to do? Back to the slides to discuss the pipe

# -----------------------------------------------------
# EXERCISE 1: The Pipe
# -----------------------------------------------------

# Working with your partner, please rewrite the JP code using the pipe operator. Here's the first line to get you started:



# ----------------------------------------------
# SOLUTION
# ----------------------------------------------


# -----------------------------------------------------
# EXERCISE 2: The Biggest Place in Back Bay
# -----------------------------------------------------

# You are going to spend a long weekend in Back Bay with 59 of your closest friends.

# Working with your partner, modify your code slightly to construct a table of the listings in Back Bay.
# Sort the results in descending order by the number of people who can stay there, and in ascending order by price, displaying both columns. 
# Display the price column as well. You may need to use `glimpse` to see which columns you'll want to use. 

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------


# -----------------------------------------------------------------
# Exploratory Data Analysis
# -----------------------------------------------------------------

# What's the average price per person to stay at an AirBnB in Boston? Let's see how to construct a simple summary table in which we'll display the average rating and price-per-guest by neighborhood. We can use the accommodates field as a simple estimate of how many people can fit in a listing. 


# Next, let's summarise() the results by computing the average: 


# We can actually compute multiple summary statistics simultaneously. Maybe we want the total number of listings and the mean rating as well. We can actually just pack them into the same summarise() call:  	


# Oops! We got an NA for the mean_rating. We can fix that by adding an na.rm = TRUE parameter to mean_rating, which simply says to omit missing values from the computation. 


# This appears to have worked, but isn't tremendously useful. We usually want to slice and dice our data by values of different variables. We can do that by adding in the group_by() function to our pipeline. We'll group_by(neighbourhood) here. 

	
# Note that, when we group_by() and then summarise(), we get a new column giving the group label -- in this case, the neighborhood. 

# -----------------------------------------------------
# EXERCISE 3: Summarising Data
# -----------------------------------------------------

# Modify the summary table above as follows: 
# 
# 1. Group by property_type as well as neighborhood. How does this impact the output?
# 2. Add a new column to the table with the average rate per person for WEEKLY rentals, using the weekly_price column. 
# 3. Add a new column giving the total "capacity" for each neighborhood, given as the total number of people who can be accomodated by in rentals in that neighborhood. 
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

# Suppose we're planning a trip for September. We'd like to check what listings have availability during September. This information isn't contained in the listings table, but it is contained in the calendar table: 



# How can we connect this information to the listings table in order to learn more about what spots are available in September? 

# -----------------------------------------------------
# EXERCISE 5: September Availability
# -----------------------------------------------------

# Construct a table with two columns. The first column should give the listing_id of the listing. The second column should be called nights_available and give the total number of nights of availability in the month of September. Finally, filter the result so that the table only contains listings with at least one available night in September. You will probably want to use mutate(), filter(), group_by(), and summarise(). 
# HINT: you might also find it useful to see what the following command returns: 

# month("2019-09-03", label = TRUE)

# ----------------------------------------------
# SOLUTION
# ----------------------------------------------






# Our next task is to *join* the september_availability table to the listings table. There are many ways to do this, and we're not going to go through all of them today. We will do a left join, which preserves all rows of listings. We need to provide a correspondence between columns of the two tables. 



# Let's take a look at the new column we've created:




# What does the NA mean?
# Let's filter it out



# How many listings have any availability in September?

# If you've made it this far, great job! Next up: visualization. 

# -----------------------------------------------------------------
# GETTING VISUAL
# -----------------------------------------------------------------

# Now that we've seen a bit of the theory behind visualization in R, let's get our hands dirty. 

# Let's start with a simple histogram of the review scores. We'll build up this plot line by line. 




# How about a bar chart?




# Ok, well that looks kind of gross. When you have a bar chart and it's gross, you should usually consider flipping the axes, sorting the data, or both: 




# Next, let's do a simple scatter plot of the number of reviews vs. review score. We'll again build up this plot line by line. 




# what does the warning mean?

# -----------------------------------------------------
# EXERCISE 6: TRENDS OVER TIME
# -----------------------------------------------------

# First, inspect the calendar table to get a reminder for what fields are available. Compute a table with two columns: a date and an average price per day. Finally, make a line chart using geom_line() to visualize the average trend, with date on the x-axis and mean price on the y-axis. 
	
# ----------------------------------------------
# SOLUTION
# ----------------------------------------------



# Notice anything interesting? We'll come back to this in October...

# We don't usually just want to look at one set of bars or time-series -- we want to make comparisons. The two most common ways to make comparisons in plots are colors and small multiples. Let's grab that scatterplot we made earlier: 




# This is ok, but it's kind of hard to read because there are so many property types. 

# -----------------------------------------------------
# EXERCISE 7: I'M ON A BOAT?
# -----------------------------------------------------

# Modify this scatter plot so that all points are the same color, EXCEPT for points for which property_type == "Boat".

# -----------------------------------------------------
# SOLUTION
# -----------------------------------------------------



# This is technically correct, but it's not that useful because I can't actually see any of the boat listings. We can fix this using small multiples -- we'll separate out the boats into their own, separate plot. 





# -----------------------------------------------------
# EXERCISE 8: PRICE OF BOAT STAYS OVER TIME
# -----------------------------------------------------

# When is the best time to stay on a boat? Does it even matter? Create a version of the price-over-time plot that you did in Exercise 6 to answer this question. There should be one trendline for the price per night to stay in a boat, and another trendline for other property types. This exercise will call on multiple skills we've learned so far. In addition to modifying the code given to you in Exercise 6, you'll probably need to use a left-join as well. 




	
# We've covered some of the most important types of plots -- histograms, bar charts, line plots, and scatterplots, as well as ways to slice-and-dice these using color and small multiples. Now we're going to add a geographic component so we can see *where* listings of interest are located in the city.

# We can get a "basemap" of Boston using the ggmap package, as in the following code: 




# The ggmap with basemap is just the same as any other ggplot object, with pre-built aesthetics: lon on the x axis and lat on the y axis. Let's make a plot of all the listings in our data set: 




# Great! We've come a long way with our data science tools in R. 
# We're going to take a brief step back to talk about tools for *communicating* with analysis, before jumping into a mini-project. 

