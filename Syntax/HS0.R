mplus.out <- "HS0.mplus.out" 
lavaan.model <- '
f1 =~ x1 + x2 + x3 + x4
f2 =~ x5 + x2 + x3 + x6
f3 =~ x7 + x8 + x9
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   meanstructure = TRUE)
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args)
}
