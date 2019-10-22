# 要点
# library(devtools)  # 这个是用来创建包的
# library(roxygen2)  # 这个是用来方便添加说明文档的

# 主要函数:
# create: devtools/ Create a package
#       path:如果存在就使用它，不存在就创建它

# document:使用roxygen来记录一个包

# install:加载创建的包

# 一些R语言的基本信息（安装目录/lib目录等）
R.home()
.Library
.libPaths()

##### Chapter 30 Write your first R package #####

## A statistics (etc.) blog by Hilary Parker

#------ 30.1 Writing an R package from scratch ------

#---- Step 0: Packages you will need ----
library(devtools)  # 这个是用来创建包的
library(roxygen2)  # 这个是用来方便添加说明文档的

#---- Step 1: Create your package directory ----
setwd("Chapter 30 Data")
create("ZhouZhou")

#---- Step 2: Add functions ----

# cat_function <- function(love=TRUE){
#   if(love==TRUE){
#     print("I love cats!")
#   }
#   else {
#     print("I am not a cool person.")
#   }
# }

#---- Step 3: Add documentation ----
#' #' A Cat Function
#' #'
#' #' This function allows you to express your love of cats.
#' #' @param love Do you love cats? Defaults to TRUE.
#' #' @keywords cats
#' #' @export
#' #' @examples
#' #' cat_function()
#' 
#' cat_function <- function(love=TRUE){
#'   if(love==TRUE){
#'     print("I love cats!")
#'   }
#'   else {
#'     print("I am not a cool person.")
#'   }
#' }

#---- Step 4: Process your documentation ----
setwd("./ZhouZhou")
document()

#---- Step 5: Install! ----
setwd("..")
install("ZhouZhou")

#---- Step 6: Make the package a GitHub repo ----
# devtools::install_github("yuan1615/ZhouZhou")

# 测试
library(ZhouZhou)
?Who_is_ZZ
Who_is_ZZ()