# 要点
# 主要函数:
# tibble:构建数据框/tribble
# with:将数据框中的具体变量展开,不需要$符号引用
# %$%:magrittr包中的函数，类似with的用法 
# gather:将数据变得整齐tidy


##### Chapter 27 Secrets of a happy graphing life #####

#------ 27.1 Load gapminder and the tidyverse ------
library(gapminder)
library(tidyverse)

#------ 27.2 Hidden data wrangling problems ------

# Keep stuff in data frames
# Keep your data frames tidy; be willing to reshape your data often
# Use factors and be the boss of them

#------ 27.3 Keep stuff in data frames ------
# 不要将数据放到数据框外导入ggplot2

life_exp <- gapminder$lifeExp
year <- gapminder$year
ggplot(mapping = aes(x = year, y = life_exp)) + geom_jitter()

# 
ggplot(data = gapminder, aes(x = year, y = life_exp)) + geom_jitter()

#---- 27.3.1 Explicit data frame creation via tibble::tibble() 
# and tibble::tribble()----

my_dat <-
  tibble(x = 1:5,
         y = x ^ 2,
         text = c("alpha", "beta", "gamma", "delta", "epsilon"))

## if you're truly "hand coding", tribble() is an alternative

my_dat <- tribble(
  ~ x, ~ y,    ~ text,
  1,   1,   "alpha",
  2,   4,    "beta",
  3,   9,   "gamma",
  4,  16,   "delta",
  5,  25, "epsilon"
)
str(my_dat)

ggplot(my_dat, aes(x, y)) + geom_line() + geom_text(aes(label = text))

#---- 27.3.2 Sidebar: with() ----
# 不是所有的函数都提供数据框的数据输入，此时就要用到with()函数

cor(year, lifeExp, data = gapminder)
cor(gapminder$year, gapminder$lifeExp)

with(gapminder,
     cor(year, lifeExp))


# 
library(magrittr)
gapminder %$%
  cor(year, lifeExp)

#------ 27.4 Tidying and reshaping ------
# This is an entire topic covered elsewhere:
#   
#   Chapter 8 - Tidy data using Lord of the Rings

#------ 27.5 Factor management ------
# This is an entire topic covered elsewhere:
#   
#   Chapter 10 - Be the boss of your factors

#------ 27.6 Worked example ------

#---- 27.6.1 Reshape your data ----

japan_dat <- gapminder %>%
  filter(country == "Japan")
japan_tidy <- japan_dat %>%
  gather(key = var, value = value, pop, lifeExp, gdpPercap)
dim(japan_dat)
dim(japan_tidy)

#---- 27.6.2 Iterate over the variables via faceting ----
# ！！！！！牛的一批！！！！！
# 当tidy后，可以分面板展示数据

p <- ggplot(japan_tidy, aes(x = year, y = value)) +
  facet_wrap(~ var, scales="free_y")
p + geom_point() + geom_line() +
  scale_x_continuous(breaks = seq(1950, 2011, 15))

#------ 27.6.3 Recap ------
# 汇总
japan_tidy <- gapminder %>%
  filter(country == "Japan") %>%
  gather(key = var, value = value, pop, lifeExp, gdpPercap)
ggplot(japan_tidy, aes(x = year, y = value)) +
  facet_wrap(~ var, scales="free_y") +
  geom_point() + geom_line() +
  scale_x_continuous(breaks = seq(1950, 2011, 15))