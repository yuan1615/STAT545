# 要点
# Here we discuss common remedial tasks for dealing with date-times.\

# Dates and times chapter from R for Data Science
# https://r4ds.had.co.nz/dates-and-times.html
# 主要函数：
###***************************************************************
# Sys.Date/today: 获取当前的日期
# Sys.time/now():获取现在的时间
###
# readr包中的函数:
# parse_datetime:可以将字符串解析为date/time
# lubridate包中的函数:
# ymd,mdy,dmy,ymd_hms,ymd_hm......解析字符串为date/time
# make_date,make_datetime,将不同部分组合成date/time
# %/%取余的整数部分，%%取余的余数部分
# ends_with("delay"), 可以放到select中筛选以“delay”结尾的变量
# 类似函数有：starts_with()/contains()/matches()/num_range()
# as_datetime/as_date:时间类型之间的相互准换,也可以“Unix Epoch”, 1970-01-01.

###***************************************************************
# 获取datetime的各组成部分函数:
# year(), month(), mday() (day of the month), 
# yday() (day of the year), wday() (day of the week), 
# hour(), minute(), and second()
# month与wday中的参数，label 和 abbr可以控制返回为Jan,Feb/Sunday等内容
#                      locale 设置中英文, week_start 控制了从周几开始计数
# datetime的四舍五入
# floor_date(), round_date(), and ceiling_date()
# datetime修改各组成部分
# year/month/day/......  update可以同时更新好几个组件

###****************************************************************
# 时间的加减除
## duration：
# as.duration:转换为持续时间，秒
# dseconds/dminutes/dhours/ddays/......分别将不同的日期转换为持续时间

## Periods:人类理解的天/周/月等，非持续时间
# seconds/minutes/hours/days......years

## Intervals：
# %--% 指定一个区间

###***************************************************************
# Time zones 时区函数
# Sys.timezone():获取系统时区
# OlsonNames():获取所有时区
# with.tz:修改时区
# 其他函数中tz/tzone一般为修改时区参数
# force.tz:替换时区，创建新的时间日期


##### Chapter 13 Dates and times #####

#------ 13.1 Date-time vectors: where they fit in ------
# 日期时间格式的处理

#------ 13.2 Resources ------
# 这些资源在后续现实中遇到问题是及其有帮助的

# Dates and times chapter from R for Data Science 
# by Hadley Wickham and Garrett Grolemund 
# https://r4ds.had.co.nz/dates-and-times.html

# lubridate 包

#------ 13.3 Load the tidyverse and lubridate ------
library(tidyverse)
library(lubridate)

#------ 13.4 Get your hands on some dates or date-times ------

Sys.Date()
today()
# They both give you something of class Date.
str(Sys.Date())
class(Sys.Date())
str(today())
class(today())

# They both give you something of class POSIXct in R jargon.
Sys.time()
now()

str(Sys.time())
class(Sys.time())
str(now())
class(now())

#------ 13.5 Get date or date-time from character ------
# One of the main ways dates and date-times come into your life:
# https://r4ds.had.co.nz/dates-and-times.html#creating-datetimes#from-strings

#---- 13.5.1 Introduction ----
# Does every year have 365 days? 闰年
# Does every day have 24 hours? 夏令时/冬令时
# Does every minute have 60 seconds? 61秒

#---- 13.5.1.1 Prerequisites ----
# This chapter will focus on the lubridate package
# We will also need nycflights13 for practice data.
library(tidyverse)

library(lubridate)
library(nycflights13)

#---- 13.5.2 Creating date/times ----

# Three types of date/time data
#   1. A date. Tibbles print this as <date>.
#   2. A time within a day. Tibbles print this as <time>.
#   3. A date-time is a date plus a time: it uniquely identifies an instant in time 
#   (typically to the nearest second). Tibbles print this as <dttm>. 
#   Elsewhere in R these are called POSIXct, but I don’t think that’s a very 
#   useful name.

today()  # date
now()  #datetime

# Three ways to create a date/time:

#   1.From a string.
#   2.From individual date-time components.
#   3.From an existing date/time object.

#---- 13.5.2.1 From strings ----
# 可以利用 parse_datetime，将字符串解析为时间类型
# readr包
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

# lubridate包(可以解析字符串，还可以解析数字)
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd(20170131)

ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

ymd(20170131, tz = "UTC")

#---- 13.5.2.2 From individual components ----
# datetime被分到了不同的列
flights %>% 
  select(year, month, day, hour, minute)

# use make_date() for dates, or make_datetime() for date-times
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departue = make_datetime(year, month, day, hour, minute))

# 处理flights中的dep_time/arr_time等time字段，该time需要改为hour/minute格式

make_datetime_100 <- function(year, month, day, time){
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(dep_time = make_datetime_100(year, month, day, dep_time),
         arr_time = make_datetime_100(year, month, day, arr_time),
         sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))
flights_dt

# geom_freqpoly 频率多边形
# 这个图绘制了每一天出现的次数
flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day

# 这个图绘制了每10分钟出现的次数
flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes

#---- 13.5.2.3 From other types ----
# 时间类型之间的转换，date   <---->   datetime
as_datetime(today())
as_date(now())

# “Unix Epoch”, 1970-01-01.
as_datetime(60 * 60 * 10)
as_date(365 * 10 + 2)

#---- 13.5.2.4 Exercises ----
ymd(c("2010-10-10", "bananas"))
?today()  # tzone代表时区，默认为电脑系统的时区

d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014

mdy(d1)
ymd(d2)
dmy(d3)
mdy(d4)
mdy(d5)

#---- 13.5.3 Date-time components ----
# 日期时间的组件

#---- 13.5.3.1 Getting components ----
# year(), month(), mday() (day of the month), 
# yday() (day of the year), wday() (day of the week), 
# hour(), minute(), and second()

datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)
month(datetime)
mday(datetime)  # 一个月中的第几天

yday(datetime)  # 一年中的第几天
wday(datetime)  # 一周中的第几天

month(datetime, label = TRUE, abbr = TRUE, locale = "English")
wday(datetime, label = TRUE, abbr = FALSE, locale = "English")

flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE, locale = "English")) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()

flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>% 
  ggplot(aes(minute, avg_delay)) +
  geom_line()

sched_dep <- flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n())

ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()

ggplot(sched_dep, aes(minute, n)) +
  geom_line()

#---- 13.5.3.2 Rounding ----
# 将日期四舍五入

flights_dt %>% 
  count(week = floor_date(dep_time, "week", week_start = 1)) %>% 
  ggplot(aes(week, n)) +
  geom_line()

#---- 13.5.3.3 Setting components ----
(datetime <- ymd_hms("2016-07-08 12:34:56"))
year(datetime) <- 2020
datetime
month(datetime) <- 01
datetime
hour(datetime) <- hour(datetime) + 1
datetime

update(datetime, year = 2020, month = 2, mday = 2, hour = 2)

ymd("2015-02-01") %>% 
  update(mday = 30)

ymd("2015-02-01") %>% 
  update(hour = 400)

flights_dt %>% 
  mutate(dep_hour = update(dep_time, yday = 1)) %>% 
  ggplot(aes(dep_hour)) +
  geom_freqpoly(binwidth = 300)

#---- 13.5.3.4 Exercises ----
# 1.How does the distribution of flight times within a day 
#   change over the course of the year?

# 从上一幅图可以看出

#---- 13.5.4 Time spans ----
# 时间跨度，时间的加减除法
# Three important classes that represent time spans:
#   1.durations, which represent an exact number of seconds.
#   2.periods, which represent human units like weeks and months.
#   3.intervals, which represent a starting and ending point.

#---- 13.5.4.1 Durations ----
# 以秒代替的持续时间
h_age <- today() - ymd(19791014)
h_age
as.duration(h_age)

dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dyears(1)

tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")
one_pm
one_pm + ddays(1)  ## 这里是因为tzone的原因，一天是23个小时

#---- 13.5.4.2 Periods ----
one_pm
one_pm + days(1)

seconds(15)
minutes(10)
hours(c(12, 24))
days(7)
months(1:6)
weeks(3)
years(1)

10 * (months(6) + days(1))
days(50) + hours(25) + minutes(2)


ymd("2016-01-01") + dyears(1)
ymd("2016-01-01") + years(1)

one_pm + ddays(1)
one_pm + days(1)

# 飞机例子：到达时间小于起飞时间，夜班飞行导致，应该是第二天到达
flights_dt %>% 
  filter(arr_time < dep_time) 

# 加一天
flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight * 1),
    sched_arr_time = sched_arr_time + days(overnight * 1)
  )

flights_dt %>% 
  filter(overnight, arr_time < dep_time) 

#---- 13.5.4.3 Intervals ----

years(1) / days(1)

next_year <- today() + years(1)
(today() %--% next_year) / ddays(1)

(today() %--% next_year) %/% days(1)
(today() %--% (today() + years(1)) / months(1))

#---- 13.5.5 Time zones ----
# 系统时区
Sys.timezone()
# 全部的时区列表
length(OlsonNames())
#
OlsonNames()

(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))
(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland"))

x1 - x2
x1 - x3
# 在R语言中就是显示的不一样，其实是一个数


x4 <- c(x1, x2, x3)
x4
# 修改时区
x4a <- with_tz(x4, tzone = "Australia/Lord_Howe")
x4a
x4a - x4

# Replace time zone to create new date-time

x4b <- force_tz(x4, tzone = "Australia/Lord_Howe")
x4b
x4b - x4

#------ 13.6 Build date or date-time from parts ------
# 13.5.2.2/3

#------ 13.7 Get parts from date or date-time ------
# 13.5.3

#------ 13.8 Arithmetic with date or date-time ------
# 13.5.4

#------ 13.9 Get character from date or date-time ------
# use format()
?format.POSIXct
format(Sys.time(), "%a %b %d %X %Y %Z")