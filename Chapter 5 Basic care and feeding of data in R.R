# 要点：
# 数据格式tibbel
# 常用函数：
# str
# head, tail, as_tibble,
# names, ncol, length, dim, nrow
# summary
# plot, hist
# class, levels, nlevels

##### Chapter 5 Basic care and feeding of data in R #####
#------ 5.1 Buckle your seatbelt ------
getwd()
rm(list = ls())

#------ 5.2 Data frames are awesome ------
# tibble

#------ 5.3 Get the Gapminder data ------
library(gapminder)

#------ 5.4 Meet the gapminder data frame or “tibble” ------
str(gapminder)

library(tidyverse)
class(gapminder)
gapminder

head(gapminder)
tail(gapminder)

as_tibble(iris)

names(gapminder)
ncol(gapminder)
length(gapminder)
dim(gapminder)
nrow(gapminder)

summary(gapminder)

plot(lifeExp ~ year, gapminder)
plot(lifeExp ~ gdpPercap, gapminder)
plot(lifeExp ~ log(gdpPercap), gapminder)

#------ 5.5 Look at the variables inside a data frame ------
head(gapminder$lifeExp)
summary(gapminder$lifeExp)
hist(gapminder$lifeExp)

summary(gapminder$year)
table(gapminder$year)

# factor
class(gapminder$continent)
summary(gapminder$continent)
levels(gapminder$continent)
nlevels(gapminder$continent)

table(gapminder$continent)
barplot(table(gapminder$continent))

## we exploit the fact that ggplot2 was installed and loaded via the tidyverse
p <- ggplot(filter(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot
p + geom_point(aes(color = continent)) # map continent to color
p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE)
#> `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) +
  geom_smooth(lwd = 1.5, se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'

#------ 5.6 Recap ------
