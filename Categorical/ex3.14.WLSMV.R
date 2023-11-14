mplus.out <- "ex3.14.WLSMV.mplus.out" 
lavaan.model <- '
y1 + y2 ~ x1 + x2 + x3
u1 ~ y1 + y2 + x2 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "WLSMV",
   meanstructure = FALSE)
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args)
}
