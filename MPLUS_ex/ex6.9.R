mplus.out <- "ex6.9.mplus.out" 
lavaan.model <- '
i =~ 1*y11 + 1*y12 + 1*y13 + 1*y14
s =~ 0*y11 + 1*y12 + 2*y13 + 3*y14
q =~ 0*y11 + 1*y12 + 4*y13 + 9*y14 
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
