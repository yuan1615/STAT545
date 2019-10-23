# 要点:
# https://r-pkgs.org/workflows101.html

# 主要函数:
# available:新创建包的命名是否合理
# proj_sitrep():返回项目的各种信息




library(devtools)

##### Chapter 5 Fundamental development workflows #####

#------ 5.1 Create a package ------
# 查看可以使用的R软件包的名称
library(available)
available("doofus")

#---- 5.1.3 Package creation ----
# usethis::create_package():创建包
# File -- New Project -- New Directory -- R Package

#------ 5.2 RStudio Projects ------
# 快捷键
# Alt + Shift + K 或使用“ 帮助”>“键盘快捷键帮助”。

# 返回项目的各种信息
proj_sitrep()

