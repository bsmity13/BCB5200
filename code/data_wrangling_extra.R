# Additional topics from the data wrangling class

# Brief aside on conflicts ----
# When you type the name of a function, R has to find the
# code that defines it.
# It does that by following a search path.
# The function "search()" tells you the order it looks in.
search()
# The last package loaded gets priority
library(broom)
search()
# You can also specifically ask for R to look in a package's 
# namespace for a function.
# So, stats::filter() is masked by dplyr::filter
# If I type filter(), the search path will return dplyr::filter().
# But I could instead type stats::filter().

# Brief aside on functions ----
# Functions do something
# The way you can tell that an object in R is a function
# is that it is followed by parentheses.
# `blah()` is a function
# Functions can accept arguments, which are parameters that
# affect the function's behavior. In R, those arguments
# go inside the parentheses.
# Question: why are there sometimes no arguments inside the
# parentheses?
# Answer 1: there are no arguments.
hello <- function() {
  print("Hello world!")
}
hello()
# Answer 2: all the arguments have defaults.
add2 <- function(a = 10, b = 15) {
  return(a + b)
}
add2(3, 5)
add2()
# If you don't include the parentheses, it won't execute
# the function.
add2
# You can use this to print the source code for any function
dplyr::filter

add2(a = 3, b = 5)
add2(a=3, b=5)

# Another aside on assignment operators ----
# These do the same thing
x = 5
x <- 5

# These are not the same
add2(a = 3, b = 5)
add2(a <- 3, b <- 5)

x <<- 3
