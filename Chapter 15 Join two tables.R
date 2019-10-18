# 要点

# 主要函数:
# inner_join(x, y):返回x中所有与y匹配的行，以及x和y中的所有列.
#                  如果x和y之间有多个匹配项，必须所有匹配项均匹配上才返回该行.
#                  mutate连接

# semi_join(x, y):返回x中所有与y匹配的行，只保留x中的列.
#                 filter连接

# left_join(x, y):返回x的所有行，以及x和y的所有列.
#                 mutate连接

# anti_join(x, y):返回x中所有在y中没有匹配值的行，仅保留x中的列.
#                 filter连接,与semi_join相反


# full_join(x, y):返回x和y的所有行和所有列.
#                 如果没有匹配的值，则返回缺失值的NA.
#                 mutate连接



##### Chapter 15 Join two tables #####

#------ 15.1 Why the cheatsheet ------

# The Relational data chapter in R for Data Science
# https://r4ds.had.co.nz/relational-data.html

#------ 15.2 The data ------
# Working with two small data frames: 
#  1.superheroes
#  2.publishers
library(tidyverse)

superheroes <- tibble::tribble(
  ~name, ~alignment,  ~gender,          ~publisher,   
  "Magneto",      "bad",   "male",            "Marvel",
  "Storm",     "good", "female",            "Marvel",
  "Mystique",      "bad", "female",            "Marvel",
  "Batman",     "good",   "male",                "DC",
  "Joker",      "bad",   "male",                "DC",
  "Catwoman",      "bad", "female",                "DC",
  "Hellboy",     "good",   "male", "Dark Horse Comics"
)

publishers <- tibble::tribble(
  ~publisher, ~yr_founded,
  "DC",       1934L,
  "Marvel",       1939L,
  "Image",       1992L
)

#------ 15.3 inner_join(superheroes, publishers) ------

(ijsp <- inner_join(superheroes, publishers))

#------ 15.4 semi_join(superheroes, publishers) ------

(sjsp <- semi_join(superheroes, publishers))

#------ 15.5 left_join(superheroes, publishers) ------

(ljsp <- left_join(superheroes, publishers))

#------ 15.6 anti_join(superheroes, publishers) ------

(ajsp <- anti_join(superheroes, publishers))

#------ 15.7 inner_join(publishers, superheroes) ------

(ijps <- inner_join(publishers, superheroes))

#------ 15.8 semi_join(publishers, superheroes) ------

(sjps <- semi_join(x = publishers, y = superheroes))

#------ 15.9 left_join(publishers, superheroes) ------

(ljps <- left_join(publishers, superheroes))

#------ 15.10 anti_join(publishers, superheroes) ------

(ajps <- anti_join(publishers, superheroes))

#------ 15.11 full_join(superheroes, publishers) ------

(fjsp <- full_join(superheroes, publishers))
