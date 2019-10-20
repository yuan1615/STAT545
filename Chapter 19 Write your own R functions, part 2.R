# 要点

# 主要函数:
# quantile:计算分位数，probs为对应概率
# IQR:计算分位距 0.75-0.25



##### Chapter 19 Write your own R functions, part 2 #####

#------ 19.1 Where were we? Where are we going? ------
# In this part, we generalize max_minus_min function, learn more technical details 
# about R functions, and set default values for some arguments.

#------ 19.2 Load the Gapminder data ------
library(gapminder)

#------ 19.3 Restore our max minus min function ------
mmm <- function(x) {
  stopifnot(is.numeric(x))
  max(x) - min(x)
}

#------ 19.4 Generalize our function to other quantiles ------
# median = 0.5 quantile
# 1st quartile = 0.25 quantile
# 3rd quartile = 0.75 quantile

#------ 19.5 Get something that works, again ------

quantile(gapminder$lifeExp)
quantile(gapminder$lifeExp, probs = 0.5)
median(gapminder$lifeExp)


quantile(gapminder$lifeExp, probs = c(0.25, 0.75))
boxplot(gapminder$lifeExp, plot = FALSE)$stats

the_probs <- c(0.25, 0.75)
the_quantile <- quantile(gapminder$lifeExp, probs = the_probs)
max(the_quantile) - min(the_quantile)

#------ 19.6 Turn the working interactive code into a function, again ------

qdiff1 <- function(x, probs) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x = x, probs = probs)
  max(the_quantiles) - min(the_quantiles)
}

qdiff1(gapminder$lifeExp, probs = c(0.25, 0.75))
IQR(gapminder$lifeExp)

qdiff1(gapminder$lifeExp, probs = c(0, 1))
mmm(gapminder$lifeExp)

#------ 19.7 Argument names: freedom and conventions ------

# 参数的名称可以设置为任何你想要的名称zerus/hera.......
qdiff2 <- function(zeus, hera) {
  stopifnot(is.numeric(zeus))
  the_quantiles <- quantile(x = zeus, probs = hera)
  max(the_quantiles) - min(the_quantiles)
}
qdiff2(zeus = gapminder$lifeExp, hera = 0:1)

# 但是在设置参数名称时，尽可能的使参数名称！有意义!
# 尽量和内置参数的参数名相同.
qdiff1

#------ 19.8 What a function returns ------
# 函数主体最后一行就是返回结果
# 也可以利用return()函数进行返回结果

#------ 19.9 Default values: freedom to NOT specify the arguments ------
# 设置默认参数

qdiff1(gapminder$lifeExp)

qdiff3 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  max(the_quantiles) - min(the_quantiles)
}

qdiff3(gapminder$lifeExp)
mmm(gapminder$lifeExp)
qdiff3(gapminder$lifeExp, c(0.1, 0.9))

#------ 19.10 Check the validity of arguments, again ------
qdiff3(gapminder$lifeExp, c(1, 2))
qdiff3(gapminder$lifeExp, 1)
qdiff3(gapminder$lifeExp, runif(2))

#------ 19.11 Wrap-up and what’s next? ------
qdiff3
# 1.We’ve generalized our first function to take a difference between arbitrary quantiles.
# 2.We’ve specified default values for the probabilities that set the quantiles.


#------ 19.12 Resources ------
# Section on function arguments
# http://adv-r.had.co.nz/Functions.html#function-arguments
# Section on return values
# http://adv-r.had.co.nz/Functions.html#return-values