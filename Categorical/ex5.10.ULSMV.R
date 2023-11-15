mplus.out <- "ex5.10.ULSMV.mplus.out" 
lavaan.model <- '
f1 =~ u1a + 1*u1b + 1*u1c
f2 =~ u2a + 1*u2b + 1*u2c
u1a + u1b + u1c | a*t1
u2a + u2b + u2c | b*t1
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ULSMV",
   meanstructure = FALSE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
