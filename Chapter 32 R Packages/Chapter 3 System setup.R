# 要点:
# https://r-pkgs.org/setup.html


##### Chapter 3 System setup #####

#------ 3.1 Prepare your system ------

# install.packages(c("devtools", "roxygen2", "testthat", "knitr"))

#------ 3.2 devtools, usethis, and you -------
# 在交互式开发过程中如何模拟安装和加载软件包的示例：

library(devtools)
# load_all()
has_devel()