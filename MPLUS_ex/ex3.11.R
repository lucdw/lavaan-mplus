mplus.out <- "ex3.11.mplus.out" 
lavaan.model <- '
y1 + y2 ~ x1 + x2 + x3
     y3 ~ y1 + y2 + x2 
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
