install.packages(c('tidytext', 'randomForest', 'yardstick', 'janeaustenr')) 

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







