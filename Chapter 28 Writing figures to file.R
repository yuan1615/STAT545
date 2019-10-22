# 要点
# 主要函数:
# ggsave:保存具有合理默认值的ggplot(或其他网格对象)
#   参数:
#        filename:文件名
#        plot:图片,默认为最近一次绘图
#        device:文件类型
#        path:文件路径
#        scale:调整绘图中横/纵轴,及图形字、点的大小!!!鸡肋!!!,还要调整长宽
#        width/height，长宽
#        

# theme_grey(base_size = 12):通过这个直接修改图像字的大小,大于12放大文本!

# library(fs):文件处理的包
# file_deleta():文件删除函数, regexp参数为正则匹配的文件名


##### Chapter 28 Writing figures to file #####
library(tidyverse)

#------ 28.1 Step away from the mouse ------
# 不要利用鼠标 Export --> save as Image的功能
# 因为这个时候,源代码和图形程序没有建立任何连接

# fig08_scatterplot-lifeExp-vs-year.pdf
# 这个文件名称提供了几个属性供你找到画图的源代码

# 1.Human-readability / scatterplot-......
# 2.Specificity / fig08
# 3.Machine-readability/ .pdf


#------ 28.3 Graphics devices ------

# 矢量图像基于形状和线条
# Vector examples: PDF, postscript, SVG
#   Pros: re-size gracefully, good for print. SVG is where the web is heading, 
#         though we are not necessarily quite there yet.

# 光栅图像基于像素点
# Raster examples: PNG, JPEG, BMP, GIF
#   Cons: look awful “blown up” … in fact, look awful quite frequently
#   Pros: play very nicely with Microsoft Office products and the web. 
#         Files can be blessedly small!

#------ 28.4 Write figures to file with ggsave() ------

# ggsave("my-awesome-graph.png")

#---- 28.4.1 Passing a plot object to ggsave() ----
p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
# during development, you will uncomment next line to print p to screen
# p
ggsave("fig-io-practice.png", p)

#---- 28.4.2 Scaling ----
# 
library(ggplot2)
library(gapminder)
p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()

p1 <- p + ggtitle("scale = 0.6")
p2 <- p + ggtitle("scale = 2")

ggsave("fig-io-practice-scale-0.6.png", p1, scale = 0.6,
       width = 4.2, height = 3)
ggsave("fig-io-practice-scale-2.png", p2, scale = 2,
       width = 14, height = 10)

p3 <- p + ggtitle("base_size = 20") + theme_grey(base_size = 20)
p4 <- p + ggtitle("base_size = 3") + theme_grey(base_size = 3)

ggsave("fig-io-practice-base-size-20.png", p3)
ggsave("fig-io-practice-base-size-3.png", p4)


#------ 28.5 Write non-ggplot2 figures to file ------
pdf("test-fig-proper.pdf")    # starts writing a PDF to file
plot(1:10)                    # makes the actual plot
dev.off()                     # closes the PDF file

list.files(pattern = "^test-fig*")
#
plot(1:10)
dev.print(pdf, "test-fig-quick-dirty.pdf")    
# copies the plot to a the PDF file
list.files(pattern = "^test-fig*")

#------ 28.6 Preemptive answers to some FAQs ------

#---- 28.6.1 Despair over non-existent or empty figures ----
# 将写入文件程序放入函数时，要显示的打印该图像才可以

# 失败

## implicit print --> no PNG
f_despair <- function() {
  png("test-fig-despair.png")
  p <- ggplot(gapminder,
              aes(x = year, y = lifeExp))
  p + geom_jitter()
  dev.off()    
}
f_despair()

# 成功

## explicit print --> good PNG
f_joy <- function() {
  png("test-fig-joy.png")
  p <- ggplot(gapminder,
              aes(x = year, y = lifeExp))
  p <- p + geom_jitter()
  print(p) ## <-- VERY IMPORTANT!!!
  dev.off()    
}
f_joy() 


#------ 28.6.2 Mysterious empty Rplots.pdf file ------

#------ 28.7 Chunk name determines figure file name ------
# 使用RMarkdown时，块的命名要符合图片！，这样在渲染后产生的文件名才有意义
# ```{r scatterplot-lifeExp-vs-year}
# p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
# p
# ```

#------ 28.8 Clean up ------
library(fs)
file_delete(dir_ls(".", regexp = "fig-io-practice"))
file_delete(dir_ls(".", regexp = "test-fig"))