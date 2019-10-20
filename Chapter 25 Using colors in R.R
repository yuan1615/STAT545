# 要点:
# 主要函数:

# par:设置全局的图形参数 用法:opar <- par(arg = ...) / par(opar)
#     pch为点的形状, = 19为实心圆

# test:Add Text to a Plot, pos代表了上下左右

# colors():获取所有颜色的名称

# ************ ！！！！RColorBrewer:最常用的调色包
# ！！！！！！********* viridis:更强大的调色包 /scale_fill_viridis()
# dichromat色盲调色包


##### Chapter 25 Using colors in R #####

#------ 25.1 Load dplyr and gapminder ------
library(dplyr)
library(gapminder)

#------ 25.2 Change the default plotting symbol to a solid circle ------
opar <- par(pch = 19)  # 

#------ 25.3 Basic color specification and the default palette ------
# 基本颜色规范和默认调色板
jcountry <- c("Central African Republic", "Guinea", "Cote d'Ivoire",
              "India", "Pakistan", "South Africa", "Costa Rica", "Panama")
jdat <- gapminder %>% 
  select(country, continent, year, lifeExp, pop, gdpPercap) %>% 
  filter(country %in%jcountry, year == 2007) %>% 
  droplevels()

jdat

j_xlim <- c(460, 60000)
j_ylim <- c(47, 82)
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     main = "Start your engines ...")

plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = "red", main = 'col = "red"')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = c("blue", "orange"), main = 'col = c("blue", "orange")')

n_c <-  8

plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = paste0('col = 1:', n_c))
with(jdat, text(x = gdpPercap, y = lifeExp, pos = 1))
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = 'the default palette()')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = palette(),
                pos = rep(c(1, 3, 1), c(5, 1, 2))))     

j_colors <- c('chartreuse3', 'cornflowerblue', 'darkgoldenrod1', 'peachpuff3',
              'mediumorchid2', 'turquoise3', 'wheat4', 'slategray2')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_colors, main = 'custom colors!')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = j_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 

#------ 25.4 What colors are available? Ditto for symbols and line types ------
head(colors())
tail(colors())

#------ 25.5 RColorBrewer ------
library(RColorBrewer)
display.brewer.all()

# 连续的：适用于从低到高的事物，其中一个极端令人兴奋而另一个极端无聊，
# 例如p值（相关的转换）和相关性（注意：这里我假设您可能看到的唯一令
# 人兴奋的相关性是正数，即接近1）
# 
# 定性的：非常适合无序的分类事物-例如您的典型因素，例如国家或大洲。
# 注意特殊情况下的“配对”调色板；有用的示例：非实验因素（例如小麦类型）
# 和二元实验因素（例如未处理与已处理）。
# 
# 差异：适用于从“极端和负面”到“极端和正面”的事物，并经历“非极端和无聊”的
# 过程，例如t统计量和z分数以及有符号相关

display.brewer.pal(n = 8, name = 'Dark2')

j_brew_colors <- brewer.pal(n = 8, name = "Dark2")
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_brew_colors, main = 'Dark2 qualitative palette from RColorBrewer')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = j_brew_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 

#------ 25.6 viridis ------

library(ggplot2)
library(viridis)
library(hexbin)
ggplot(data.frame(x = rnorm(10000), y = rnorm(10000)), aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_viridis() + theme_bw()
# 学习 viridis 网址
# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html

#------ 25.7 Hexadecimal RGB color specification ------
brewer.pal(n = 8, name = "Dark2")

# 1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16
# hex	0	1	2	3	4	5	6	7	8	9	A	B	C	D	E	F
# decimal	0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15

#------ 25.8 Alternatives to the RGB color model, especially HCL ------

#HCL：色相/色度/亮度

#------ 25.9 Accommodating color blindness ------

library(dichromat)

#------ 25.10 Clean up ------
par(opar)

# 25.11 Resources