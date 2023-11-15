mplus.out <- "ex3.4.WLS.mplus.out" 
lavaan.model <- '
 u1 ~ x1 + x3 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "WLS",
   meanstructure = FALSE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
