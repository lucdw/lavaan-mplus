mplus.out <- "ex3.12.WLS.mplus.out" 
lavaan.model <- '
u1 + u2 ~ x1 + x2 + x3
u3 ~ u1 + u2 + x2
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "WLS")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
