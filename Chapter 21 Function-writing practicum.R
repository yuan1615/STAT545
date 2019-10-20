# 要点
# 主要函数:
# lm:构建线性回归模型
# coef:返回模型的参数
# setNames:设置变量名称


##### Chapter 21 Function-writing practicum #####

#------ 21.1 Overview ------
# 任务:
# 创建函数,计算gapminder中lifeExp与year的线性回归系数
# input: dataframe  output:intercept/slope

#------ 21.2 Load the Gapminder data ------
library(gapminder)
library(ggplot2)
library(dplyr)

#------ 21.3 Get data to practice with ------
j_country <- "France"

(j_dat <- gapminder %>% 
  filter(country == j_country))
  
p <- ggplot(j_dat, aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(method = "lm", se = FALSE)

#------ 21.4 Get some code that works ------

j_fit <- lm(lifeExp ~ year, j_dat)
coef(j_fit)

# 截距为-397：公元0年，法国人平均寿命为-397岁，太不合理了！

j_fit <- lm(lifeExp ~ I(year - 1952), j_dat)
coef(j_fit)

#---- 21.4.1 Sidebar: regression stuff ----
# 不会的查看官方帮助文档
# 结合实际问题进行回归，必须要分析回归得到的系数符合实际情况否！

#------ 21.5 Turn working code into a function ------

le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  coef(the_fit)
}
le_lin_fit(j_dat)  # 返回值的名字不好看.........


le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}
le_lin_fit(j_dat)

#------ 21.6 Test on other data and in a clean workspace ------

j_country <- "Zimbabwe"
(j_dat <- gapminder %>% filter(country == j_country))

p <- ggplot(j_dat, aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(method = "lm", se = FALSE)

le_lin_fit(j_dat)

# 清理工作区再次运行,这样不依赖于其他未知的缓存变量
rm(list = ls())
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}
le_lin_fit(gapminder %>% filter(country == "Zimbabwe"))

#------ 21.7 Are we there yet? ------