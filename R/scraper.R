library("magrittr")
library("rvest")

urls <- c("https://www.justgiving.com/COTF2015BLI/",
          "https://www.justgiving.com/COTF2015NGB/",
          "https://www.justgiving.com/COTF-birding-ecotours/",
          "https://www.justgiving.com/COTF2015BBR",
          "https://www.justgiving.com/COTF2015AR",
          "https://www.justgiving.com/COTF2015TNL/",
          "https://www.justgiving.com/COTFRB")

scrape_data <- function(url) {

  site <- html(url) 
  
  target <- site %>% 
    html_nodes(xpath="//div//p//em") %>%
    extract2(1) %>%
    html_text()
  target <- unlist(strsplit(target, "\\s+"))[4]
  
  perc_raised <- site %>% 
    html_nodes(xpath="//div//strong//em") %>%
    extract2(1) %>%
    html_text()
  
  sum_raised <- site %>%
    html_nodes(xpath="//div//p//span[@class='raised-so-far']") %>%
    html_text()
  
  n_donations <- site %>%
    html_nodes(xpath="//div//p//span[@class='number-of-donations']") %>%
    html_text() %>%
    as.numeric()
  
  dat <- data.frame(perc_raised=perc_raised, )
  
  return(target=target, )
}
