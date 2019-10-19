# 要点

# 主要函数:
# vector:创建向量，其中mode参数可以控制类型，如numeric......
# seq_along:类似与seq，参数along.with为从这个参数中取长度
# identical:测试对象是否完全相等
# c():常用的向合并参数
# LENTTERS:26个大写字母，letters/month.abb/month.name/pi均为内置常数
# I:可以保护character不被转换成factor
# outer:外积运算，可以定义任意的FUN，例如paste都可以进行外积
# Matrix中设置drop=TRUE可以保证不自动降为vector
# grep:Pattern Matching and Replacement,正则表达式匹配，可以用于索引列
# matrix():构建矩阵时,byrow=TRUE可以控制按行,dimnames可以设置矩阵行列名称




##### Chapter 17 R objects and indexing #####

#------ 17.1 Vectors are everywhere ------
# R软件的基本原始是向量vector，矢量是向量的一个特殊形式（length=1）
# 通过[]进行向量修改
x <- 3 * 4
x
is.vector(x)
length(x)
x[2] <- 100
x
x[5] <- 3
x
x[11]
x[0]

# 向量化计算
x <- 1:4

y <- x^2

# for 循环
z <- vector(mode = mode(x), length = length(x))
for(i in seq_along(z)){
  z[i] <- x[i]^2
}

identical(y, z)

# 正态分布的均值与方差参数都可能是向量
set.seed(1999)
rnorm(5, mean = 10^(1:5))
round(rnorm(5, sd = 10^(0:4)), 2)

# 常用的向合并参数:c()
str(c("hello", "world"))
str(c(1:3, 100, 150))

# 向量中的所有元素必须是同类型的，即numeric,character......
# 两个向量类型如果不同，合并时会强制向低等级类型准换
(x <- c("cabbage", pi, TRUE, 4.3))
str(x)
length(x)
mode(x)
class(x)
typeof(x)

# 最重要的类型有 logical/nueric/character
n <- 8
set.seed(1)
(w <- round(rnorm(n), 2)) # numeric floating point
(x <- 1:n) # numeric integer

(y <- LETTERS[1:n]) # character
(z <- runif(n) > 0.3) # logical

#------ 17.2 Indexing a vector ------

# logical vector: keep elements associated with TRUE’s, ditch the FALSE’s
# vector of positive integers: specifying the keepers
# vector of negative integers: specifying the losers
# character vector: naming the keepers

w
names(w) <- letters[seq_along(w)]
w

w < 0
which(w < 0)  # logical vector
w[w < 0]

seq(from = 1, to = length(w), by = 2)
w[seq(from = 1, to = length(w), by = 2)]  # positive integers

w[-c(2, 5)]  # negative integers

w[c("c", "a", "f")]  # naming the keepers

#------ 17.3 lists hold just about anything ------
# 列表可以容纳任何内容，很重要

# 数据框是特殊的列表
# 好多模型的结果以列表的形式返回

(a <- list("cabbage", pi, TRUE, 4.3))
str(a)
length(a)
mode(a)
class(a)

names(a)
names(a) <- c("veg", "dessert", "myAim", "number")
a

a <- list(veg = "cabbage", dessert = pi, myAim = TRUE, number = 4.3)
names(a)


(a <- list(veg = c("cabbage", "eggplant"),
           tNum = c(pi, exp(1), sqrt(2)),
           myAim = TRUE,
           joeNum = 2:6))

str(a)
length(a)
mode(a)
class(a)

# 获取列表中元素
a[[2]]

a$myAim
str(a$myAim)

a[["tNum"]]
str(a[["tNum"]])

iWantThis <- "joeNum"

a[[iWantThis]]

a[[c("joeNum", "veg")]]  # 不能同时获得两个元素

# # 获取列表中的列表

names(a)

a[c("tNum", "veg")]
str(a[c("tNum", "veg")])

a["veg"]
str(a["veg"])
length(a["veg"])
length(a["veg"][[1]])

#------ 17.4 Creating a data.frame explicitly ------

n <- 8
set.seed(1)
(jDat <- data.frame(w = round(rnorm(n), 2),
                    x = 1:n,
                    y = I(LETTERS[1:n]),
                    z = runif(n) > 0.3,
                    v = rep(LETTERS[9:12], each = 2)))
str(jDat)
mode(jDat)
class(jDat)

is.list(jDat) # data.frames are lists
jDat[[5]] # this works but I prefer ...
jDat$v # using dollar sign and name, when possible

jDat[c("x", "z")] # get multiple variables
str(jDat[c("x", "z")]) # returns a data.frame

identical(subset(jDat, select = c(x, z)), jDat[c("x", "z")])

# 当列表中个列的长度相同时，可以利用as.data.frame将列表转换为数据框
(qDat <- list(w = round(rnorm(n), 2),
              x = 1:(n-1), ## <-- LOOK HERE! I MADE THIS VECTOR SHORTER!
              y = I(LETTERS[1:n])))
as.data.frame(qDat)
qDat$x <- 1:n ## fix the short variable x
(qDat <- as.data.frame(qDat)) ## we're back in business

#------ 17.5 Indexing arrays, e.g. matrices ------
# 矩阵是向量vector的更一般化形式

jMat <- outer(as.character(1:4), as.character(1:4),
              function(x, y) {
                paste0('x', x, y)
              })
jMat

str(jMat)
class(jMat)
mode(jMat)
dim(jMat)
nrow(jMat)
ncol(jMat)
length(jMat)
rownames(jMat)

rownames(jMat) <- paste0("row", seq_len(nrow(jMat)))
colnames(jMat) <- paste0("col", seq_len(ncol(jMat)))
dimnames(jMat)

# 矩阵索引
jMat[2, 3]

jMat[2, ]
is.vector(jMat[2, ])

jMat[, 3, drop = FALSE]
dim(jMat[, 3, drop = FALSE])

jMat[c("row1", "row4"), c("col2", "col3")]
jMat[-c(2, 3), c(TRUE, TRUE, FALSE, FALSE)]

# 矩阵实质是 列 优先的向量，可以按列堆叠起来索引
jMat[7]
jMat

jMat[1, grepl("[24]", colnames(jMat))]

jMat["row1", 2:3] <- c("HEY!", "THIS IS NUTS!")
jMat

# 同时，矩阵还可以为“高等代数”中的数学矩阵，进行数学矩阵的各种运行，例如%*%......

#------ 17.6 Creating arrays, e.g. matrices ------
# 创建矩阵的三种方法
# 1.Filling a matrix with a vector
# 2.Glueing vectors together as rows or columns
# 3.Conversion of a data.frame

# 1.
matrix(1:15, nrow = 5)
matrix("yo!", nrow = 3, ncol = 6)
matrix(c("yo!", "foo?"), nrow = 3, ncol = 6)

matrix(1:15, nrow = 5, byrow = TRUE)
matrix(1:15, nrow = 5,
       dimnames = list(paste0("row", 1:5),
                       paste0("col", 1:3)))

# 2.
vec1 <- 5:1
vec2 <- 2^(1:5)
cbind(vec1, vec2)
rbind(vec1, vec2)

# 3.
vecDat <- data.frame(vec1 = 5:1,
                     vec2 = 2^(1:5))
str(vecDat)
vecMat <- as.matrix(vecDat)
str(vecMat)


multiDat <- data.frame(vec1 = 5:1,
                       vec2 = paste0("hi", 1:5))  # vec2变成了因子
str(multiDat)

(multiMat <- as.matrix(multiDat))  # 都将为了character
str(multiMat)

#------ 17.7 Putting it all together…implications for data.frames ------
# 数据框列表样式索引
jDat
jDat$z
iWantThis <- "z"
jDat[[iWantThis]]

# 数据框矢量样式索引
jDat["y"]
iWantThis <- c("w", "y")
jDat[iWantThis]

# 数据框矩阵样式索引
jDat[, "y"]
jDat[, "y", drop = FALSE]
jDat[c(2, 4, 7), c(1, 4)] # awful and arbitrary but syntax works
jDat[jDat$z, ]


#------ 17.8 Table of atomic R object flavors ------


# +-----------+---------------+-----------+-----------+
#   | "flavor"  | type reported | mode()    | class()   |
#   |           | by typeof()   |           |           |
#   +===========+===============+===========+===========+
#   | character | character     | character | character |
#   +-----------+---------------+-----------+-----------+
#   | logical   | logical       | logical   | logical   |
#   +-----------+---------------+-----------+-----------+
#   | numeric   | integer       | numeric   | integer   |
#   |           | or double     |           | or double |
#   +-----------+---------------+-----------+-----------+
#   | factor    | integer       | numeric   | factor    |
#   +-----------+---------------+-----------+-----------+