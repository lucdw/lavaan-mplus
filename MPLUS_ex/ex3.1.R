mplus.out <- "ex3.1.mplus.out" 
lavaan.model <- '
 y1 ~ x1 + x3 
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
