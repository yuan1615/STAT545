# 要点
# 主要library: readr; forcats(reorder factor levels)
# 主要函数:
# fs包中的path_package可以获得安装的包的路径
# read_tsv:读取tsv制表符文件，返回tibble类型的数据框
# parse：转换列类型函数parse_integer.........
# spec_tsv/spec_csv:查看读入的列类型
# write_csv:写入文件，默认没有行号。比write.csv好用
# fct_reorder:重新对因子变量的因子排序，这个很重要，尤其是利用ggplot2画图的时候
# saveRDS() and readRDS():保存和读取rds文件，这样的存储不会破坏因素水平
# dput与dget保存文件也可以不破坏因素水平

##### Chapter 9 Writing and reading files #####

#------ 9.1 File I/O overview ------

#---- 9.1.1 Data import mindset ----

#---- 9.1.2 Data export mindset ----

#------ 9.2 Load the tidyverse ------
library(tidyverse)

#------ 9.3 Locate the Gapminder data ------
library(fs)  # 获取gapminder包的路径
(gap_tsv <- path_package("gapminder", "extdata", "gapminder.tsv"))

gapminder <- read_tsv(gap_tsv)

str(gapminder, give.attr = FALSE)  # give.attr:将属性显示为attr结构
str(gapminder, give.attr = TRUE) 

# 注:readr::read_delim()为更灵活的read_tsv;
#    read_tsv读进来的文件，没有将字符换为因子变量，这是更好的。

gapminder <- gapminder %>% 
  mutate(country = factor(country),
         continent = factor(continent))
str(gapminder)

#---- 9.4 Bring rectangular data in – summary ----
# 列类型，怎么将列解释（parser）为自己想要的类型
# https://cran.r-project.org/web/packages/readr/vignettes/readr.html

#---- 9.4.1 Vector parsers ----
# Atomic vectors
parse_integer(c("1", "2", "3"))
parse_double(c("1.56", "2.34", "3.56"))
parse_logical(c("true", "false"))

# Flexible numeric parser
parse_number(c("0%", "10%", "150%"))
parse_number(c("$1,234.5", "$12.45"))

# Date/times,哈哈这个好，省的学lubridate包了
parse_datetime("2010-10-01 21:45")
parse_date("2010-10-01")
parse_time("1:00pm")

parse_datetime("1 January, 2010", "%d %B, %Y")
parse_datetime("02/02/15", "%m/%d/%y")

# Factors
parse_factor(c("a", "b", "a"), levels = c("a", "b", "c"))

# Column specification

# 可以利用spec_tsv/spec_csv查看读入的列类型
spec(read_tsv(gap_tsv))

# 注：该函数根据前1000行来判断解析的类型

# ****************手动调整列类型*****************************
gapminder <- read_tsv(gap_tsv, 
                      col_types = cols(country = col_factor(),
                                       continent = col_factor()))
# Available column specifications
# #’ The available specifications are: (with string abbreviations in brackets)
# 
# col_logical() [l], containing only T, F, TRUE or FALSE.
# col_integer() [i], integers.
# col_double() [d], doubles.
# col_character() [c], everything else.
# col_factor(levels, ordered) [f], a fixed set of values.
# col_date(format = "") [D]: with the locale’s date_format.
# col_time(format = "") [t]: with the locale’s time_format.
# col_datetime(format = "") [T]: ISO8601 date times
# col_number() [n], numbers containing the grouping_mark
# col_skip() [_, -], don’t import this column.
# col_guess() [?], parse using the “best” type based on the input.

#------ 9.5 Compute something worthy of export ------

gap_life_exp <- gapminder %>% 
  group_by(country, continent) %>% 
  summarise(life_exp = max(lifeExp)) %>% 
  ungroup()
gap_life_exp

#------ 9.6 Write rectangular data out ------
write_csv(gap_life_exp, file.path("Chapter 9 Data", "gap_life_exp.csv"))

#------ 9.7 Invertibility可逆性 ------
# 写到csv文件，再读入后，因子水平会变化

#------ 9.8 Reordering the levels of the country factor ------
head(levels(gap_life_exp$country)) # alphabetical order

gap_life_exp <- gap_life_exp %>% 
  mutate(country = fct_reorder(country, life_exp))
head(levels(gap_life_exp$country)) # in increasing order of maximum life expectancy

head(gap_life_exp)

#------ 9.9 saveRDS() and readRDS() ------
# 保存更改好的因素水平，也就是保存9.8的工作
saveRDS(gap_life_exp, file.path("Chapter 9 Data", "gap_life_exp.rds"))

rm(gap_life_exp)
gap_life_exp

gap_life_exp <- readRDS(file.path("Chapter 9 Data", "gap_life_exp.rds"))
gap_life_exp
head(levels(gap_life_exp$country))

#------ 9.10 Retaining factor levels upon re-import ------
(country_levels <- tibble(original = head(levels(gap_life_exp$country))))
write_csv(gap_life_exp, file.path("Chapter 9 Data", "gap_life_exp.csv"))
saveRDS(gap_life_exp, file.path("Chapter 9 Data", "gap_life_exp.rds"))

rm(gap_life_exp)
head(gap_life_exp)

gap_via_csv <- read_csv(file.path("Chapter 9 Data", "gap_life_exp.csv")) %>% 
  mutate(country = factor(country))
gap_via_rds <- readRDS(file.path("Chapter 9 Data", "gap_life_exp.rds"))

country_levels <- country_levels %>% 
  mutate(via_csv = head(levels(gap_via_csv$country)),
         via_rds = head(levels(gap_via_rds$country)))

#------ 9.11 dput() and dget() ------

## first restore gap_life_exp with our desired country factor level order
gap_life_exp <- readRDS(file.path("Chapter 9 Data", "gap_life_exp.rds"))
dput(gap_life_exp, file.path("Chapter 9 Data", "gap_life_exp.txt"))

gap_life_exp_dget <- dget(file.path("Chapter 9 Data", "gap_life_exp.txt"))
country_levels <- country_levels %>% 
  mutate(via_dput = head(levels(gap_life_exp_dget$country)))

#------ 9.12 Other types of objects to use dput() or saveRDS() on ------
# 还可以使用R特定的文件格式来保存重要的非矩形对象，
# 例如拟合的非线性混合效果模型或分类和回归树。

#------ 9.13 Clean up ------
# file.remove(file.path("Chapter 9 Data", list.files(path = "Chapter 9 Data", 
#                                    pattern = "^gap_life_exp")))


#------ 9.14 Pitfalls of delimited files ------
# 分隔符文件的陷阱
# 文件总是很混乱的，需要具体问题具体分析，比如人名中的空格等问题....

#------ 9.15 Resources ------