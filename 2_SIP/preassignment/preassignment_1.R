install.packages(c('tidytext', 'randomForest', 'yardstick', 'janeaustenr','knitr','leaflet', 'cld3','modelr', 'kernlab', 'ggmap')) 

library(tidyverse)
library(tidytext)
library(yardstick)
library(janeaustenr)
library(kernlab)

#' what does this code do? 
austen_books() %>% 
	unnest_tokens(word, text) %>% 
	group_by(word) %>% 
	summarise(n = n()) %>% 
	arrange(desc(n))

#' What about this? 

data_frame(
	x = runif(100, 0, 1),
	y = runif(100, 0, 1)
) %>% 
	mutate(cluster = c(specc(as.matrix(.), 5))) %>% 
	ggplot() + 
	aes(x = x, y = y, color = factor(cluster)) + 
	geom_point() + 
	theme_minimal()