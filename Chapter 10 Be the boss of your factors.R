# 要点
# 主要packages: forcats(猫)
# 主要函数:
# *** forcats中的fct_函数 ***

# levels:因子变量的因子水平
# nlevels:有几个因子水平
# fct_count:统计因子变量每个因子的个数，同dplyr中的count函数
# fct_drop:降低因子变量没有用的因子水平，同droplevels
# fct_infreq:按因子频率排序因子顺序
# fct_rev:对称颠倒因子顺序
# fct_reorder:根据另一些变量排序因子变量
# fct_reorder2:用于将因子映射到非位置美学的2d显示,例如颜色啥的
# fct_relevel:仅仅把个别的因素提前
# fct_recode:重新给因素水平编码，例如United States--USA
# fct_c:类似于c函数，合并两个因子变量

##### Chapter 10 Be the boss of your factors #####

#------ 10.1 Factors: where they fit in -------
# 在建模和画图的时候因子factor变量通常是让人们头疼的存在！
# 因子变量实际并不是以字符的形式存在的，而是以数字存在！
# 我们可以使用read_csv()/read_tsv()/tibble去避免因子变量的产生！
# 同样可以使用 stringAsFactors = FALSE 进行控制。

# 后续主要针对因子变量的处理进行介绍

#------ 10.2 The forcats package ------
# 猫

#------ 10.3 Load forcats and gapminder ------
library(tidyverse)
library(gapminder)

#------ 10.4 Factor inspection ------
str(gapminder$continent)
levels(gapminder$continent)
nlevels(gapminder$continent)
class(gapminder$continent)

gapminder %>% 
  count(continent)

fct_count(gapminder$continent)

#------ 10.5 Dropping unused levels ------
# 删掉没有用的因子水平是必要的，尤其是对数据框取子集的时候
nlevels(gapminder$country)

h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries)
nlevels(h_gap$country)

h_gap_dropped <- h_gap %>% 
  droplevels()
nlevels(h_gap_dropped$country)

h_gap$country %>% 
  fct_drop() %>% 
  levels()

# Exercise
# 筛选出人口少于250 000 的行，并降低因子水平
p_gap <- gapminder %>% 
  filter(pop < 250000) %>% 
  mutate_at(vars(country, continent), list(~fct_drop(.)))
p_gap$country %>% 
  levels()
p_gap$continent %>% 
  levels()

#------ 10.6 Change order of the levels, principled ------
# 更改因子的顺序，这个也很重要，尤其是画图的时候
# ！！！ 默认情况下按字母排序！！！！这个太随机了，不利于画图
# 一般的级别：根据因子出现的频率排
#             根据另一些变量的统计量排

# 根据因子频率排序
gapminder$continent %>% 
  levels()
gapminder$continent %>% 
  fct_infreq() %>% 
  levels()
gapminder$continent %>% 
  fct_infreq() %>% 
  fct_rev() %>% 
  levels()

# 根据另一些变量排序因子变量
fct_reorder(gapminder$country, gapminder$lifeExp) %>% 
  levels() %>% head()

fct_reorder(gapminder$country, gapminder$lifeExp, min) %>% 
  levels() %>% head()

fct_reorder(gapminder$country, gapminder$lifeExp, .desc = TRUE) %>% 
  levels() %>% head()

gap_asia_2007 <- gapminder %>% 
  filter(year == 2007, continent == "Asia")

ggplot(gap_asia_2007, aes(x = lifeExp, y = country)) + geom_point()
ggplot(gap_asia_2007, aes(x = lifeExp, y = fct_reorder(country, lifeExp))) +
  geom_point()

# fct_reorder2

h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries) %>% 
  droplevels()

ggplot(h_gap, aes(x = year, y = lifeExp, color = country)) +
  geom_line()

ggplot(h_gap, aes(x = year, y = lifeExp,
                  color = fct_reorder2(country, year, lifeExp))) +
  geom_line() +
  labs(color = "country")

#------ 10.7 Change order of the levels, “because I said so” ------

h_gap$country %>% levels() %>% head()

h_gap$country %>% fct_relevel("Romania") %>% levels() %>% head()

#------ 10.8 Recode the levels ------
i_gap <- gapminder %>% 
  filter(country %in% c("United States", "Sweden", "Australia")) %>% 
  droplevels()

i_gap$country %>% levels()

i_gap$country %>% 
  fct_recode("USA" = "United States", "Oz" = "Australia") %>% 
  levels()
#------ 10.9 Grow a factor ------
df1 <- gapminder %>%
  filter(country %in% c("United States", "Mexico"), year > 2000) %>%
  droplevels()
df2 <- gapminder %>%
  filter(country %in% c("France", "Germany"), year > 2000) %>%
  droplevels()

levels(df1$country)
levels(df2$country)

c(df1$country, df2$country)

fct_c(df1$country, df2$country)

bind_rows(df1, df2)
rbind(df1, df2)
##