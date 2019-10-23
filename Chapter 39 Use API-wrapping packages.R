# 要点

# 公开的API接口
# rebird：获取一些鸟类的信息
# geonames：获取地名
# rplos:获取公共图书馆

##### Chapter 39 Use API-wrapping packages #####

#------ 39.1 Introduction ------

# 四种获取互联网数据的方法
# 
# 单击并下载 -在互联网上以“平面”文件的形式出现，例如CSV，XLS。
# 安装并播放 -有人为其编写了便捷R包的API。
# API查询 -使用未包装的API发布。
# 搜寻 -隐含在HTML网站中。

#------ 39.2 Click-and-Download ------

# downloader::download() 用于SSL。
# curl::curl() 用于SSL。
# httr::GET以这种方式读取的数据需要稍后使用进行解析read.table()。
# rio::import()可以“直接从https://URL 读取多种常用数据格式”。这与以前不是很相似吗？
# 

#------ 39.3 Data supplied on the web -----
# API

#------ 39.4 Install-and-play ------
# 许多常见的Web服务和API已被“包装”，即在它们周围编写了R函数，
#  这些函数将查询发送到服务器并格式化响应。

#---- 39.4.1 Load the tidyverse ----
library(tidyverse)

#---- 39.4.2 Sightings of birds: rebird ----
# rebird是eBird数据库的R接口
library(rebird)

#-- 39.4.2.1 Search birds by geography --

# 需要自己注册API的Key，这里理解就好
# 相当于股票数据Tushare的API接口！

# ebirdregion(loc = "L261851") %>%
# 	head() %>%
# 	kable()

#---- 39.4.3 Searching geographic info: geonames ----
# rOpenSci有一个名为geonames的软件包，用于访问GeoNames API
library(geonames)

# francedata <- countryInfo %>%
# 	filter(countryName == "France")

#---- 39.4.4 Wikipedia searching ----
# 利用维基百科搜索
# rio_english <- GNfindNearbyWikipedia(lat = -22.9083, lng = -43.1964,
# 																		 radius = 20, lang = "en", maxRows = 500)
# rio_portuguese <- GNfindNearbyWikipedia(lat = -22.9083, lng = -43.1964,
# 																				radius = 20, lang = "pt", maxRows = 500)

#---- 39.4.5 Searching the Public Library of Science: rplos ----

library(rplos)