library("dplyr")
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

  message("Scraping page ", url)
  
  site <- html(url) 
  
  team_name <- site %>%
    html_nodes(xpath="//div[@id='summary-top-content']//h2") %>%
    html_text()
  team_name <- gsub(" Fundraising Page", "", team_name)
  
  target <- site %>% 
    html_nodes(xpath="//div//p//em") %>%
    extract2(1) %>%
    html_text()
  target <- unlist(strsplit(target, "\\s+"))[4]
  
  sum_raised <- site %>%
    html_nodes(xpath="//div//p//span[@class='raised-so-far']") %>%
    html_text()
  
  perc_raised <- site %>% 
    html_nodes(xpath="//div//strong//em") %>%
    extract2(1) %>%
    html_text()
  
  n_donations <- site %>%
    html_nodes(xpath="//div//p//span[@class='number-of-donations']") %>%
    html_text() %>%
    as.numeric()
  
  dat <- data.frame(team_name=team_name, target=target, sum_raised=sum_raised, 
                    perc_raised=perc_raised, n_donations=n_donations, 
                    stringsAsFactors=FALSE)
  
  return(dat)
}

donations_data <- lapply(urls, scrape_data)
donations_data <- bind_rows(donations_data)
