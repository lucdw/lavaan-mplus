mplus.out <- "ex5.2.WLSMV.mplus.out" 
lavaan.model <- '
f1 =~ u1 + u2 + u3
f2 =~ u4 + u5 + u6 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "WLSMV",
   meanstructure = FALSE)
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args)
}