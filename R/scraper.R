library("dplyr")
library("magrittr")
library("rvest")

# Define targer URLs at justgiving.com
urls <- c("https://www.justgiving.com/COTF2015BLI/",
          "https://www.justgiving.com/COTF2015NGB/",
          "https://www.justgiving.com/COTF-birding-ecotours/",
          "https://www.justgiving.com/COTF2015BBR",
          "https://www.justgiving.com/COTF2015AR",
          "https://www.justgiving.com/COTF2015TNL/",
          "https://www.justgiving.com/COTFRB",
          "https://www.justgiving.com/COTF2015TDK/",
          "https://www.justgiving.com/COTF2015BCR/",
          "https://www.justgiving.com/COTF2015IF/",
          "https://www.justgiving.com/COTF2015BV/",
          "https://www.justgiving.com/COTF2015AD/")

scrape_data <- function(url) {

  message("Scraping page ", url)
  
  # Get the overall page structure
  site <- html(url) 
  
  team_name <- site %>%
    html_nodes(xpath="//div[@id='summary-top-content']//h2") %>%
    html_text()
  # Remove unnecessary cruft
  team_name <- gsub(" Fundraising Page", "", team_name)
  
  target <- site %>% 
    html_nodes(xpath="//div//p//em") %>%
    extract2(1) %>%
    html_text()
  # Not very elegant, but get the sum based on hard coded location
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
  
  # Collate everything into a data frame
  dat <- data.frame(team_name, target, sum_raised, perc_raised, n_donations, 
                    stringsAsFactors=FALSE)
  
  return(dat)
}

# Get a list of parsed data
donations_data <- lapply(urls, scrape_data)
# Bind data frames in the list into a single data frame
donations_data <- bind_rows(donations_data)

vanha<-donations_data

library(stringr)
vanha$pros<-str_split_fixed(vanha$perc_raised, "%",2)
vanha$pros<-as.vector(vanha$pros[,1])
vanha$pros<-as.numeric(vanha$pros)
str(vanha$pros)

library(ggplot2)
c<-ggplot(vanha, aes(x = factor(team_name), y = pros,fill=factor(team_name))) + geom_bar(stat = "identity")
c<- c+ coord_flip()+labs(title = "Champions of the Flyway 2015", x = "Team name", y="Percent raised")+guides(fill=FALSE)
c+ theme_classic()
