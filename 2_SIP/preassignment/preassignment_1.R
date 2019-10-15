install.packages(c('tidytext', 'randomForest', 'yardstick', 'janeaustenr','knitr','leaflet')) 

library(tidyverse)
library(tidytext)
library(yardstick)
library(janeaustenr)

# what does this code do? 
austen_books() %>% 
	unnest_tokens(word, text) %>% 
	group_by(word) %>% 
	summarise(n = n()) %>% 
	arrange(desc(n))

# what about this? 

library(leaflet)

m <- leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12)
m %>% addTiles()









