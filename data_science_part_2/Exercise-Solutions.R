# Exercise 1: Data Types
list(2 * c(1:50), 2 * c(1:50) - 1)








# Exercise 2: Strings
reviews$comments[grepl("bed bugs", reviews$comments, ignore.case = T)][1:5]












# Exercise 3: Control Flow
numUnique <- function(x) {
  return(length(unique(x)))
}
sapply(reviews, numUnique)












# Exercise 4: Tidyverse
reviewsWithScores <- reviews %>%
  select(listing_id, comments) %>%
  group_by(listing_id) %>%
  summarize(comments = paste(comments, collapse = " ")) %>%
  ungroup() %>%
  left_join(listingsSub, by = c("listing_id" = "id")) %>%
  select(listing_id, review_scores_rating,
         review_scores_category, comments)