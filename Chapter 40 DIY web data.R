# 要点

# rOpenSci软件包:各种数据API接口
# https://ropensci.org/packages/


# 主要包:
# curl
# jsonlite：解析JSON格式
# xml2：解析XML格式
# httr:较api更加灵活


# 主要函数:
# edit_r_environ()：保存密码信息
# Sys.getenv：获取系统环境变量,获取密码信息
# glue：格式化并插入一个字符串,{}进行插入!可用于print呀哈哈

# curl:创建Curl连接接口
# readLines:从连接读取文本行
# fromJSON:将JSON转换为R对象

# read_xml：Read HTML or XML
# xml_contents:

# GET:GET a url.
# content:从请求中提取内容
# headers:从响应中提取标头
# status_code:从响应中提取状态代码


##### Chapter 40 DIY web data #####

#------ 40.1 Interacting with an API ------

#---- 40.1.1 Load the tidyverse ----
library(tidyverse)

#---- 40.1.2 Examine the structure of API requests using 
#            the Open Movie Database----

# 检查API的请求结构
# Open Movie Database (OMDb)


#---- 40.1.3 Create an OMDb API Key ----
library(usethis)
# edit_r_environ()

movie_key <- Sys.getenv("OMDB_API_KEY")

#-- 40.1.3.1 Alternative strategy for keeping keys: .Rprofile --

#------ 40.1.4 Recreate the request URL in R ------
request <- glue::glue("http://www.omdbapi.com/?t=Interstellar&y=2014&plot=short&r=xml&apikey={movie_key}")
request

glue::glue("http://www.omdbapi.com/?t={title}&y={year}&plot={plot}&r={format}&apikey={api_key}",
           title = "Interstellar",
           year = "2014",
           plot = "short",
           format = "xml",
           api_key = movie_key)
omdb <- function(title, year, plot, format, api_key) {
  glue::glue("http://www.omdbapi.com/?t={title}&y={year}&plot={plot}&r={format}&apikey={api_key}")
}

#---- 40.1.5 Get data using the curl package ----
library(curl)
request_xml <- omdb(title = "Interstellar", year = "2014", plot = "short", 
                    format = "xml", api_key = movie_key)

con <-  curl(request_xml)
answer_xml <- readLines(con, warn = FALSE)
close(con)
answer_xml

# JSON
request_json <- omdb(title = "Interstellar", year = "2014", plot = "short", 
                     format = "json", api_key = movie_key)

con <- curl(request_json)
answer_json <- readLines(con, warn = FALSE)
close(con)
answer_json  

#------ 40.2 Intro to JSON and XML ------

#---- 40.2.1 Parsing the JSON response with jsonlite ----

library(jsonlite)

answer_json %>% 
  fromJSON()

answer_json %>% 
  fromJSON() %>% 
  as_tibble() %>% 
  glimpse()

#---- 40.2.2 Parsing the XML response using xml2 ----
library(xml2)
(xml_parsed <- read_xml(answer_xml))

(contents <- xml_contents(xml_parsed))

(attrs <- xml_attrs(contents)[[1]])

attrs %>% 
  bind_rows() %>% 
  glimpse()

#------ 40.3 Introducing the easy way: httr ------
library(httr)

# GET()-获取现有资源。URL包含服务器查找和返回资源所需的所有必要信息。
# POST()-创建一个新资源。POST请求通常带有一个有效负载，该有效负载指定了新资源的数据。
# PUT()-更新现有资源。有效载荷可以包含资源的更新数据。
# DELETE() -删除现有资源。



request_json <- omdb(title = "Interstellar", year = "2014", plot = "short", 
                     format = "json", api_key = movie_key)
response_json <- GET(request_json)
content(response_json, as = "parsed", type = "application/json")


request_xml <- omdb(title = "Interstellar", year = "2014", plot = "short", 
                    format = "xml", api_key = movie_key)

response_xml <- GET(request_xml)
content(response_xml, as = "parsed")
headers(response_xml)

status_code(response_xml)

the_martian <- GET("http://www.omdbapi.com/?", 
                   query = list(t = "The Martian", y = 2015, plot = "short", 
                                r = "json", apikey = movie_key))
content(the_martian)


#------ 40.4 Scraping ------
# 如果网站上存在数据，但根本没有API提供数据怎么办!

# 方法一
library(rvest)

# 方法2 CSS

#------ 40.5 Scraping via CSS selectors ------
research <- read_html("https://www.scimagojr.com/countryrank.php") %>% 
  html_table(fill = TRUE)

research <- read_html("http://www.scimagojr.com/countryrank.php") %>% 
  html_node(".tabla_datos") %>%
  html_table()
glimpse(research)
