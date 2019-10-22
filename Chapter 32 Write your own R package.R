# 要点
# https://r-pkgs.org/

# 主要包:
# devtools:创建package的主要包
# usethis:git管理
# tidyverse:整理数据
# fs:系统文件管理

# 主要函数:

# *************************** devtools ******************************
# load_all:加载自己创建的包,功能类似与library
# check:构建并检查一个包，成功后自动清理
# document: Use roxygen to document a package


# *************************** usethis ********************************
# user_git: 初始化为git Repo
# use_r: 创建.R文件到/R目录下,仅仅是创建
# use_mit_license:License a package
#                 MIT: simple and permissive.
# use_testthat: Create tests/初始化测试
# use_test:打开和/或创建一个测试文件
# use_package:声明用了那个其他包的函数
# use_github: Connect a local repo with GitHub
# use_readme_rmd():创建readme文档


# *************************** testthat ******************************
# test:测试开始


# *************************** 其他 **********************************
# exists:查找对象是否存在,
#        example: exists("fbind", where = ".GlobalEnv", inherits = FALSE)



##### Chapter 32 Write your own R package ######

# 程序包将代码，数据，文档和测试捆绑在一起，并且易于与他人共享。

#------ Chapter 1 Introduction ------
# 分享代码、节省时间

#------ Chapter 2 The whole game ------

#---- 2.1 Load devtools and friends ----
library(devtools)
library(tidyverse)
library(fs)
library(testthat)

#---- 2.2 Toy package: foofactors ----

# > Functions to address a specific need, such as helpers to work with factors.
# > Access to established workflows for installation, getting help, and checking 
#   basic quality.
# > Version control and an open development process.
# > This is completely optional in your work, but recommended. You’ll see how 
#   Git and GitHub helps us expose all the intermediate stages of our package.
# > Documentation for individual functions via roxygen2.
# > Unit testing with testthat.
# > Documentation for the package as a whole via an executable README.Rmd.

#---- 2.3 Peek at the finished product ----

# https://github.com/jennybc/foofactors

#---- 2.4 create_package() ----
# 自己定义的目录,最好不要和已有R项目放到一起...
setwd("C:/Users/Xin/Desktop")
create_package("./foofactors")

#---- 2.5 use_git() ----
setwd("./foofactors")
# use_git()

#---- 2.6 Write the first function ----
(a <- factor(c("character", "hits", "your", "eyeballs")))
(b <- factor(c("but", "integer", "where it", "counts")))

c(a, b)

factor(c(as.character(a), as.character(b)))

fbind <- function(a, b) {
  factor(c(as.character(a), as.character(b)))
}
rm(fbind)
#---- 2.7 use_r() ----
use_r("fbind")

#---- 2.8 load_all() ----
load_all()
fbind(a, b)

exists("fbind", where = ".GlobalEnv", inherits = FALSE)
# 全局环境中并没有fbind, load_all类似library功能

#---- 2.9 check() ----
# 当添加一个新的改动之后，最好要检查这个package是否仍然可以正常运行，虽然这看起来很傻

# 在shell中执行的R CMD检查是检查R包是否处于完全工作状态的黄金标准
# check()可以实现
check()

# 发现问题及时解决：0 errors √ | 2 warnings x | 0 notes √
# Non-standard license specification
# Undocumented code objects: 'fbind'

#---- 2.10 Edit DESCRIPTION ----
# DESCRIPTION
# Package: foofactors
# Title: Make Factors Less Aggravating
# Version: 0.0.0.9000
# Authors@R:
#   person("Jane", "Doe", email = "jane@example.com", role = c("aut", "cre"))
# Description: Factors have driven people to extreme measures, like ordering
# custom conference ribbons and laptop stickers to express how HELLNO we
# feel about stringsAsFactors. And yet, sometimes you need them. Can they
# be made less maddening? Let's find out.
# License: What license it uses
# Encoding: UTF-8
# LazyData: true

#---- 2.11 use_mit_license() ----
use_mit_license("Xin Yuan")

#---- 2.12 document() ----
# /man/....Rd存放R具体函数的帮助文件,类似与Latex编辑
# 利用roxygen2创建

# 在fbind.R文件中执行 Ctrl + Alt + Shift + R 或者 Code -- Insert roxygen skeleton
# 插入帮助文档,然后 document()

"
#' Bind two factors
#' 
#' Create a new factor from two existing factors, where the new factor's levels
#' are the union of the levels of the input factors.
#' 
#' @param a factor
#' @param b factor
#' 
#' @return factor
#' @export
#' @examples
#' fbind(iris$Species[c(1, 51, 101)], PlantGrowth$group[c(1, 11, 21)])
"
document()
?fbind

#---- 2.12.1 NAMESPACE changes ----
# document会更具fbind特殊注释中的 @export修改NAMESPACE!
# NAMESPPACE:控制这个包里有哪些函数吧

# 不需要手动整理......

#---- 2.13 check() again ----
check()

#---- 2.14 install() ----
install()

# 测试是否安装成功
library(foofactors)

a <- factor(c("character", "hits", "your", "eyeballs"))
b <- factor(c("but", "integer", "where it", "counts"))

fbind(a, b)

#---- 2.15 use_testthat() ----

use_testthat() # 创建test/仅仅是初始化test

use_test("fbind")
# test_that("fbind() binds factor (or character)", {
#   x <- c("a", "b")
#   x_fact <- factor(x)
#   y <- c("c", "d")
#   z <- factor(c("a", "b", "c", "d"))
#   
#   expect_identical(fbind(x, y), z)
#   expect_identical(fbind(x_fact, y), z)
# })

load_all()
test()

#---- 2.16 use_package() ----

# 您将不可避免地要使用自己程序包中另一个程序包中的函数,
# 这里要声名,调用其他包函数时,需要加两个冒号,如forcats::

use_package("forcats")

# 构建第二个函数:因子频率表
use_r("fcount")

"
#' Make a sorted frequency table for a factor
#'
#' @param x factor
#'
#' @return A tibble
#' @export
#' @examples
#' fcount(iris$Species)
fcount <- function(x) {
  forcats::fct_count(x, sort = TRUE)
}
"

load_all()
fcount(iris$Species)

# Generate the associated help file via document().
document()
?fcount

#---- 2.17 use_github() ----
# Connect a local repo with GitHub
# use_github()

#---- 2.18 use_readme_rmd() ----
use_readme_rmd()


#---- 2.19 The end: check() and install() ----

check()

install()
