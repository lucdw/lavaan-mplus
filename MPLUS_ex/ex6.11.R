mplus.out <- "ex6.11.mplus.out" 
lavaan.model <- '
  i  =~ 1*y1 + 1*y2 + 1*y3 + 1*y4 + 1*y5
  s1 =~ 0*y1 + 1*y2 + 2*y3 + 2*y4 + 2*y5
  s2 =~ 0*y1 + 0*y2 + 0*y3 + 1*y4 + 2*y5
  
'
lavaan.call <-  "growth" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   meanstructure = TRUE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
