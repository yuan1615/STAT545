# 要点
# 主要函数：
# filter:筛选逻辑值为True的行
# %>% ：管道函数
# select：选择列


##### Chapter 6 Introduction to dplyr #####

#------ 6.1 Intro ------
# dplyr

#------ 6.1.1 Load dplyr and gapminder ------
library(tidyverse)
library(gapminder)

#------ 6.1.2 Say hello to the gapminder tibble ------
gapminder
class(gapminder)
as_tibble(iris)

#------ 6.2 Think before you create excerpts of your data … ------
(canada <- gapminder[241:252, ])

#------ 6.3 Use filter() to subset data row-wise ------

filter(gapminder, lifeExp < 29)
filter(gapminder, country == "Rwanda", year > 1979)
filter(gapminder, country %in% c("Rwanda", "Afghanistan"))

#------ 6.4 Meet the new pipe operator ------
gapminder %>% head()
gapminder %>% head(3)

#------ 6.5 Use select() to subset the data on variables or columns. ------
select(gapminder, year, lifeExp)
gapminder %>% 
  select(year, lifeExp) %>% 
  head(5)

#------ 6.6 Revel in the convenience ------
gapminder %>% 
  filter(country == "Cambodia") %>% 
  select(year, lifeExp)

#------ 6.7 Pure, predictable, pipeable ------



#------ 6.8 Resources ------