# 要点
# devtools
# Rtools  # 软件
# knitr
# roxygen2
# testthat

# 主要函数:
# old.packages():返回过时的包
# update.packages():更新包


##### Chapter 31 System preparation for package development #####

# 因为开发更高级的Rpackages可能需要编译 C/C++等，所以需要配置环境

#------ 31.1 Update R and RStudio ------

#------ 31.2 Install devtools from CRAN ------

# install.packages("devtools")
library(devtools)

#------ 31.3 Windows: system prep ------

# ******* Rtools ******** 估计是用于编译代码的,就是有C/C++代码的时候

# https://cran.r-project.org/bin/windows/Rtools/

# 安装的时候务必选择编辑系统PATH
# !!!!!select the box for “Edit the system PATH”.!!!!!

find_rtools()

# 31.4 macOS: system prep
# 31.5 Linux: system prep
#------ 31.6 Check system prep ------
has_devel()

#------ 31.7 R packages to help you build yet more R packages ------

# knitr
# roxygen2
# testthat

packageVersion("devtools")
old.packages()

#------ 31.8 Optional: install devtools from GitHub ------
