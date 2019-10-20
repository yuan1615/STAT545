# 要点
# 函数功能提高了代码重复利用的功能
# 在构建函数时，应该是  滑板  ------> 多功能汽车

# 主要函数:
# min/max/range:获取向量的最小/最大值
# diff:求差分

# stopifnot: Ensure the Truth of R Expressions
#            放到函数的开头，确保参数输入的准确性；输入的是正确的你想要的逻辑值
#            但是该函数报错的信息返回不友好
# ******** ！！！ ********
# 利用if()...stop()...代替stopifnot,stop()里可以自己定义报错内容
# 构建错误提示指南 https://style.tidyverse.org/error-messages.html


##### Chapter 18 Write your own R functions, part 1 #####

#------ 18.1 What and why? ------
# 编写自己的函数很重要

#------ 18.2 Load the Gapminder data ------
library(gapminder)
str(gapminder)

#------ 18.3 Max - min ------

# Say you’ve got a numeric vector, and you want to compute the difference 
# between its max and min. lifeExp or pop or gdpPercap are great examples 
# of a typical input. You can imagine wanting to get this statistic after 
# we slice up the Gapminder data by year, country, continent, or combinations 
# thereof.

#------ 18.4 Get something that works ------
min(gapminder$lifeExp)
max(gapminder$lifeExp)
range(gapminder$lifeExp)

max(gapminder$lifeExp) - min(gapminder$lifeExp)
with(gapminder, max(lifeExp) - min(lifeExp))
range(gapminder$lifeExp)[2] - range(gapminder$lifeExp)[1]
with(gapminder, range(lifeExp)[2] - range(lifeExp)[1])
diff(range(gapminder$lifeExp))

#---- 18.4.1 Skateboard >> perfectly formed rear-view mirror ----
# 在编写函数时，应该是先能直观的得出结果（先能用），再慢慢的拓展
# 滑板 -------> 后视镜的汽车！

#------ 18.5 Turn the working interactive code into a function ------
max_minus_min <- function(x){
  max(x) - min(x)
}
max_minus_min(gapminder$lifeExp)

#------ 18.6 Test your function ------

#---- 18.6.1 Test on new inputs ----
max_minus_min(1:10)  # test int
max_minus_min(runif(1000))  # test dbl

#---- 18.6.2 Test on real data but different real data ----
max_minus_min(gapminder$pop)
max_minus_min(gapminder$gdpPercap)

#---- 18.6.3 Test on weird stuff ----
# 对其奇怪的东西进行测试

max_minus_min(gapminder)
max_minus_min(gapminder$country)
max_minus_min("eggplants are purple")

#---- 18.6.4 I will scare you now ----
# 函数应该中断计算，但是没有中断
max_minus_min(gapminder[c('lifeExp', 'gdpPercap', 'pop')])  # 数据框被强制转换为了向量

max_minus_min(c(TRUE, TRUE, FALSE, TRUE, TRUE))  # logical转换为了0/1

#------ 18.7 Check the validity of arguments ------
# 检查参数的有效性
#---- 18.7.1 stop if not ----

# stopifnot 里输入的是正确的你想要的逻辑值
mmm <- function(x){
  stopifnot(is.numeric(x))
  max(x) - min(x)
}

mmm(gapminder)
mmm(gapminder$country)
mmm("eggplants are purple")
mmm(gapminder[c('lifeExp', 'gdpPercap', 'pop')])
mmm(c(TRUE, TRUE, FALSE, TRUE, TRUE))

#---- 18.7.2 if then stop ----
mmm2 <- function(x) {
  if(!is.numeric(x)) {
    stop('I am so sorry, but this function only works for numeric input!\n',
         'You have provided an object of class: ', class(x)[1])
  }
  max(x) - min(x)
}
mmm2(gapminder)

# *********** ！！！ ********
# 这里返回了两个有用的报错：
# * 定位到了mmm2函数
# * 期望的输入类与实际的类

#---- 18.7.3 Sidebar: non-programming uses for assertions ----


#------- 18.8 Wrap-up and what’s next? ------
mmm2
# We’ve written our first function.
# We are checking the validity of its input, argument x.
# We’ve done a good amount of informal testing.

#------ 18.9 Resources ------

# assertthat on CRAN and GitHub - the Hadleyverse option
# ensurer on CRAN and GitHub - general purpose, pipe-friendly
# assertr on CRAN and GitHub - explicitly data pipeline oriented
# assertive on CRAN and Bitbucket - rich set of built-in functions