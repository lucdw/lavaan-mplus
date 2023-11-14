mplus.out <- "ex5.9.mplus.out" 
lavaan.model <- '
f1 =~ 1*y1a + 1*y1b + 1*y1c
f2 =~ 1*y2a + 1*y2b + 1*y2c
y1a ~ 1
y1b ~ equal("y1a~1") * 1
y1c ~ equal("y1a~1") * 1
y2a ~ 1
y2b ~ equal("y2a~1") * 1
y2c ~ equal("y2a~1") * 1
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
