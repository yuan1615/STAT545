# 要点

# 主要函数:

# match(x, table):报告键x中的值出现在查找变量表中的位置.
#                 它返回正整数作为索引

# add_column: Add columns to a data frame
# setNames:这是一个方便的函数，用于设置对象的名称并返回该对象
# unclass:查看类别的函数吧，类似class

##### Chapter 16 Table lookup #####

# Party like it’s Microsoft Excel LOOKUP() time!

#------ 16.1 Load gapminder and the tidyverse ------
library(gapminder)
library(tidyverse)

#------ 16.2 Create mini Gapminder ------

mini_gap <- gapminder %>% 
  filter(country %in% c("Belgium", "Canada", "United States", "Mexico"),
         year > 2000) %>% 
  select(-pop, -gdpPercap) %>% 
  droplevels()
mini_gap

#------ 16.3 Dorky national food example ------

food <- tribble(
  ~ country,    ~ food,
  "Belgium",  "waffle",
  "Canada", "poutine",
  "United States", "Twinkie"
)
food

#------ 16.4 Lookup national food ------

match(x = mini_gap$country, table = food$country)

(indices <- match(x = mini_gap$country, table = food$country))
add_column(food[indices, ], x = mini_gap$country)


mini_gap %>% 
  mutate(food = food$food[indices])


mini_gap %>% 
  left_join(food)


#------ 16.5 World’s laziest table lookup ------
# 这里的表简化为了向量，名称为国家
(food_vec <- setNames(food$food, food$country))

mini_gap %>% 
  mutate(food = food_vec[country])
# country是factor，这里索引不行的！

unclass(mini_gap$country)
mini_gap %>% 
  mutate(food = food_vec[as.character(country)])