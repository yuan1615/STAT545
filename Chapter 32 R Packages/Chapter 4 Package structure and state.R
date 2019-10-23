# 要点
# https://r-pkgs.org/package-structure-state.html
# 主要函数:

##### Chapter 4 Package structure and state #####

#------ 4.1 Package states ------
# R包的5个状态
# five states an R package

# source
# bundled
# binary
# installed
# in-memory

#------ 4.2 Source package ------
# 就是自己create()之后的那些文件,包含了 /R中的.R文件及DESCRIPTIONd等


#------ 4.3 Bundled package ------
# 把Source package 包压缩为单个文件, 后缀为.tar.gz 文件
# devtools::build()可以实现

#------ 4.4 Binary package ------
# Windows二进制软件包以结尾.zip
# devtools::build(binary = TRUE)

#------ 4.5 Installed package ------


#------ 4.6 In-memory package ------

#------ 4.7 Package libraries ------
.libPaths()

lapply(.libPaths(), list.dirs, recursive = FALSE, full.names = FALSE)
