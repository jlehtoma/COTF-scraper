library("magrittr")
library("rvest")

tarp_site <- html("https://www.justgiving.com/COTF2015AR/") 

perc_raised <- tarp_site %>% 
  html_nodes(xpath="//div//strong//em") %>%
  extract2(1) %>%
  html_text()

sum_raised <- tarp_site %>%
  html_nodes(xpath="//div//p//span[@class='raised-so-far']") %>%
  html_text()

target <- tarp_site %>% 
  html_nodes(xpath="//div//p//em") %>%
  extract2(1) %>%
  html_text()

n_donations <- tarp_site %>%
  html_nodes(xpath="//div//p//span[@class='number-of-donations']") %>%
  html_text() %>%
  as.numeric()
