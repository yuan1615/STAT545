# 要点
# gridExtra包:分面板绘制不同的图形

# 主要函数:
# grid.arrange()/arrangeGrob():将画好的图形放入，然后再排版

# multiplot()：自定义函数

# cowplot包
# Provides a publication-ready theme for ggplot2.
# Helps combine multiple plots into one figure.


##### Chapter 29 Multiple plots on a page #####
library(tidyverse)

#------ 29.1 Faceting is not a panacea ------

# 利用ggplot2的faect...不能实现所有的分面板任务

#------ 29.2 Meet the gridExtra package ------
library(gridExtra)

#------ 29.3 Load gapminder and ggplot2 ------
library(gapminder)
library(ggplot2)

#------ 29.4 Use the arrangeGrob() function and friends ------

p_dens <- ggplot(gapminder, aes(x = gdpPercap)) + geom_density() + scale_x_log10() +
  theme(axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank())
p_scatter <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + scale_x_log10()
#p_both <- arrangeGrob(p_dens, p_scatter, nrow = 2, heights = c(0.35, 0.65))
#print(p_both)
grid.arrange(p_dens, p_scatter, nrow = 2, heights = c(0.35, 0.65))

#------ 29.5 Use the multiplot() function ------

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
p1 <- p2 <- p3 <- p4 <- p_dens

multiplot(p1, p2, p3, p4, cols = 2)

#------ 29.6 Use the cowplot package ------
# cowplot包可以指定主题/可以绘制多个图到一个图中