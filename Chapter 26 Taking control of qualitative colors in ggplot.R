# 要点
# 主要函数:
#

##### Chapter 26 Taking control of qualitative colors in ggplot #####

#------ 26.1 Load packages and prepare the Gapminder data ------

library(ggplot2)
library(dplyr)
library(gapminder)

jdat <- gapminder %>% 
  filter(continent != "Oceania") %>% 
  droplevels() %>% 
  mutate(country = reorder(country, -1 * pop)) %>% 
  arrange(year, country)  

#------ 26.2 Take control of the size and color of points ------
j_year <- 2007

q <- jdat %>% 
  filter(year == j_year) %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  scale_x_log10(limits = c(230, 63000))

q + geom_point()

q + geom_point(pch = 21, size = 8, fill = I("darkorchid1"))

#------ 26.3 Circle area = population ------

q + geom_point(aes(size = pop), pch = 21)
(r <- q +
    geom_point(aes(size = pop), pch = 21, show.legend = FALSE) +
    scale_size_continuous(range = c(1,40)))

#------ 26.4 Circle fill color determined by a factor ------
(r <- r + facet_wrap(~ continent) + ylim(c(39, 87)))
r + aes(fill = continent)

#------ 26.5 Get the color scheme for the countries ------
# gapminder软件包随附用于各大洲和各个国家的调色板

str(country_colors)
head(country_colors)

#------ 26.6 Prepare the color scheme for use with ggplot ------
# 我们将使用scale_fill_manual()，是一系列功能的成员，以自定义离散比例尺。
# 主要论点是values =，这是美学价值的载体-在我们的例子中是填充色

#------ 26.7 Make the ggplot bubble chart ------
r + aes(fill = country) + scale_fill_manual(values = country_colors)

#------ 26.8 All together now ------
j_year <- 2007
jdat %>% 
  filter(year == j_year) %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp, fill = country)) +
  scale_fill_manual(values = country_colors) +
  facet_wrap(~ continent) +
  geom_point(aes(size = pop), pch = 21, show.legend = FALSE) +
  scale_x_log10(limits = c(230, 63000)) +
  scale_size_continuous(range = c(1,40)) + ylim(c(39, 87))
