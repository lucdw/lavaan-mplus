mplus.out <- "ex5.3.out" 
lavaan.model <- '
 f1 =~ u1 + u2 + u3
 f2 =~ y4 + y5 + y6 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  estimator = "WLSMV"
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
