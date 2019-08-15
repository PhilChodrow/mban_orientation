Data Preparation and Exploration
================
Phil Chodrow
8/15/2017

# The Case

AirBnB is a well-known website that allows hosts to rent their homes on
a short-term basis to travelers. The company does its best business in
cities with large tourism industries, including Boston. While many
people become AirBnB hosts through word-of-mouth, the company also has
an advertising budget that it can deploy to recruit more hosts in
specific areas. AirBnB has asked you, a data analytics consultant, to
help them identify neighborhoods in Boston where they should focus their
recruitment efforts. They have made available to you a complex,
multi-part data set that you can use to answer this question.

# What You’ll Learn

In most real-world applications, the first steps to addressing a complex
problem are to construct summary statistics and exploratory
visualizations. These are the tasks on which we’ll focus today.
Specifically, we’ll learn how to:

1.  Import a data set
2.  Clean and subset the data
3.  Relate multiple data tables
4.  Compute summary statistics
5.  Visualize key metrics

By the end of the session, you’ll use these skills to construct a simple
dashboard for AirBnB decision-makers.

# Diving in

First, we’ll need the `tidyverse` packages.

``` r
library(tidyverse)
```

Now let’s read in our two data sets. The tidyverse provides the
`read_csv` function for easily importing data sets in `.csv` format.
Functions like `read_tsv`, `read_table`, and `read_delim` will read in
alternative formats.

``` r
listings <- read_csv('../data/listings.csv')
calendar <- read_csv('../data/calendar.csv')
```

# Look Around, Look Around…

The first thing you should do when you access a new data set is look
around to get an overview of its structure. One easy way to do this is
to just type the name of the data set into the console.

``` r
listings
```

    ## # A tibble: 3,585 x 95
    ##        id listing_url scrape_id last_scraped name  summary space
    ##     <dbl> <chr>           <dbl> <date>       <chr> <chr>   <chr>
    ##  1 1.21e7 https://ww…   2.02e13 2016-09-07   Sunn… Cozy, … The …
    ##  2 3.08e6 https://ww…   2.02e13 2016-09-07   Char… Charmi… Smal…
    ##  3 6.98e3 https://ww…   2.02e13 2016-09-07   Mexi… Come s… "Com…
    ##  4 1.44e6 https://ww…   2.02e13 2016-09-07   Spac… Come e… Most…
    ##  5 7.65e6 https://ww…   2.02e13 2016-09-07   Come… My com… Clea…
    ##  6 1.24e7 https://ww…   2.02e13 2016-09-07   Priv… Super … Our …
    ##  7 5.71e6 https://ww…   2.02e13 2016-09-07   New … "It's … The …
    ##  8 2.84e6 https://ww…   2.02e13 2016-09-07   "\"T… We can… "We …
    ##  9 7.53e5 https://ww…   2.02e13 2016-09-07   6 mi… Nice a… Nice…
    ## 10 8.49e5 https://ww…   2.02e13 2016-09-07   Perf… "This … Perf…
    ## # … with 3,575 more rows, and 88 more variables: description <chr>,
    ## #   experiences_offered <chr>, neighborhood_overview <chr>, notes <chr>,
    ## #   transit <chr>, access <chr>, interaction <chr>, house_rules <chr>,
    ## #   thumbnail_url <chr>, medium_url <chr>, picture_url <chr>,
    ## #   xl_picture_url <chr>, host_id <dbl>, host_url <chr>, host_name <chr>,
    ## #   host_since <date>, host_location <chr>, host_about <chr>,
    ## #   host_response_time <chr>, host_response_rate <chr>,
    ## #   host_acceptance_rate <chr>, host_is_superhost <lgl>,
    ## #   host_thumbnail_url <chr>, host_picture_url <chr>,
    ## #   host_neighbourhood <chr>, host_listings_count <dbl>,
    ## #   host_total_listings_count <dbl>, host_verifications <chr>,
    ## #   host_has_profile_pic <lgl>, host_identity_verified <lgl>,
    ## #   street <chr>, neighbourhood <chr>, neighbourhood_cleansed <chr>,
    ## #   neighbourhood_group_cleansed <lgl>, city <chr>, state <chr>,
    ## #   zipcode <chr>, market <chr>, smart_location <chr>, country_code <chr>,
    ## #   country <chr>, latitude <dbl>, longitude <dbl>,
    ## #   is_location_exact <lgl>, property_type <chr>, room_type <chr>,
    ## #   accommodates <dbl>, bathrooms <dbl>, bedrooms <dbl>, beds <dbl>,
    ## #   bed_type <chr>, amenities <chr>, square_feet <dbl>, price <chr>,
    ## #   weekly_price <chr>, monthly_price <chr>, security_deposit <chr>,
    ## #   cleaning_fee <chr>, guests_included <dbl>, extra_people <chr>,
    ## #   minimum_nights <dbl>, maximum_nights <dbl>, calendar_updated <chr>,
    ## #   has_availability <lgl>, availability_30 <dbl>, availability_60 <dbl>,
    ## #   availability_90 <dbl>, availability_365 <dbl>,
    ## #   calendar_last_scraped <date>, number_of_reviews <dbl>,
    ## #   first_review <date>, last_review <date>, review_scores_rating <dbl>,
    ## #   review_scores_accuracy <dbl>, review_scores_cleanliness <dbl>,
    ## #   review_scores_checkin <dbl>, review_scores_communication <dbl>,
    ## #   review_scores_location <dbl>, review_scores_value <dbl>,
    ## #   requires_license <lgl>, license <lgl>, jurisdiction_names <lgl>,
    ## #   instant_bookable <lgl>, cancellation_policy <chr>,
    ## #   require_guest_profile_picture <lgl>,
    ## #   require_guest_phone_verification <lgl>,
    ## #   calculated_host_listings_count <dbl>, reviews_per_month <dbl>

We’ve learned that our data set is a `tibble` (also called a “data
frame”) with 3585 rows and 95 columns. Most of the columns are either
`int` (integers), `dbl` (decimal numbers), or `chr` (character strings).
There are a few columns with the more specialized `date` data type.

This much info can be a bit overwhelming. You can query specific aspects
of the data using some of the commands below:

``` r
head(listings) # just the first few rows
```

    ## # A tibble: 6 x 95
    ##       id listing_url scrape_id last_scraped name  summary space description
    ##    <dbl> <chr>           <dbl> <date>       <chr> <chr>   <chr> <chr>      
    ## 1 1.21e7 https://ww…   2.02e13 2016-09-07   Sunn… Cozy, … The … Cozy, sunn…
    ## 2 3.08e6 https://ww…   2.02e13 2016-09-07   Char… Charmi… Smal… Charming a…
    ## 3 6.98e3 https://ww…   2.02e13 2016-09-07   Mexi… Come s… "Com… "Come stay…
    ## 4 1.44e6 https://ww…   2.02e13 2016-09-07   Spac… Come e… Most… Come exper…
    ## 5 7.65e6 https://ww…   2.02e13 2016-09-07   Come… My com… Clea… "My comfy,…
    ## 6 1.24e7 https://ww…   2.02e13 2016-09-07   Priv… Super … Our … Super comf…
    ## # … with 87 more variables: experiences_offered <chr>,
    ## #   neighborhood_overview <chr>, notes <chr>, transit <chr>, access <chr>,
    ## #   interaction <chr>, house_rules <chr>, thumbnail_url <chr>,
    ## #   medium_url <chr>, picture_url <chr>, xl_picture_url <chr>,
    ## #   host_id <dbl>, host_url <chr>, host_name <chr>, host_since <date>,
    ## #   host_location <chr>, host_about <chr>, host_response_time <chr>,
    ## #   host_response_rate <chr>, host_acceptance_rate <chr>,
    ## #   host_is_superhost <lgl>, host_thumbnail_url <chr>,
    ## #   host_picture_url <chr>, host_neighbourhood <chr>,
    ## #   host_listings_count <dbl>, host_total_listings_count <dbl>,
    ## #   host_verifications <chr>, host_has_profile_pic <lgl>,
    ## #   host_identity_verified <lgl>, street <chr>, neighbourhood <chr>,
    ## #   neighbourhood_cleansed <chr>, neighbourhood_group_cleansed <lgl>,
    ## #   city <chr>, state <chr>, zipcode <chr>, market <chr>,
    ## #   smart_location <chr>, country_code <chr>, country <chr>,
    ## #   latitude <dbl>, longitude <dbl>, is_location_exact <lgl>,
    ## #   property_type <chr>, room_type <chr>, accommodates <dbl>,
    ## #   bathrooms <dbl>, bedrooms <dbl>, beds <dbl>, bed_type <chr>,
    ## #   amenities <chr>, square_feet <dbl>, price <chr>, weekly_price <chr>,
    ## #   monthly_price <chr>, security_deposit <chr>, cleaning_fee <chr>,
    ## #   guests_included <dbl>, extra_people <chr>, minimum_nights <dbl>,
    ## #   maximum_nights <dbl>, calendar_updated <chr>, has_availability <lgl>,
    ## #   availability_30 <dbl>, availability_60 <dbl>, availability_90 <dbl>,
    ## #   availability_365 <dbl>, calendar_last_scraped <date>,
    ## #   number_of_reviews <dbl>, first_review <date>, last_review <date>,
    ## #   review_scores_rating <dbl>, review_scores_accuracy <dbl>,
    ## #   review_scores_cleanliness <dbl>, review_scores_checkin <dbl>,
    ## #   review_scores_communication <dbl>, review_scores_location <dbl>,
    ## #   review_scores_value <dbl>, requires_license <lgl>, license <lgl>,
    ## #   jurisdiction_names <lgl>, instant_bookable <lgl>,
    ## #   cancellation_policy <chr>, require_guest_profile_picture <lgl>,
    ## #   require_guest_phone_verification <lgl>,
    ## #   calculated_host_listings_count <dbl>, reviews_per_month <dbl>

``` r
colnames(listings) # just the names of the columns
```

    ##  [1] "id"                               "listing_url"                     
    ##  [3] "scrape_id"                        "last_scraped"                    
    ##  [5] "name"                             "summary"                         
    ##  [7] "space"                            "description"                     
    ##  [9] "experiences_offered"              "neighborhood_overview"           
    ## [11] "notes"                            "transit"                         
    ## [13] "access"                           "interaction"                     
    ## [15] "house_rules"                      "thumbnail_url"                   
    ## [17] "medium_url"                       "picture_url"                     
    ## [19] "xl_picture_url"                   "host_id"                         
    ## [21] "host_url"                         "host_name"                       
    ## [23] "host_since"                       "host_location"                   
    ## [25] "host_about"                       "host_response_time"              
    ## [27] "host_response_rate"               "host_acceptance_rate"            
    ## [29] "host_is_superhost"                "host_thumbnail_url"              
    ## [31] "host_picture_url"                 "host_neighbourhood"              
    ## [33] "host_listings_count"              "host_total_listings_count"       
    ## [35] "host_verifications"               "host_has_profile_pic"            
    ## [37] "host_identity_verified"           "street"                          
    ## [39] "neighbourhood"                    "neighbourhood_cleansed"          
    ## [41] "neighbourhood_group_cleansed"     "city"                            
    ## [43] "state"                            "zipcode"                         
    ## [45] "market"                           "smart_location"                  
    ## [47] "country_code"                     "country"                         
    ## [49] "latitude"                         "longitude"                       
    ## [51] "is_location_exact"                "property_type"                   
    ## [53] "room_type"                        "accommodates"                    
    ## [55] "bathrooms"                        "bedrooms"                        
    ## [57] "beds"                             "bed_type"                        
    ## [59] "amenities"                        "square_feet"                     
    ## [61] "price"                            "weekly_price"                    
    ## [63] "monthly_price"                    "security_deposit"                
    ## [65] "cleaning_fee"                     "guests_included"                 
    ## [67] "extra_people"                     "minimum_nights"                  
    ## [69] "maximum_nights"                   "calendar_updated"                
    ## [71] "has_availability"                 "availability_30"                 
    ## [73] "availability_60"                  "availability_90"                 
    ## [75] "availability_365"                 "calendar_last_scraped"           
    ## [77] "number_of_reviews"                "first_review"                    
    ## [79] "last_review"                      "review_scores_rating"            
    ## [81] "review_scores_accuracy"           "review_scores_cleanliness"       
    ## [83] "review_scores_checkin"            "review_scores_communication"     
    ## [85] "review_scores_location"           "review_scores_value"             
    ## [87] "requires_license"                 "license"                         
    ## [89] "jurisdiction_names"               "instant_bookable"                
    ## [91] "cancellation_policy"              "require_guest_profile_picture"   
    ## [93] "require_guest_phone_verification" "calculated_host_listings_count"  
    ## [95] "reviews_per_month"

Arguably the most useful function for peaking at your data is `glimpse`.

``` r
glimpse(listings)
```

    ## Observations: 3,585
    ## Variables: 95
    ## $ id                               <dbl> 12147973, 3075044, 6976, 143651…
    ## $ listing_url                      <chr> "https://www.airbnb.com/rooms/1…
    ## $ scrape_id                        <dbl> 2.016091e+13, 2.016091e+13, 2.0…
    ## $ last_scraped                     <date> 2016-09-07, 2016-09-07, 2016-0…
    ## $ name                             <chr> "Sunny Bungalow in the City", "…
    ## $ summary                          <chr> "Cozy, sunny, family home.  Mas…
    ## $ space                            <chr> "The house has an open and cozy…
    ## $ description                      <chr> "Cozy, sunny, family home.  Mas…
    ## $ experiences_offered              <chr> "none", "none", "none", "none",…
    ## $ neighborhood_overview            <chr> "Roslindale is quiet, convenien…
    ## $ notes                            <chr> NA, "If you don't have a US cel…
    ## $ transit                          <chr> "The bus stop is 2 blocks away,…
    ## $ access                           <chr> "You will have access to 2 bedr…
    ## $ interaction                      <chr> NA, "If I am at home, I am like…
    ## $ house_rules                      <chr> "Clean up and treat the home th…
    ## $ thumbnail_url                    <chr> "https://a2.muscache.com/im/pic…
    ## $ medium_url                       <chr> "https://a2.muscache.com/im/pic…
    ## $ picture_url                      <chr> "https://a2.muscache.com/im/pic…
    ## $ xl_picture_url                   <chr> "https://a2.muscache.com/im/pic…
    ## $ host_id                          <dbl> 31303940, 2572247, 16701, 60314…
    ## $ host_url                         <chr> "https://www.airbnb.com/users/s…
    ## $ host_name                        <chr> "Virginia", "Andrea", "Phil", "…
    ## $ host_since                       <date> 2015-04-15, 2012-06-07, 2009-0…
    ## $ host_location                    <chr> "Boston, Massachusetts, United …
    ## $ host_about                       <chr> "We are country and city connec…
    ## $ host_response_time               <chr> "N/A", "within an hour", "withi…
    ## $ host_response_rate               <chr> "N/A", "100%", "100%", "100%", …
    ## $ host_acceptance_rate             <chr> "N/A", "100%", "88%", "50%", "1…
    ## $ host_is_superhost                <lgl> FALSE, FALSE, TRUE, FALSE, TRUE…
    ## $ host_thumbnail_url               <chr> "https://a2.muscache.com/im/pic…
    ## $ host_picture_url                 <chr> "https://a2.muscache.com/im/pic…
    ## $ host_neighbourhood               <chr> "Roslindale", "Roslindale", "Ro…
    ## $ host_listings_count              <dbl> 1, 1, 1, 1, 1, 2, 5, 2, 1, 2, 1…
    ## $ host_total_listings_count        <dbl> 1, 1, 1, 1, 1, 2, 5, 2, 1, 2, 1…
    ## $ host_verifications               <chr> "['email', 'phone', 'facebook',…
    ## $ host_has_profile_pic             <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, T…
    ## $ host_identity_verified           <lgl> FALSE, TRUE, TRUE, FALSE, TRUE,…
    ## $ street                           <chr> "Birch Street, Boston, MA 02131…
    ## $ neighbourhood                    <chr> "Roslindale", "Roslindale", "Ro…
    ## $ neighbourhood_cleansed           <chr> "Roslindale", "Roslindale", "Ro…
    ## $ neighbourhood_group_cleansed     <lgl> NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ city                             <chr> "Boston", "Boston", "Boston", "…
    ## $ state                            <chr> "MA", "MA", "MA", "MA", "MA", "…
    ## $ zipcode                          <chr> "02131", "02131", "02131", NA, …
    ## $ market                           <chr> "Boston", "Boston", "Boston", "…
    ## $ smart_location                   <chr> "Boston, MA", "Boston, MA", "Bo…
    ## $ country_code                     <chr> "US", "US", "US", "US", "US", "…
    ## $ country                          <chr> "United States", "United States…
    ## $ latitude                         <dbl> 42.28262, 42.28624, 42.29244, 4…
    ## $ longitude                        <dbl> -71.13307, -71.13437, -71.13577…
    ## $ is_location_exact                <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, …
    ## $ property_type                    <chr> "House", "Apartment", "Apartmen…
    ## $ room_type                        <chr> "Entire home/apt", "Private roo…
    ## $ accommodates                     <dbl> 4, 2, 2, 4, 2, 2, 3, 2, 2, 5, 2…
    ## $ bathrooms                        <dbl> 1.5, 1.0, 1.0, 1.0, 1.5, 1.0, 1…
    ## $ bedrooms                         <dbl> 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1…
    ## $ beds                             <dbl> 3, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1…
    ## $ bed_type                         <chr> "Real Bed", "Real Bed", "Real B…
    ## $ amenities                        <chr> "{TV,\"Wireless Internet\",Kitc…
    ## $ square_feet                      <dbl> NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ price                            <chr> "$250.00", "$65.00", "$65.00", …
    ## $ weekly_price                     <chr> NA, "$400.00", "$395.00", NA, N…
    ## $ monthly_price                    <chr> NA, NA, "$1,350.00", NA, NA, NA…
    ## $ security_deposit                 <chr> NA, "$95.00", NA, "$100.00", NA…
    ## $ cleaning_fee                     <chr> "$35.00", "$10.00", NA, "$50.00…
    ## $ guests_included                  <dbl> 1, 0, 1, 2, 1, 1, 1, 1, 2, 4, 1…
    ## $ extra_people                     <chr> "$0.00", "$0.00", "$20.00", "$2…
    ## $ minimum_nights                   <dbl> 2, 2, 3, 1, 2, 2, 1, 1, 2, 4, 1…
    ## $ maximum_nights                   <dbl> 1125, 15, 45, 1125, 31, 1125, 1…
    ## $ calendar_updated                 <chr> "2 weeks ago", "a week ago", "5…
    ## $ has_availability                 <lgl> NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ availability_30                  <dbl> 0, 26, 19, 6, 13, 5, 22, 30, 12…
    ## $ availability_60                  <dbl> 0, 54, 46, 16, 34, 28, 39, 60, …
    ## $ availability_90                  <dbl> 0, 84, 61, 26, 59, 58, 69, 90, …
    ## $ availability_365                 <dbl> 0, 359, 319, 98, 334, 58, 344, …
    ## $ calendar_last_scraped            <date> 2016-09-06, 2016-09-06, 2016-0…
    ## $ number_of_reviews                <dbl> 0, 36, 41, 1, 29, 8, 57, 67, 65…
    ## $ first_review                     <date> NA, 2014-06-01, 2009-07-19, 20…
    ## $ last_review                      <date> NA, 2016-08-13, 2016-08-05, 20…
    ## $ review_scores_rating             <dbl> NA, 94, 98, 100, 99, 100, 90, 9…
    ## $ review_scores_accuracy           <dbl> NA, 10, 10, 10, 10, 10, 10, 10,…
    ## $ review_scores_cleanliness        <dbl> NA, 9, 9, 10, 10, 10, 10, 10, 1…
    ## $ review_scores_checkin            <dbl> NA, 10, 10, 10, 10, 10, 10, 10,…
    ## $ review_scores_communication      <dbl> NA, 10, 10, 10, 10, 10, 10, 10,…
    ## $ review_scores_location           <dbl> NA, 9, 9, 10, 9, 9, 9, 10, 9, 9…
    ## $ review_scores_value              <dbl> NA, 9, 10, 10, 10, 10, 9, 10, 1…
    ## $ requires_license                 <lgl> FALSE, FALSE, FALSE, FALSE, FAL…
    ## $ license                          <lgl> NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ jurisdiction_names               <lgl> NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ instant_bookable                 <lgl> FALSE, TRUE, FALSE, FALSE, FALS…
    ## $ cancellation_policy              <chr> "moderate", "moderate", "modera…
    ## $ require_guest_profile_picture    <lgl> FALSE, FALSE, TRUE, FALSE, FALS…
    ## $ require_guest_phone_verification <lgl> FALSE, FALSE, FALSE, FALSE, FAL…
    ## $ calculated_host_listings_count   <dbl> 1, 1, 1, 1, 1, 1, 3, 2, 1, 2, 1…
    ## $ reviews_per_month                <dbl> NA, 1.30, 0.47, 1.00, 2.25, 1.7…

We get a more readable view of the data, including row and column
counts, column types, and the first few entries of each column.

# Warm-Up: The Nicest Spots in JP

Now let’s start digging into our data. You have been asked to provide a
simple quantitative answer to the following question: \> What are the
“best” listings in Jamaica Plain?

For any data scientific question, there are usually many good ways to
answer it. This time, our approach will be to construct a list of all
listings in Jamaica Plain, sorted in descending order by rating. To do
this, we’ll need to:

1.  `Filter` out all listings that aren’t in Jamacia Plain.
2.  `Arrange` the rows of the resulting data frame in descending order
    by rating.
3.  `Select` a small number of columns so that we don’t display
    irrelevant ones.

Let’s go ahead and do this. We’ll start out with a simple but slightly
clunky way, and then see how to dramatically simplify it using some
syntactical magic.

``` r
jp_only <- filter(listings, neighbourhood == 'Jamaica Plain')        # logical test
sorted  <- arrange(jp_only, desc(review_scores_rating))              # desc for descending order
concise <- select(sorted, neighbourhood, name, review_scores_rating) # show only these three columns
concise
```

    ## # A tibble: 314 x 3
    ##    neighbourhood name                                review_scores_rating
    ##    <chr>         <chr>                                              <dbl>
    ##  1 Jamaica Plain Part of a Large Condo Jamaica Plain                  100
    ##  2 Jamaica Plain Bed, Bath and Beyond III in JP                       100
    ##  3 Jamaica Plain Private floor in Jamaica Plain home                  100
    ##  4 Jamaica Plain Beautiful, airy room in JP                           100
    ##  5 Jamaica Plain Mark P.Coleman                                       100
    ##  6 Jamaica Plain Room in beautiful JP home                            100
    ##  7 Jamaica Plain Stay in Boston's best neighborhood!                  100
    ##  8 Jamaica Plain Tranquil Treetop Loft                                100
    ##  9 Jamaica Plain Private Room in Urban DIY House                      100
    ## 10 Jamaica Plain Sunny, Cozy and Convenient JP Home!                  100
    ## # … with 304 more rows

The steps here are easy to understand – you don’t need to know much
about `R` or even programming in order to keep up with what’s going on
here. A few notes:

1.  The first argument of each function is the data on which we want to
    operate; this is part of the `tidyverse` design philosophy. We’ll
    see why this matters in a moment.
2.  `filter` requires a logical test, for which `R` uses operators like
    `==`, `>=`, and `%in%` to check for membership.
3.  `filter` operates on rows, `select` operates on columns.
4.  `arrange` by default will sort in ascending order, so use `desc` if
    you need it.
5.  Due to the magic of so-called “nonstandard evaluation,” you should
    use **unquoted** column names in pipelines like these. That is,
    `select(listings, "neighbourhood")` is **wrong**: `select(listings,
    neighbourhood)` is correct.

## C’est Neci Pas…

![](https://upload.wikimedia.org/wikipedia/en/b/b9/MagrittePipe.jpg)

The code we wrote above was nice and easy to understand, but it was also
a bit wasteful. It wastes:

1.  **Headspace** to think of names for the intermediate steps that we
    don’t actually care about.
2.  **Writing time** to write those names and include them in the
    function calls.
3.  **Computer memory** to store the intermediate steps. This doesn’t
    matter so much now, but for larger data sets this will rapidly
    become a problem.

We could actually address all these problems using nested syntax
instead. We just put the results of each function inside the next one,
working inside out.

``` r
select(arrange(filter(listings, neighbourhood == 'Jamaica Plain'), desc(review_scores_rating)), neighbourhood, name, review_scores_rating)
```

    ## # A tibble: 314 x 3
    ##    neighbourhood name                                review_scores_rating
    ##    <chr>         <chr>                                              <dbl>
    ##  1 Jamaica Plain Part of a Large Condo Jamaica Plain                  100
    ##  2 Jamaica Plain Bed, Bath and Beyond III in JP                       100
    ##  3 Jamaica Plain Private floor in Jamaica Plain home                  100
    ##  4 Jamaica Plain Beautiful, airy room in JP                           100
    ##  5 Jamaica Plain Mark P.Coleman                                       100
    ##  6 Jamaica Plain Room in beautiful JP home                            100
    ##  7 Jamaica Plain Stay in Boston's best neighborhood!                  100
    ##  8 Jamaica Plain Tranquil Treetop Loft                                100
    ##  9 Jamaica Plain Private Room in Urban DIY House                      100
    ## 10 Jamaica Plain Sunny, Cozy and Convenient JP Home!                  100
    ## # … with 304 more rows

This solves the waste issue, but introduces a worse one – this code is
difficult to write and almost impossible to read. Troubleshooting this
would be a nightmare.

So, what can we do? The `tidyverse` offers a nice solution, in the form
of the “pipe” operator `%>%`. Let’s start with a simple example.

``` r
listings %>% glimpse() # equivalent to glance(listings)
```

The key point about `%>%` to remember is that it is pronounced “then.”
So, read the above as:

> Take `listings`, and **then** do `glimpse()` to it.

Generalizing this to a formal structure,

> `x %>% f()` is the same as `f(x)`.

If you are working with a function with multiple arguments, the pipe
applies to the first argument:

> `x %>% g(y)` is the same as `g(x,y)`

This example isn’t particularly impressive, but let’s see what happens
when we rewrite our Jamaica Plain code:

``` r
listings %>% 
    filter(neighbourhood == 'Jamaica Plain') %>%      # filter needs a logical test
    arrange(desc(review_scores_rating)) %>%           # desc() makes descending order 
    select(neighbourhood, name, review_scores_rating)
```

    ## # A tibble: 314 x 3
    ##    neighbourhood name                                review_scores_rating
    ##    <chr>         <chr>                                              <dbl>
    ##  1 Jamaica Plain Part of a Large Condo Jamaica Plain                  100
    ##  2 Jamaica Plain Bed, Bath and Beyond III in JP                       100
    ##  3 Jamaica Plain Private floor in Jamaica Plain home                  100
    ##  4 Jamaica Plain Beautiful, airy room in JP                           100
    ##  5 Jamaica Plain Mark P.Coleman                                       100
    ##  6 Jamaica Plain Room in beautiful JP home                            100
    ##  7 Jamaica Plain Stay in Boston's best neighborhood!                  100
    ##  8 Jamaica Plain Tranquil Treetop Loft                                100
    ##  9 Jamaica Plain Private Room in Urban DIY House                      100
    ## 10 Jamaica Plain Sunny, Cozy and Convenient JP Home!                  100
    ## # … with 304 more rows

Again, read this as:

> Take `listings`, and then `filter` it by neighbourhood, then `arrange`
> the rows, then `select` only the columns we want.

The code actually closely matches the structure of the task you want to
perform, which lets you write fast, reliable code easily. Compared to
the other two approaches, the pipe allows us to:

1.  Write less code
2.  Not bother with intermediate objects
3.  Maintain writeability and readability

Pretty good\! We’ll be using the pipe throughout our work in `R`.

# Case Study: Where Should AirBnB Expand?

So far, we’ve used functions like `glimpse` to inspect our data set, and
functions like `filter`, `arrange`, and `select` to view selected parts
of it. Now we’re going to get into more complex operations, in which
we’ll construct new data columns and summarise their properties.

## Elementary Summary Statistics

When analyzing and visualizing our data, we often want to compute
*summary statistics*: things like means, medians, sums, and counts. The
`summarize` function does just this. First let’s count the number of
rows:

``` r
listings %>%
    summarize(n = n())
```

    ## # A tibble: 1 x 1
    ##       n
    ##   <int>
    ## 1  3585

Next, let’s compute the average rating:

``` r
listings %>% 
    summarize(mean_rating = mean(review_scores_rating))
```

    ## # A tibble: 1 x 1
    ##   mean_rating
    ##         <dbl>
    ## 1          NA

Oops\! I need to tell the `mean` function to ignore missing `NA` values:

``` r
listings %>% 
    summarize(mean_rating = mean(review_scores_rating, na.rm = TRUE))
```

    ## # A tibble: 1 x 1
    ##   mean_rating
    ##         <dbl>
    ## 1        91.9

In fact, we can do both of these summary tasks at the same time:

``` r
listings %>%
    summarize(n = n(), 
              mean_rating = mean(review_scores_rating, na.rm = TRUE))
```

    ## # A tibble: 1 x 2
    ##       n mean_rating
    ##   <int>       <dbl>
    ## 1  3585        91.9

So that’s all fun, but when analyzing complex data sets, global counts
and means are almost never what we want. Instead, we usually break out
our summary statistics between different groups. To do this, we
interpolate the `group_by` command:

``` r
listings %>% 
    group_by(neighbourhood) %>% 
    summarize(n = n(), 
              mean_rating = mean(review_scores_rating, na.rm = TRUE)) 
```

    ## # A tibble: 31 x 3
    ##    neighbourhood        n mean_rating
    ##    <chr>            <int>       <dbl>
    ##  1 Allston-Brighton   364        90.1
    ##  2 Back Bay           291        91.5
    ##  3 Beacon Hill        174        93.8
    ##  4 Brookline            8       100  
    ##  5 Cambridge            7        74.5
    ##  6 Charlestown         79        94.1
    ##  7 Chestnut Hill        4        90  
    ##  8 Chinatown           78        92.4
    ##  9 Dorchester         195        89.6
    ## 10 Downtown             8        83.3
    ## # … with 21 more rows

## Construct New Columns

Let’s add another important metric to our summary. What is the average
price per person of the accomodations? To compute this, we need to make
a `price_per` column, since there’s no such column in the `listings`
data already. We do have `price` and `accomodates` columns, so this
should be easy, right?

The `mutate` function lets us make a new column and name it. For
example, the following code makes a new column giving the number of
bathrooms per guest:

``` r
listings <- listings %>% 
    mutate(bathrooms_per = bathrooms / accommodates)
```

Now let’s make that `price_per` column:

``` r
listings <- listings %>% 
    mutate(price_per = price / accommodates)
```

    ## Error in mutate_impl(.data, dots): Evaluation error: non-numeric argument to binary operator.

The error message is telling us that one of the two columns `price` and
`accommodates` are not actually numbers, so we can’t divide them. The
problem is `price`:

``` r
class(listings$price)
```

    ## [1] "character"

So, we need to convert `price` into a numberic vector. Unfortunately,
this is a bit complex, since `price` includes currency symbols:

``` r
listings$price[1:10 ]
```

    ##  [1] "$250.00" "$65.00"  "$65.00"  "$75.00"  "$79.00"  "$75.00"  "$100.00"
    ##  [8] "$75.00"  "$58.00"  "$229.00"

So, we’ll use `mutate` and a text manipulation function to achieve the
conversion:

``` r
listings %>% 
    mutate(price = as.numeric(gsub('\\$|,', '', price)),
           price_per = price / accommodates)
```

    ## # A tibble: 3,585 x 97
    ##        id listing_url scrape_id last_scraped name  summary space
    ##     <dbl> <chr>           <dbl> <date>       <chr> <chr>   <chr>
    ##  1 1.21e7 https://ww…   2.02e13 2016-09-07   Sunn… Cozy, … The …
    ##  2 3.08e6 https://ww…   2.02e13 2016-09-07   Char… Charmi… Smal…
    ##  3 6.98e3 https://ww…   2.02e13 2016-09-07   Mexi… Come s… "Com…
    ##  4 1.44e6 https://ww…   2.02e13 2016-09-07   Spac… Come e… Most…
    ##  5 7.65e6 https://ww…   2.02e13 2016-09-07   Come… My com… Clea…
    ##  6 1.24e7 https://ww…   2.02e13 2016-09-07   Priv… Super … Our …
    ##  7 5.71e6 https://ww…   2.02e13 2016-09-07   New … "It's … The …
    ##  8 2.84e6 https://ww…   2.02e13 2016-09-07   "\"T… We can… "We …
    ##  9 7.53e5 https://ww…   2.02e13 2016-09-07   6 mi… Nice a… Nice…
    ## 10 8.49e5 https://ww…   2.02e13 2016-09-07   Perf… "This … Perf…
    ## # … with 3,575 more rows, and 90 more variables: description <chr>,
    ## #   experiences_offered <chr>, neighborhood_overview <chr>, notes <chr>,
    ## #   transit <chr>, access <chr>, interaction <chr>, house_rules <chr>,
    ## #   thumbnail_url <chr>, medium_url <chr>, picture_url <chr>,
    ## #   xl_picture_url <chr>, host_id <dbl>, host_url <chr>, host_name <chr>,
    ## #   host_since <date>, host_location <chr>, host_about <chr>,
    ## #   host_response_time <chr>, host_response_rate <chr>,
    ## #   host_acceptance_rate <chr>, host_is_superhost <lgl>,
    ## #   host_thumbnail_url <chr>, host_picture_url <chr>,
    ## #   host_neighbourhood <chr>, host_listings_count <dbl>,
    ## #   host_total_listings_count <dbl>, host_verifications <chr>,
    ## #   host_has_profile_pic <lgl>, host_identity_verified <lgl>,
    ## #   street <chr>, neighbourhood <chr>, neighbourhood_cleansed <chr>,
    ## #   neighbourhood_group_cleansed <lgl>, city <chr>, state <chr>,
    ## #   zipcode <chr>, market <chr>, smart_location <chr>, country_code <chr>,
    ## #   country <chr>, latitude <dbl>, longitude <dbl>,
    ## #   is_location_exact <lgl>, property_type <chr>, room_type <chr>,
    ## #   accommodates <dbl>, bathrooms <dbl>, bedrooms <dbl>, beds <dbl>,
    ## #   bed_type <chr>, amenities <chr>, square_feet <dbl>, price <dbl>,
    ## #   weekly_price <chr>, monthly_price <chr>, security_deposit <chr>,
    ## #   cleaning_fee <chr>, guests_included <dbl>, extra_people <chr>,
    ## #   minimum_nights <dbl>, maximum_nights <dbl>, calendar_updated <chr>,
    ## #   has_availability <lgl>, availability_30 <dbl>, availability_60 <dbl>,
    ## #   availability_90 <dbl>, availability_365 <dbl>,
    ## #   calendar_last_scraped <date>, number_of_reviews <dbl>,
    ## #   first_review <date>, last_review <date>, review_scores_rating <dbl>,
    ## #   review_scores_accuracy <dbl>, review_scores_cleanliness <dbl>,
    ## #   review_scores_checkin <dbl>, review_scores_communication <dbl>,
    ## #   review_scores_location <dbl>, review_scores_value <dbl>,
    ## #   requires_license <lgl>, license <lgl>, jurisdiction_names <lgl>,
    ## #   instant_bookable <lgl>, cancellation_policy <chr>,
    ## #   require_guest_profile_picture <lgl>,
    ## #   require_guest_phone_verification <lgl>,
    ## #   calculated_host_listings_count <dbl>, reviews_per_month <dbl>,
    ## #   bathrooms_per <dbl>, price_per <dbl>

This code removes the currency symbols, converts the result into a
number, and then constructs the `price_per` column as expected. Note a
nice aspect of this – we can construct multiple columns in the same
`mutate` call. We can now summarise, just like we did before.

``` r
listings %>% 
    mutate(price = as.numeric(gsub('\\$|,', '', price)),
           price_per = price / accommodates) %>% 
    group_by(neighbourhood) %>% 
    summarize(n = n(), 
              mean_rating = mean(review_scores_rating, na.rm = TRUE),
              mean_price_per = mean(price_per, na.rm = TRUE)) 
```

    ## # A tibble: 31 x 4
    ##    neighbourhood        n mean_rating mean_price_per
    ##    <chr>            <int>       <dbl>          <dbl>
    ##  1 Allston-Brighton   364        90.1           48.7
    ##  2 Back Bay           291        91.5           81.3
    ##  3 Beacon Hill        174        93.8           86.5
    ##  4 Brookline            8       100             56.0
    ##  5 Cambridge            7        74.5           55.5
    ##  6 Charlestown         79        94.1           78.7
    ##  7 Chestnut Hill        4        90             49.5
    ##  8 Chinatown           78        92.4           65.6
    ##  9 Dorchester         195        89.6           41.6
    ## 10 Downtown             8        83.3           59.5
    ## # … with 21 more rows

## Exercise

You are now able to filter data, construct new columns, and compute
grouped summaries. Please construct a summary table, with at least three
metrics, that you would use to guide marketing executives through the
decision process. You might want to use metrics related to ratings,
prices, total accomodation capacity, or other considerations.

# Keeping Current

We’ll do this in the exercise:

``` r
current_table <- calendar %>% 
    filter(!is.na(price), 
           date < lubridate::today(),
           date > lubridate::mdy('6/1/2016')) %>%
    group_by(listing_id) %>% 
    summarise(last_active = max(date))
```

We now get a new column on the listings table, the `last_active` column.

``` r
listings <- listings %>% 
    left_join(current_table, by = c('id' = 'listing_id')) %>% 
    filter(last_active > lubridate::mdy('6/1/2016'))
```

We can make our summary table using only listings that have posted a
valid availability date in the last three months.

``` r
summary_table <- listings %>% 
    mutate(price = as.numeric(gsub('\\$|,', '', price)),
           price_per = price / accommodates) %>% 
    group_by(neighbourhood) %>% 
    summarize(n = n(), 
              mean_rating = mean(review_scores_rating, na.rm = TRUE),
              mean_price_per = mean(price_per, na.rm = TRUE)) 
```

# Visual Thinking

## Exercise

# Data Visualization

The single most important way of exploring your data is to *visualize
it*. Human beings are garbage at processing long lists of numbers, but
we are very good at seeing visual trends, even in very complex data
sets. Effective communication through data visualization rests on
*graphical excellence*, as defined by [Edward
Tufte](https://en.wikipedia.org/wiki/Edward_Tufte).

> Graphical excellence is the well-designed presentation of interesting
> data – a matter of *substance*, of *statistics*, and of *design*.

> Graphical excellence consists of complex ideas communicated with
> clarity, precision, and efficiency.

Now let’s use `ggplot2` and tidyverse principles to achieve clarity,
precision, and efficiency.

## Scatterplot

Aesthetics, changing aesthetics, e.g. throw in price and move n\_reviews
to the size

Constants (e.g. color)

## Other geoms

## Slicing and Dicing

## Reshaping Data

## Labels and Appearance

# Dashboard Mini-Project

We started out with a request from AirBnB to help them identify
neighborhoods in which they should consider focusing host-recruitment
efforts.
