# 要点
# 主要packages：stringr; tidyr
# 主要函数:
# fruit, words, and sentences: stringr包中的示例文件

# str_detect:确定文字字符串的存在与否
# str_subset:同str_detect类似，仅保留匹配的元素
# str_split/str_split_fixed/separate:按照定界符切割字符串，separate用于数据框
# str_length:返回字符串的长度，就是由几个字符组成的
# str_sub:根据位置，切分字符串/ 指定具体位置是什么字符！
# str_c:将所有字符折叠到一个字符串里，类似c函数!主语sep与collapse参数
# unite:数据框下的str_c函数
# str_replace:子字符串替换（匹配替换），str_sub是位置替换
# str_replace_na:替换NA变量！在处理数据框时为replace_na

# ******************* Regular expressions ***********************
# 正则表达式，一般在pattern参数中使用的
# 
# .代表任何单个字符
# ^代表字符串的开头
# $代表字符串的结尾
# \b表达单词边界
# \B表达不是单词边界

# 字符类   [nls]:存在nls    [^nls]:不存在nls

# 匹配空格   \s与[:space:]   !!!  但是在R中应该是 \\s与[[:space:]]
# 匹配标点符号   [[:punct:]]

# **** 量词表 ****
# quantifier	meaning	quantifier	meaning
#    *	    0 or more	   {n}	    exactly n
#    +	    1 or more	   {n,}	    at least n
#    ?	    0 or 1	     {,m}	    at most m
#                        {n,m}	  between n and m, inclusive

# 转义字符\
# \表示R语言本身的转义，比如文本里有引号
# \\表示正则表达式的转义，比如 \\. 匹配.

##### Chapter 11 Character vectors #####

#------ 11.1 Character vectors: where they fit in ------
# 处理字符串真的很麻烦

#------ 11.2 Resources ------
# 完全记不住太多的处理细节！当实际中用到时候可以回来找这些资源

#---- 11.2.1 Manipulating character vectors ----
# ***** stringr 高级包*****：str_
# tidyr : separate(), unite(), extract().适合将一个字符向量分解成多个字符向量
# 基础包：nchar(), strsplit(), substr(), paste(), paste0()
# glue:当stringr不能实现时，glue是很好的选择

#---- 11.2.2 Regular expressions resources ----
# 正则表达式：A God-awful and powerful language for expressing patterns 
#             to match in text or for search-and-replace.
# 关于正则表达式的课程有：
# R for Data Science 课程中的 Strings https://r4ds.had.co.nz/strings.html
# 

#---- 11.2.3 Character encoding resources ----
# Strings subsection of data import chapter in R for Data Science
# https://r4ds.had.co.nz/data-import.html#readr-strings

#---- 11.2.4 Character vectors that live in a data frame ----

#------ 11.3 Load the tidyverse, which includes stringr ------
library(tidyverse)

#------ 11.4 Regex-free string manipulation with stringr and tidyr ------

# Basic string manipulation tasks:
#   
# Study a single character vector
#   How long are the strings?
#   Presence/absence of a literal string
#
# Operate on a single character vector
#   Keep/discard elements that contain a literal string
#   Split into two or more character vectors using a fixed delimiter
#   Snip out pieces of the strings based on character position
#
# Collapse into a single string
#   Operate on two or more character vectors
#   Glue them together element-wise to get a new character vector.
#
# fruit, words, and sentences are character vectors that ship with stringr 
# for practicing.

#---- 11.4.1 Detect or filter on a target string ----
# 检测或过滤目标字符串
str_detect(fruit, "fruit")

(my_fruit <-str_subset(fruit, "fruit"))

#---- 11.4.2 String splitting by delimiter ----
# 利用定界符分割字符串
str_split(my_fruit, pattern = " ")
str_split_fixed(my_fruit, pattern = " ", n = 2)

# 数据框中切割字符串
my_fruit_df <- tibble(my_fruit)
my_fruit_df %>% 
  separate(my_fruit, into = c("pre", "post"), sep = " ")

#---- 11.4.3 Substring extraction (and replacement) by position ----
# 根据位置提取子字符串

length(my_fruit)
str_length(my_fruit)

head(my_fruit) %>% 
  str_sub(1, 3)

# start/end还可以是向量形式
head(my_fruit_df) %>% 
  mutate(snip =   str_sub(my_fruit, 1:6, 3:8))

# str_sub还可以指定字符串位置的字符是什么
(x <- head(fruit, 3))
str_sub(x, 1, 3) <- "AAA"

#---- 11.4.4 Collapse a vector ----
# 折叠向量 str_c
head(fruit) %>% 
  str_c(collapse = ", ")

#---- 11.4.5 Create a character vector by catenating multiple vectors ----
# 通过连接多个字符向量来构建一个字符串

str_c(fruit[1:4], fruit[5:8], sep = " & ")
str_c(fruit[1:4], fruit[5:8], sep = " & ", collapse = ", ")

fruit_df <- tibble(
  fruit1 = fruit[1:4],
  fruit2 = fruit[5:8]
)
fruit_df %>% 
  unite("flavor_combo", fruit1, fruit2, sep = " & ")

#---- 11.4.6 Substring replacement ----
# 子字符串替换
str_replace(my_fruit, pattern = "fruit", replacement = "THINGY")

melons <- str_subset(fruit, pattern = "melon")
melons[2] <- NA
str_replace_na(melons, "UNKNOWN MELON")

tibble(melons) %>% 
  replace_na(replace = list(melons = "UNKNOWN MELON"))

#------ 11.5 Regular expressions with stringr ------

#---- 11.5.1 Load gapminder ----
library(gapminder)
countries <- levels(gapminder$country)

#---- 11.5.2 Characters with special meaning ----
# 正则表达式中的特殊字符
str_subset(countries, pattern = "i.a")
str_subset(countries, pattern = "i.a$")

str_subset(my_fruit, pattern = "d")
str_subset(my_fruit, pattern = "^d")

str_subset(fruit, pattern = "melon")
str_subset(fruit, pattern = "\\bmelon")
str_subset(fruit, pattern = "\\Bmelon")

#---- 11.5.3 Character classes ----
# 字符类
# 字符类一般在方括号中给出，但经常用的不用，类似\d表示单个数字

str_subset(countries, pattern = "[nls]ia$")
str_subset(countries, pattern = "[^nls]ia$")

# 匹配空格

str_split_fixed(my_fruit, "\\s", n = 2)
str_split_fixed(my_fruit, "[[:space:]]", n = 2)

# 匹配标点
str_subset(countries, pattern = "[[:punct:]]")

#---- 11.5.4 Quantifiers ----
#量词
(matches <- str_subset(fruit, pattern = "l.*e"))  # 0 or more

list(match = intersect(matches, str_subset(fruit, pattern = "l.+e")),
     no_match = setdiff(matches, str_subset(fruit, pattern = "l.+e")))

list(match = intersect(matches, str_subset(fruit, pattern = "l.?e")),
     no_match = setdiff(matches, str_subset(fruit, pattern = "l.?e")))

list(match = intersect(matches, str_subset(fruit, pattern = "le")),
     no_match = setdiff(matches, str_subset(fruit, pattern = "le")))

#------ 11.5.5 Escaping ------
# 关于反斜杠是怎么转译的

#---- 11.5.5.1 Escapes in plain old strings ----
# To escape quotes inside quotes: 转译引号内的引号

cat("Do you use \"airquotes\" much?")

# To insert newline (\n) or tab (\t):
cat("before the newline\nafter the newline")

cat("before the tab\tafter the tab")

#---- 11.5.5.2 Escapes in regular expressions ----
str_subset(countries, pattern = "[[:punct:]]")
str_subset(countries, pattern = "\\.")

(x <- c("whatever", "X is distributed U[0,1]"))
str_subset(x, pattern = "\\[")


#------ 11.5.6 Groups and backreferences ------
# The Strings chapter of R for Data Science (Wickham and Grolemund 2016).
# https://r4ds.had.co.nz/strings.html