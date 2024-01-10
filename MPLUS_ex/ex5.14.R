mplus.out <- "ex5.14.mplus.out" 
lavaan.model <- '
f1 =~ y1 + y2 + y3
f2 =~ y4 + y5 + y6
f1 + f2 ~ x1 + x2 + x3 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   meanstructure = FALSE,
   group = "g",
   group.equal = "loadings",
   group.partial = "f1=~y3")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
