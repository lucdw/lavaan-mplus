mplus.out <- "HS3.mplus.out" 
lavaan.model <- '
visual  =~ x1 + A*x2  + A*x3
textual =~ B*x4 + B*x5 + x6
speed   =~ label("NA")*x7 + abc*x8 + label*x9
speed ~~ label*speed
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   meanstructure = TRUE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
