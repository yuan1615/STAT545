# 要点
# many tibbles  ------->  one tibble
# ·Bind
# ·Join
# ·Lookup

# 主要函数:
# bind_rows:合并行，有tibble少列时，仍然可以合并
#           列属性不同时不能合并；因子水平不同时将为字符变量
# bind_cols:合并列

# slice：根据位置选择行Choose rows by position


##### Chapter 14 When one tibble is not enough #####

#------ 14.1 Typology of data combination tasks ------
# 数据组合任务的类型
# Bind 
# Join
# lookup

library(tidyverse)

#------ 14.2 Bind ------

#---- 14.2.1 Row binding ----

fship <- tribble(
  ~Film,    ~Race, ~Female, ~Male,
  "The Fellowship Of The Ring",    "Elf",    1229,   971,
  "The Fellowship Of The Ring", "Hobbit",      14,  3644,
  "The Fellowship Of The Ring",    "Man",       0,  1995
)
rking <- tribble(
  ~Film,    ~Race, ~Female, ~Male,
  "The Return Of The King",    "Elf",     183,   510,
  "The Return Of The King", "Hobbit",       2,  2673,
  "The Return Of The King",    "Man",     268,  2459
)
ttow <- tribble(
  ~Film,    ~Race, ~Female, ~Male,
  "The Two Towers",    "Elf",     331,   513,
  "The Two Towers", "Hobbit",       0,  2463,
  "The Two Towers",    "Man",     401,  3589
)

(lotr_untidy <- bind_rows(fship, ttow, rking))

# 当有确实列时，bind_rows可以合并，而rbind不可以合并
ttow_no_Female <- ttow %>% select(-Female)
bind_rows(fship, ttow_no_Female, rking)

rbind(fship, ttow_no_Female, rking)  # Error：变量的列数不对

# 不同类型合并
ttow_char_Female <- ttow %>% 
  mutate(Female = as.character(Female))
bind_rows(fship, ttow_char_Female, rking)  # Error: 
rbind(fship, ttow_char_Female, rking)

# 因子有不同水平进行合并
fship_f <- fship %>% 
  mutate(Film = parse_factor(Film))
ttow_f <- ttow %>% 
  mutate(Film = parse_factor(Film))
bind_rows(fship_f, ttow_f)  # warning: Factor --> character
rbind(fship_f, ttow_f)

#---- 14.2.2 Column binding ----
# 一定不要随便排序后合并！！！！！
library(gapminder)

life_exp <- gapminder %>%
  select(country, year, lifeExp)

pop <- gapminder %>%
  arrange(year) %>% 
  select(pop)

gdp_percap <- gapminder %>% 
  arrange(pop) %>% 
  select(gdpPercap)

(gapminder_garbage <- bind_cols(life_exp, pop, gdp_percap))

#  描述性统计看不出来错误，是因为行不对应！！！
summary(gapminder$lifeExp)
summary(gapminder_garbage$lifeExp)
range(gapminder$gdpPercap)
range(gapminder_garbage$gdpPercap)

# cbind的广播功能有可能带来错误，bind_cols会拒绝这种广播功能
gapminder_mostly <- gapminder %>% select(-pop, -gdpPercap)
gapminder_leftovers_filtered <- gapminder %>% 
  filter(country == "Canada") %>% 
  select(pop, gdpPercap)

gapminder_nonsense <- cbind(gapminder_mostly, gapminder_leftovers_filtered)
head(gapminder_nonsense, 14)


#------ 14.3 Joins in dplyr ------
# 详细的例子见第15章

gapminder %>% 
  select(country, continent) %>% 
  group_by(country) %>% 
  slice(1) %>% 
  left_join(country_codes)

#------ 14.4 Table Lookup ------
# 见第16章
