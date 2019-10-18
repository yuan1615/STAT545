# 要点
# 主要函数：
# charToRaw:解码字符串为16进制的数
# iconv:转换字符串的编码格式, sub参数控制了不能转换的字符
# Encoding:读取或设置字符向量的已声明的编码
# stringi::stri_enc_detect:检测字符的编码格式

##### Chapter 12 Character encoding #####

#------ 12.1 Resources ------
# Strings subsection of data import chapter in R for Data Science 
# https://r4ds.had.co.nz/data-import.html#readr-strings

#------ 12.2 Translating two blog posts from Ruby to R ------


#------ 12.3 What is an encoding? ------

# irb(main):001:0> "hello!".bytes
# => [104, 101, 108, 108, 111, 33]

charToRaw("hello!")
as.integer(charToRaw("hello!"))

# Use a character less common in English:
# 复杂的字
# irb(main):002:0> "hellṏ!".bytes
# => [104, 101, 108, 108, 225, 185, 143, 33]
charToRaw("hellṏ!")
as.integer(charToRaw("hellṏ!"))

# 不同的编码风格
# irb(main):003:0> str = "hellÔ!".encode("ISO-8859-1"); str.encode("UTF-8")
# => "hellÔ!"
# 
# irb(main):004:0> str.bytes
# => [104, 101, 108, 108, 212, 33]

string_latin <- iconv("hellÔ!", from = "UTF-8", to = "Latin1")
string_latin
as.integer(charToRaw(string_latin))

iconv(string_latin, from = "ISO-8859-5", to = "UTF-8")

#!!!!!!!!!!!!!! 字符串居然被窜改了 ！！！！！！！！！！！！
# 当转换为另一个格式，再转换为原始格式的时候，存在字符串被篡改的现象


# 不是所有的字符串都可能用所有的编码格式表示的。

(string <- "hi∑")
Encoding(string)
as.integer(charToRaw(string))
(string_windows <- iconv(string, from = "UTF-8", to = "Windows-1252"))

(string_windows <- iconv(string, from = "UTF-8", to = "Windows-1252", sub = "?"))

#------ 12.4 A three-step process for fixing encoding bugs ------

#---- 12.4.1 Discover which encoding your string is actually in. ---
# 找到字符的编码格式
string <- "hi\x99!"
string
Encoding(string)

stringi::stri_enc_detect(string)

# I find it helpful to scrutinize debugging charts and look for 
# the weird stuff showing up in my text.
# 以上的方法都不太靠谱，直接查找文件中的特殊字符进行对比更好
# UTF-8编码表：http://www.i18nqa.com/debug/utf8-debug.html

#---- 12.4.2 Decide which encoding you want the string to be ----

# *************** 用UTF-8编码格式就好了 ************

#---- 12.4.3 Re-encode your string ----
string_windows <- "hi\x99!"
string_utf8 <- iconv(string_windows, from = "Windows-1252", to = "UTF-8")
Encoding(string_utf8)
string_utf8

#------ 12.5 How to Get From Theyâ€™re to They’re ------

#---- 12.5.1 Multi-byte characters ----
# 多字节字符
# 例子：‘
# irb(main):001:0> "they’re".bytes
# => [116, 104, 101, 121, 226, 128, 153, 114, 101]

string_curly <- "they’re"
charToRaw(string_curly)
as.integer(charToRaw(string_curly))

length(as.integer(charToRaw(string_curly)))
nchar(string_curly)

charToRaw("’")
as.integer(charToRaw("’"))

(string_mis_encoded <- iconv(string_curly, to = "UTF-8", from = "windows-1252"))

#---- 12.5.2 Encoding repair ----
# irb(main):006:0> "theyâ€™re".encode("Windows-1252").force_encoding("UTF-8")
# => "they’re"