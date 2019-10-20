# 要点
# 该章节学习github中ggplot2-tutorial,作者:Jenny Bryan
# 网址：https://github.com/jennybc/ggplot2-tutorial.git

# Scatterplots  散点图
# Stripplots  条形图
# Exploring distribution of a quantitative variable  探索定量变量的分布
# Drawing bars  条形图
# Change overall look and feel via themes 通过主题改变整体外观和感觉
# Take control of a qualitative color scheme  控制一个定性的配色方案
# Bubble and line plots, lots of customization  气泡图和线状图，大量的定制

# 主要函数
#********************************************************************
# geom_point():散点图 
#   参数:
#        alpha:设置透明度
#        size：设置大小

# geom_jitter():散点图,在散点图的基础上增加了小幅度随机移动,防止重叠
#   参数:
#        position:设置抖动幅度position_jitter(width/height)

# geom_smooth():拟合曲线
#   参数:
#        lwd:线的粗细
#        se:是否展示置信区间
#        method:选择拟合曲线的方法,lm等

# geom_line:折线图
#   参数:
#        lwd:线的粗细
#        show.legend:是否展示图例

# geom_bin2d: 2维箱计数的热图

# geom_barplot:箱线图
#   参数:
#        outlier.colour:设置界外点的颜色
#        

# geom_histogram:直方图
#   参数:
#        binwidth:箱子的宽度
#        aes(fill):不同的因子变量
#        position:位置
# geom_freqpoly:折线直方图
# geom_density:密度图(直方图的平滑)adjust:平滑参数/alpha:透明度

# geom_violin:小提琴图
#   参数:
#        aes(group = )

# geom_bar:柱状图
#   参数:
#        width:柱状图的宽度
#        stat = "identity":根据已经统计好的频数绘制bar



# stat_summary:叠加统计量
#   参数:
#        fun.y:需要叠加的统计量,如median
#        colour/geom = point/size......

# coord_flip: x与y翻转的笛卡尔坐标
# 



#********************************************************************
# theme_grey():默认主题
# theme_bw: ggplot2主题 The classic dark-on-light ggplot2 theme.

# library(ggthemes):github上提供的一些主题......
# theme_calc()/theme_economist()/theme_economist_white()/theme_few()
# theme_gdocs()/theme_tufte()/theme_wsj()

# facet_wrap:分面板绘图
#    ~...
#   参数:
#        scales:x/y轴是否应该标识,free_x为不标识


# scale_x_log10:将x轴的坐标取对数
# scale_color_manual:将因子映射到颜色
# scale_size_continuous(range=c(1,40)):控制绘图点的大小

# theme:修改主题的组件
#   参数: 忒多了也！！！！！
#        strip.text:设置面板字体的大小等...

# labs:修改轴、图例和情节标签
# ggtitle:增加标题
# 

# ggsave:保存图片,建议为pdf格式,可以直接写入latex

# brewer.pal: 创建颜色参数
#   参数:
#        n:需要创建的颜色个数
#        name:掉色版名称


##### Chapter 23 ggplot2 tutorial #####

#------ 23.1 gapminder-ggplot2-scatterplot.r ------
library(tidyverse)
library(gapminder)
library(ggthemes)  # 主题包
library(RColorBrewer) # 调色包
gapminder

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp))

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

p <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) # just initializes
# scatterplot
p + geom_point()

# log transformation ... quick and dirty
ggplot(gapminder, aes(x = log10(gdpPercap), y = lifeExp)) +
  geom_point()

# a better way to log transform
p + geom_point() + scale_x_log10()

p <- p + scale_x_log10()
p + geom_point(aes(color = continent))

## add summary(p)!
plot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() + scale_x_log10() # in full detail, up to now

p + geom_point(alpha = (1/3), size = 3)

# add a fitted curve or line

p + geom_point() + geom_smooth()

p + geom_point() + geom_smooth(lwd = 3, se = FALSE)

p + geom_point() + geom_smooth(lwd = 3, se = FALSE, method = "lm")

p + aes(color = continent) + geom_point() +
  geom_smooth(lwd = 3, se = FALSE)

# 分面板绘图
p + geom_point(alpha = (1/3), size = 3) +
  facet_wrap(~ continent)

p + geom_point(alpha = (1/3), size = 3) +
  facet_wrap(~ continent) +
  geom_smooth(lwd = 2, se = FALSE)

ggplot(gapminder, aes(x = year, y = lifeExp,
                      color = continent)) +
  geom_jitter(alpha = 1/3, size = 3)

##
ggplot(gapminder, aes(x = year, y = lifeExp,
                      color = continent)) +
  facet_wrap(~ continent, scales = "free_x") +
  geom_jitter(alpha = 1/3, size = 3) +
  scale_color_manual(values = continent_colors)

##
ggplot(subset(gapminder, continent != "Oceania"),
       aes(x = year, y = lifeExp, group = country, color = country)) +
  geom_line(lwd = 1, show.legend = FALSE) + facet_wrap(~ continent) +
  scale_color_manual(values = country_colors) +
  #scale_color_brewer()+
  theme_bw() + theme(strip.text = element_text(size = rel(1.1)))

##
ggplot(gapminder, aes(x = year, y = lifeExp,
                      color = continent)) +
  facet_wrap(~ continent, scales = "free_x") +
  geom_jitter(alpha = 1/3, size = 3) +
  scale_color_manual(values = continent_colors) +
  geom_smooth(lwd = 2)

jc <- "Cambodia"
gapminder %>% 
  filter(country == jc) %>% 
  ggplot(aes(x = year, y = lifeExp)) +
  labs(title = jc) +
  geom_line()

rwanda <- gapminder %>%
  filter(country == "Rwanda")
p <- ggplot(rwanda, aes(x = year, y = lifeExp)) +
  labs(title = "Rwanda") +
  geom_line()
print(p)

ggsave(file.path("Chapter 23 Data", "rwanda.pdf"), plot = p)


(y <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_point())

y + facet_wrap(~ continent)

y + geom_smooth(se = FALSE, lwd = 2) +
  geom_smooth(se = FALSE, method ="lm", color = "orange", lwd = 2)

y + geom_smooth(se = FALSE, lwd = 2) +
  facet_wrap(~ continent)

y

y + facet_wrap(~ continent) + geom_line() # uh, no

y + facet_wrap(~ continent) + geom_line(aes(group = country)) # yes!

y + facet_wrap(~ continent) + geom_line(aes(group = country)) +
  geom_smooth(se = FALSE, lwd = 2) 

ggplot(subset(gapminder, country == "Zimbabwe"),
       aes(x = year, y = lifeExp)) + geom_line() + geom_point()

ggplot(gapminder %>% filter(country == "Zimbabwe"),
       aes(x = year, y = lifeExp)) + geom_line() + geom_point()

jCountries <- c("Canada", "Rwanda", "Cambodia", "Mexico")
ggplot(subset(gapminder, country %in% jCountries),
       aes(x = year, y = lifeExp, color = country)) + geom_line() + geom_point()

ggplot(subset(gapminder, country %in% jCountries),
       aes(x = year, y = lifeExp, color = reorder(country, -1 * lifeExp, max))) +
  geom_line() + geom_point()

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  scale_x_log10() + geom_bin2d()

#------ 23.2 gapminder-ggplot2-stripplot ------

ggplot(gapminder, aes(x = continent, y = lifeExp)) + geom_point()
ggplot(gapminder, aes(x = continent, y = lifeExp)) + geom_jitter()

ggplot(gapminder, aes(x = continent, y = lifeExp)) + 
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4)

ggplot(gapminder, aes(x = continent, y = lifeExp)) + geom_boxplot()

ggplot(gapminder, aes(x = continent, y = lifeExp)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4)

ggplot(gapminder, aes(x = continent, y = lifeExp)) + 
  geom_jitter(position = position_jitter(width = 0.1), alpha = 1/4) +
  stat_summary(fun.y = median, colour = "red", geom = "point", size = 5)

ggplot(gapminder, aes(reorder(x = continent, lifeExp), y = lifeExp)) + 
  geom_jitter(position = position_jitter(width = 0.1), alpha = 1/4) +
  stat_summary(fun.y = median, colour = "red", geom = "point", size = 5)

#------ 23.3 gapminder-ggplot2-univariate-quantitative ------

# histogram 直方图

ggplot(gapminder, aes(x = lifeExp)) +
  geom_histogram()

ggplot(gapminder, aes(x = lifeExp)) +
  geom_histogram(binwidth = 1)

ggplot(gapminder, aes(x = lifeExp, fill = continent)) +
  geom_histogram()

ggplot(gapminder, aes(x = lifeExp, fill = continent)) +
  geom_histogram(position = "identity")

ggplot(gapminder, aes(x = lifeExp, color = continent)) +
  geom_freqpoly()

ggplot(gapminder, aes(x = lifeExp)) + geom_density()

ggplot(gapminder, aes(x = lifeExp)) + geom_density(adjust = 1)
ggplot(gapminder, aes(x = lifeExp)) + geom_density(adjust = 0.2)

ggplot(gapminder, aes(x = lifeExp, color = continent)) + geom_density()
ggplot(gapminder, aes(x = lifeExp, fill = continent)) +
  geom_density(alpha = 0.2)

ggplot(subset(gapminder, continent != "Oceania"),
       aes(x = lifeExp, fill = continent)) + geom_density(alpha = 0.2)

ggplot(gapminder, aes(x = lifeExp)) + geom_density() + facet_wrap(~ continent)

ggplot(subset(gapminder, continent != "Oceania"),
       aes(x = lifeExp, fill = continent)) + geom_histogram() +
  facet_grid(continent ~ .)

ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_boxplot()

ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_boxplot(aes(group = year))

ggplot(gapminder, aes(x = year, y = lifeExp)) +
  geom_violin(aes(group = year)) +
  geom_jitter(alpha = 1/4) +
  geom_smooth(se = FALSE)

#------ 23.4 gapminder-ggplot2-univariate-factor ------

table(gapminder$continent)

ggplot(gapminder, aes(x = continent)) + geom_bar()

# 重新排序因素
p <- ggplot(gapminder, aes(x = reorder(continent, continent, length)))
p + geom_bar()

p + geom_bar() + coord_flip()

p + geom_bar(width = 0.05) + coord_flip()

(continent_freq <- gapminder %>% count(continent))

ggplot(continent_freq, aes(x = continent)) + geom_bar()

ggplot(continent_freq, aes(x = continent, y = n)) + geom_bar(stat = "identity")

#------ 23.5 gapminder-ggplot2-themes ------
p <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp))
p <- p + scale_x_log10()
p <- p + aes(color = continent) + geom_point() + 
  geom_smooth(lwd = 3, se = FALSE)
p

p + ggtitle("Life expectancy over time by continent")

p + theme_calc() + ggtitle("ggthemes::theme_calc()")
p + theme_economist() + ggtitle("ggthemes::theme_economist()")
p + theme_economist_white() + ggtitle("ggthemes::theme_economist_white()")
p + theme_few() + ggtitle("ggthemes::theme_few()")
p + theme_gdocs() + ggtitle("ggthemes::theme_gdocs()")
p + theme_tufte() + ggtitle("ggthemes::theme_tufte()")
p + theme_wsj() + ggtitle("ggthemes::theme_wsj()")

#------ 23.6 gapminder-ggplot2-colors -----
jCountries <- c("Canada", "Rwanda", "Cambodia", "Mexico")
x <- droplevels(subset(gapminder, country %in% jCountries))
ggplot(x, aes(x = year, y = lifeExp, color = country)) +
  geom_line() + geom_point()

x <- transform(x, country = reorder(country, -1 * lifeExp, max))
ggplot(x, aes(x = year, y = lifeExp, color = country)) +
  geom_line() + geom_point()

# look at the RColorBrewer color palettes
display.brewer.all()

# focus on the qualitative palettes
display.brewer.all(type = "qual")

# pick some colors
jColors = brewer.pal(n = 8, "Dark2")[seq_len(nlevels(x$country))]
names(jColors) <- levels(x$country)
ggplot(x, aes(x = year, y = lifeExp, color = country)) +
  geom_line() + geom_point() +
  scale_color_manual(values = jColors)

# 不好看的颜色
kColors = c("darkorange2", "deeppink3", "lawngreen", "peachpuff4")
names(kColors) <- levels(x$country)
ggplot(x, aes(x = year, y = lifeExp, color = country)) +
  geom_line() + geom_point() +
  scale_color_manual(values = kColors)

#------ 23.7 gapminder-ggplot2-shock-and-awe ------

gapminder <- droplevels(subset(gapminder, continent != "Oceania"))
head(country_colors)

jYear <- 2007 # this can obviously be changed
jPch <- 21
jDarkGray <- 'grey20'
jXlim <- c(150, 115000)
jYlim <- c(16, 100)

ggplot(subset(gapminder, year == jYear),
       aes(x = gdpPercap, y = lifeExp)) +
  scale_x_log10(limits = jXlim) + ylim(jYlim) +
  geom_point(aes(size = sqrt(pop/pi)), pch = jPch, color = jDarkGray,
             show_guide = FALSE) + 
  scale_size_continuous(range=c(1,40)) +
  facet_wrap(~ continent) + coord_fixed(ratio = 1/43) +
  aes(fill = country) + scale_fill_manual(values = country_colors) +
  theme_bw() + theme(strip.text = element_text(size = rel(1.1)))


ggplot(gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(lwd = 1, show_guide = FALSE) + facet_wrap(~ continent) +
  aes(color = country) + scale_color_manual(values = country_colors) +
  theme_bw() + theme(strip.text = element_text(size = rel(1.1)))

