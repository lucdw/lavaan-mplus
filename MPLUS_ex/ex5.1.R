mplus.out <- "ex5.1.mplus.out" 
lavaan.model <- '
 f1 =~ y1 + y2 + y3
 f2 =~ y4 + y5 + y6 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   information = "observed",
   meanstructure = TRUE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
