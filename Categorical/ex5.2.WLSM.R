mplus.out <- "ex5.2.WLSM.mplus.out" 
lavaan.model <- '
f1 =~ u1 + u2 + u3
f2 =~ u4 + u5 + u6 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "WLSM",
   meanstructure = FALSE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
