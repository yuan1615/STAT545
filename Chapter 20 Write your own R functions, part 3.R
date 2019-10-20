# 要点

# 主要参数:
# na.rm = TRUE 可以删除NA，然后进行计算
# ...参数: ellipsis,详情擦好看ellipsis包，以及
# https://principles.tidyverse.org/dots-position.html

# testthat包:用于正式测试自己开发的函数，尤其是自己开发包时！
# https://testthat.r-lib.org/
# test_that可以进行整个包的自动化单元测试

##### Chapter 20 Write your own R functions, part 3 #####

#------ 20.1 Where were we? Where are we going? ------
# In this part, we tackle NAs, the special argument ... and formal testing.
# NAs/特殊参数/正式测试

#------ 20.2 Load the Gapminder data ------
library(gapminder)

#------ 20.3 Restore our max minus min function ------
# baseline:
qdiff3 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  max(the_quantiles) - min(the_quantiles)
}

#------ 20.4 Be proactive about NAs ------
# !!!!!!!  NA  !!!!!!!
# In real life, missing data will make your life a living hell.

z <- gapminder$lifeExp
z[3] <- NA
quantile(gapminder$lifeExp)
quantile(z)
quantile(z, na.rm = TRUE)

qdiff4 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = TRUE)
  max(the_quantiles) - min(the_quantiles)
}
qdiff4(gapminder$lifeExp)
qdiff4(z)

# qdiff4 是可行的，但是将na.rm参数=TRUE内置到了函数中，这是不可取的，
#       因为这样的话，用户不能这是为FALSE了，应该将na.rm设置为参数


qdiff5 <- function(x, probs = c(0, 1), na.rm = TRUE) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = na.rm)
  max(the_quantiles) - min(the_quantiles)
}
qdiff5(gapminder$lifeExp)
qdiff5(z)
qdiff5(z, na.rm = FALSE)

#------ 20.5 The useful but mysterious ... argument ------
# ...是参数 ellipsis

qdiff6 <- function(x, probs = c(0, 1), na.rm = TRUE, ...) {
  the_quantiles <- quantile(x = x, probs = probs, na.rm = na.rm, ...)
  max(the_quantiles) - min(the_quantiles)
}

set.seed(1234)
z <- rnorm(10)
quantile(z, type = 1)
quantile(z, type = 4)
all.equal(quantile(z, type = 1), quantile(z, type = 4))

qdiff6(z, probs = c(0.25, 0.75), type = 1)
qdiff6(z, probs = c(0.25, 0.75), type = 4)

#------ 20.6 Use testthat for formal unit tests ------

# test_that
library(testthat)

test_that('invalid args are detected', {
  expect_error(qdiff6("eggplants are purple"))
  expect_error(qdiff6(iris))
})

test_that('NA handling works', {
  expect_error(qdiff6(c(1:5, NA), na.rm = FALSE))
  expect_equal(qdiff6(c(1:5, NA)), 4)
})

qdiff_no_NA <- function(x, probs = c(0, 1)) {
  the_quantiles <- quantile(x = x, probs = probs)
  max(the_quantiles) - min(the_quantiles)
}

test_that('NA handling works', {
  expect_that(qdiff_no_NA(c(1:5, NA)), equals(4))
})

#------ 20.7 Resources ------

# https://r-pkgs.org/tests.html