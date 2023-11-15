mplus.out <- "HS1.mplus.out" 
lavaan.model <- '
 visual  =~ NA*x1 +
label("A1")*
x1+ NB*x2 + NC*x3
           textual =~
NA*x4 +
label("ND")*x5

 + label("NE")*x6
           speed   =~ as.numeric(NA)*x7 + NAA*x8 + label("NA")*x9
           visual  ~~ 1*visual; textual ~~ 1*textual
           speed   ~~ 1*speed 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   meanstructure = TRUE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
