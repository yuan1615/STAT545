# 要点:
# 整理数据
# github：https://github.com/jennybc/lotr-tidy.git(可以clone到本地)

##### Chapter 8 Tidy data #####

#------ readme ------
# This is a lesson on tidying data. Specifically, what to do when a conceptual 
# variable is spread out over multiple data frames and across 2 or more variables
# in a data frame.
# 
# Data used: words spoken by characters of different races and gender in the 
# Lord of the Rings movie trilogy.
# 
# 01-intro shows untidy and tidy data. Then we demonstrate how tidy data is 
# more useful for analysis and visualization. Includes references, resources, 
# and exercises.
# 02-gather shows how to tidy data, using gather() from the tidyr package. 
# Includes references, resources, and exercises.
# 03-spread shows how to untidy data, using spread() from the tidyr package. 
# This might be useful at the end of an analysis, for preparing figures or tables.
# 04-tidy-bonus-content is not part of the lesson but may be useful as 
# learners try to apply the principles of tidy data in more general settings. 
# Includes links to packages used. It is out of date!

#------ 1.intro ------

# 主要函数：
# grep:模式匹配与替换
# droplevels:从因子中删除没有用到的级别(一般在选取一个数据的子集后使用)
# revalue:在因子或字符向量中，用新值替换指定的值
# within:修改数据框中的个别列时候，可用within
# replace_na:替换变量里得NA值，一般可配合left_join使用
# map:Apply a function to each element of a vector
# lift_dl(crossing)():整理数据（就是每个因子一个，比如2*3*3=18）
# split:这个函数根据因子变量，分裂data.frame
# spread:将键值分散到多个列上
# walk2: 可以用这个函数把所有的列表写入不同的csv文件
# col_types:规定读入的列的变量类型
# gather:与spread反向的函数
# str:查看数据框各列的属性

#---- 1.1 this data from the Lord of the Rings Trilogy ----

library(ggplot2)
library(plyr)

# https://github.com/jennybc/lotr.git
# write code for humans, write data for computers

# 改变因子变量的排列顺序（从csv文件读取的，因子排序是按照字母顺序排列的）
# 例子 reorder Film factor based on story
df <- data.frame(Film = rep(c("The Fellowship Of The Ring", 
                            "The Return Of The King", 
                            "The Two Towers"), each = 3),
                 Race = rep(c("A", "B", "C"), each = 3))
oldLevels <- levels(df$Film)
jOrder <- sapply(c("Fellowship", "Towers", "Return"),
                 function(x) grep(x, oldLevels))
df <- within(df, Film <- factor(as.character(df$Film),
                            oldLevels[jOrder]))

df <- droplevels(subset(df, !(Film == "The Fellowship Of The Ring")))
levels(df$Film)

df <- within(df, Race <- revalue(Race, c(B = "BB")))

#---- 1.2 Tidy Lord of the Rings data ----
library(tidyverse)

lotr_dat <- read_tsv(file.path("Chapter 8 Data", "lotr_clean.tsv"), col_types = cols(
  Film = col_character(),
  Chapter = col_character(),
  Character = col_character(),
  Race = col_character(),
  Words = col_integer()
))

females <- c("Galadriel", "Arwen", "Lobelia Sackville-Baggins", "Rosie",
             "Mrs. Bracegirdle", "Eowyn", "Freda", "Rohan Maiden")
lotr_dat <-
  mutate(lotr_dat,
         Gender = ifelse(Character %in% females, "Female", "Male"))

(lotr_tidy <- lotr_dat %>%
    dplyr::filter(Race %in% c("Elf", "Hobbit", "Man")) %>%
    group_by(Film, Gender, Race) %>%
    summarize(Words = sum(Words)))
(all_combns <- lotr_tidy %>% 
    select(-Words) %>% 
    map(unique) %>% 
    lift_dl(crossing)())
lotr_tidy <- left_join(all_combns, lotr_tidy) %>% 
  replace_na(list(Words = 0)) %>% 
  mutate(Film = factor(Film, levels = c("The Fellowship Of The Ring",
                                        "The Two Towers",
                                        "The Return Of The King")),
         Words = as.integer(Words)) %>% 
  arrange(Film, Race, Gender)
## let the version from 02-gather.Rmd rule the day
## non-substantive differences in row and/or variable order
## write_csv(lotr_tidy, file.path("data", "lotr_tidy.csv"))

## 太多高级的组合函数了，我太菜了。。。
untidy_films <- lotr_tidy %>% 
  split(.$Film) %>%
  map(~ spread(.x, Gender, Words))
## leaves files behind for lesson on how to tidy
walk2(untidy_films,
      file.path("Chapter 8 Data", paste0(gsub(" ", "_", names(untidy_films)), ".csv")),
      ~ write_csv(.x, .y))
## remove film name
untidy_films <- untidy_films %>% 
  map(~select(.x, -Film))

untidy_gender <- lotr_tidy %>% 
  split(.$Gender) %>% 
  map(~ spread(.x, key = Race, value = Words)) %>% 
  map(~ select(.x, Gender, everything()))
walk2(untidy_gender, file.path("Chapter 8 Data", paste0(names(untidy_gender), ".csv")),
      ~ write_csv(.x, .y))

lotr_tidy %>% 
  count(Gender, Race, wt = Words)

(by_race_film <- lotr_tidy %>% 
    group_by(Film, Race) %>% 
    summarize(Words = sum(Words)))

p <- ggplot(by_race_film, aes(x = Film, y = Words, fill = Race))
p + geom_bar(stat = "identity", position = "dodge") +
  coord_flip() + guides(fill = guide_legend(reverse = TRUE))

#------ 2.gather ------

# 主要函数：
# read_csv:readr中的函数，读取csv/tsv到一个tibble
# bind_rows:通过行和列绑定多个数据框

# Each column is a variable
# Each row is an observation

#---- 2.1 Import untidy Lord of the Rings data ----
library(tidyverse)
fship <- read_csv(file.path("Chapter 8 Data", "The_Fellowship_Of_The_Ring.csv"))
ttow <- read_csv(file.path("Chapter 8 Data", "The_Two_Towers.csv"))
rking <- read_csv(file.path("Chapter 8 Data", "The_Return_Of_The_King.csv")) 
rking

#---- 2.2 Collect untidy Lord of the Rings data into a single data frame ----
lotr_untidy <- bind_rows(fship, ttow, rking)
str(lotr_untidy)

lotr_untidy

# 接下来应该是需要把性别归类，数字为Works

#---- 2.3 Tidy the untidy Lord of the Rings data ----

# “Word count” is a fundamental variable in our dataset and it’s currently 
# spread out over two variables, Female and Male.

lotr_tidy <- lotr_untidy %>% 
  gather(key = "Gender", value = "Words", Female, Male)
lotr_tidy

#---- 2.4 Write the tidy data to a delimited file ----

write_csv(lotr_tidy, path = file.path("Chapter 8 Data", "lotr_tidy.csv"))

#---- 2.5 Exercises ----
Female <- read_csv(file.path("Chapter 8 Data", "Female.csv"))
Male <- read_csv(file.path("Chapter 8 Data", "Male.csv"))

(lotr_untidy <- bind_rows(Female, Male))

lotr_tidy <- lotr_untidy %>% 
  gather(key = "Race", value = "Words", Elf, Hobbit, Man) %>% 
  select(Film, Race, Gender, Words)

lotr_tidy %>% 
  group_by(Film) %>% 
  summarise(AllWords = sum(Words))

#---- 2.6 Take home message ----

# Watch out for how untidy data seduces you into working with it more 
# than you should:

# Data optimized for consumption by human eyeballs is attractive, 
# so it’s hard to remember it’s suboptimal for computation. 
# How can something that looks so pretty be so wrong?

# Tidy data often has lots of repetition, which triggers hand-wringing about 
# efficiency and aesthetics. Until you can document a performance problem, 
# keep calm and tidy on.

# Tidying operations are unfamiliar to many of us and we avoid them, 
# subconsciously preferring to faff around with other workarounds that are 
# more familiar.

#------ 3.spread ------
# 主要函数
# unite:通过将字符串粘贴在一起，将多个列合并为一个列.



# 将整洁的数据变乱
library(tidyverse)

lotr_tidy <- read_csv(file.path("Chapter 8 Data", "lotr_tidy.csv"))

lotr_tidy

lotr_tidy %>% 
  spread(key = Race, value = Words)

lotr_tidy %>% 
  spread(key = Gender, value = Words)

lotr_tidy %>% 
  unite(Race_Gender, Race, Gender) %>% 
  spread(key = Race_Gender, value = Words)

#------ 4.tidy-bonus-content ------
# 主要函数
# rbind:按行合并，同bind_rows,但是！！！！！，慎用，慢，占内存！！！
# rbind.list:同样是按照行合并，比rbind好
# file.path:生成文件路径
# lapply:对每个变量执行同样的函数，返回一个列表
# do.call:执行函数的合并
# rbind_all:合并行
# with:感觉该函数用于数据框，可直接饮用列名称了！

#---- 4.1 More about rbind()ing data frames ----
library(tidyverse)

fship <- read.csv(file.path("Chapter 8 Data", "The_Fellowship_Of_The_Ring.csv"))
ttow <- read.csv(file.path("Chapter 8 Data", "The_Two_Towers.csv"))
rking <- read.csv(file.path("Chapter 8 Data", "The_Return_Of_The_King.csv"))  
lotr_untidy <- rbind(fship, ttow, rking)

# ！！！！！！！！！！慎用！！！！！！！！！！

#---- 4.2 Memory efficient row-binding ----
suppressPackageStartupMessages(library(dplyr))
lotr_untidy_2 <- rbind_list(fship, ttow, rking)

str(lotr_untidy)
str(lotr_untidy_2)

lotr_untidy_2$Film <-
  factor(lotr_untidy_2$Film,
         levels = c("The Fellowship Of The Ring", "The Two Towers",
                    "The Return Of The King"))

#---- 4.3 Row-binding a list of data frames ----
lotr_files <- file.path("Chapter 8 Data", c("The_Fellowship_Of_The_Ring.csv",
                                  "The_Two_Towers.csv",
                                  "The_Return_Of_The_King.csv"))
lotr_list <- lapply(lotr_files, read.csv)
str(lotr_list)

# Base R, brute force
lotr_untidy_3 <- rbind(lotr_list[[1]], lotr_list[[2]], lotr_list[[3]])
str(lotr_untidy_3)

# Base R, do.call()
lotr_untidy_4 <- do.call(rbind, lotr_list)
str(lotr_untidy_4)

# dplyr::rbind_all()
lotr_untidy_5 <- rbind_all(lotr_list)
str(lotr_untidy_5)

#---- 4.4 More about gathering variables ----
lotr_untidy

# Base R, brute force
lotr_tidy <-
  with(lotr_untidy,
       data.frame(Film = Film,
                  Race = Race,
                  Words = c(Female, Male),
                  Gender =rep(c("Female", "Male"), each = nrow(lotr_untidy))))
lotr_tidy

# Base R, stack()
lotr_tidy_2 <-
  with(lotr_untidy,
       data.frame(Film = Film,
                  Race = Race,
                  stack(lotr_untidy, c(Female, Male))))
names(lotr_tidy_2) <- c('Film', 'Race', 'Words', 'Gender')
lotr_tidy_2

# tidyr::gather()
library(tidyr)
lotr_tidy_3 <-
  gather(lotr_untidy, key = 'Gender', value = 'Words', Female, Male)
lotr_tidy_3

# reshape2::melt()
library(reshape2)
lotr_tidy_4 <-
  melt(lotr_untidy, measure.vars = c("Female", "Male"), value.name = 'Words')
lotr_tidy_4
