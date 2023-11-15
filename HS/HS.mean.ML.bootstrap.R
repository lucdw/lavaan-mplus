mplus.out <- "HS.mean.ML.bootstrap.mplus.out" 
lavaan.model <- '
  visual  =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   se = "bootstrap",
   bootstrap = 200,
   meanstructure = TRUE)
test.comment <- '
because of random samples in bootstrap, 
fitted values will change on every run!
'
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
