mplus.out <- "ex5.10.out" 
lavaan.model <- '
f1 =~ 1*u1a + 1*u1b + 1*u1c
f2 =~ 1*u2a + 1*u2b + 1*u2c
u1a ~ 1
u1b ~ equal("u1a~1") * 1
u1c ~ equal("u1a~1") * 1
u2a ~ 1
u2b ~ equal("u2a~1") * 1
u2c ~ equal("u2a~1") * 1
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "WLSMV",
   meanstructure = TRUE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
