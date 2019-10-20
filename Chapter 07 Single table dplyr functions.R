# 要点
# 主要函数：
# mutate:增加列变量;可以构建中间变量，最后使中间变量为NULL
# arrange:对数据进行排序
# desc:实现降序排列
# rename:重新命名变量
# select:可以重命名和重新定位变量(everything代表所有变量)
# group_by:对变量分组
# n():计数
# summarize:由n到1（mean, median, var, sd, mad, IQR, min, max）
# tally:对行进行计数
# count:同时进行分组计数
# n_distinct:统计不同的行数
# summarize_at: applies the same summary function(s) to multiple variables.
# first:从向量中取第一个值
# 窗口功能:Window functions take n inputs and give back n outputs. 
        # Furthermore, the output depends on all the values.
# min_rank:排序函数，返回的是行号，可配合desc使用
# print(n = Inf):可以打印完整的行
# top_n:获取前n个值，配合desc获取后n个值

##### Chapter 7 Single table dplyr functions #####

#------ 7.1 Where were we? ------

#------ 7.2 Load dplyr and gapminder ------
library(tidyverse)
library(gapminder)

#------ 7.3 Create a copy of gapminder ------
(my_gap <- gapminder)

## let output print to screen, but do not store
my_gap %>% filter(country == "Canada")

## store the output as an R object
my_precious <- my_gap %>% filter(country == "Canada")

#------ 7.4 Use mutate() to add new variables ------
my_gap %>% 
  mutate(gdp = pop * gdpPercap)

ctib <- my_gap %>%
  filter(country == "Canada")
## this is a semi-dangerous way to add this variable
## I'd prefer to join on year, but we haven't covered joins yet
my_gap <- my_gap %>%
  mutate(tmp = rep(ctib$gdpPercap, nlevels(country)),
         gdpPercapRel = gdpPercap / tmp,
         tmp = NULL)

my_gap %>% 
  filter(country == "Canada") %>% 
  select(country, year, gdpPercapRel)

summary(my_gap$gdpPercapRel)

#------ 7.5 Use arrange() to row-order data in a principled way ------
my_gap %>%
  arrange(year, country)

my_gap %>% 
  filter(year == 2007) %>% 
  arrange(lifeExp)

my_gap %>% 
  filter(year == 2007) %>% 
  arrange(desc(lifeExp))

#------ 7.6 Use rename() to rename variables ------
my_gap %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)

#------ 7.7 select() can rename and reposition variables ------
my_gap %>%
  filter(country == "Burundi", year > 1996) %>% 
  select(yr = year, lifeExp, gdpPercap) %>% 
  select(gdpPercap, everything())

#------ 7.8 group_by() is a mighty weapon ------

#---- 7.8.1 Counting things up ----
my_gap %>%
  group_by(continent) %>%
  summarize(n = n())

my_gap %>% 
  group_by(continent) %>% 
  tally()

my_gap %>% 
  count(continent)

my_gap %>%
  group_by(continent) %>%
  summarize(n = n(),
            n_countries = n_distinct(country))

#---- 7.8.2 General summarization ----
my_gap %>%
  group_by(continent) %>%
  summarize(avg_lifeExp = mean(lifeExp))

my_gap %>% 
  filter(year %in% c(1952, 2007)) %>% 
  group_by(continent, year) %>% 
  summarise_at(vars(lifeExp, gdpPercap), list(~mean(.), ~median(.)))

my_gap %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarize(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))

#------ 7.9 Grouped mutate ------

#---- 7.9.1 Computing with group-wise summaries ----
my_gap %>% 
  group_by(country) %>% 
  select(country, year, lifeExp) %>% 
  mutate(lifeExp_gain = lifeExp - first(lifeExp)) %>% 
  filter(year < 1963)

#---- 7.9.2 Window functions ----

my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>% 
  arrange(year) %>%
  print(n = Inf)

asia <- my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year)
asia

asia %>%
  mutate(le_rank = min_rank(lifeExp),
         le_desc_rank = min_rank(desc(lifeExp))) %>% 
  filter(country %in% c("Afghanistan", "Japan", "Thailand"), year > 1995)

my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year) %>%
  #top_n(1, wt = lifeExp)        ## gets the max
  top_n(1, wt = desc(lifeExp)) ## gets the min


#------ 7.10 Grand Finale ----

my_gap %>% 
  select(country, year, lifeExp, continent) %>% 
  group_by(continent, country) %>% 
  mutate(le_delta = lifeExp - lag(lifeExp)) %>% 
  summarise(worst_le_delta = min(le_delta, na.rm = TRUE)) %>% 
  top_n(-1, wt = worst_le_delta) %>% 
  arrange(worst_le_delta)

#------ 7.11 Resources ------