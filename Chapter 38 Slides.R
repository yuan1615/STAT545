# 要点:从网站上获取数据  -- 幻灯片

##### Chapter 38 Slides #####

# Four ways to get web data
# There are many ways to obtain data from the Internet; let's consider four categories:
# 
# click-and-download on the internet as a "flat" file, such as .csv, .xls
# install-and-play published in a repository which has an API , which has been wrapped
# API-query published with an unwrapped API
# Scraping implicit in an html website


#------ Open Movie Database API ------
library(tidyverse)
library(jsonlite)
library(knitr)

# http://www.omdbapi.com/

gday <- function(team="canucks") {
	url <- paste0("http://live.nhle.com/GameData/GCScoreboard/", 
								Sys.Date(), 
								".jsonp")
	grepl(team, RCurl::getURL(url), ignore.case=TRUE)
}

library(httr)
req <- GET("http://live.nhle.com/GameData/GCScoreboard/2014-11-24.jsonp")
jsonp <- content(req, "text")
json <- gsub('([a-zA-Z_0-9\\.]*\\()|(\\);?$)', "", jsonp, perl = TRUE)
data <- fromJSON(json)

data$games %>%
	kable
