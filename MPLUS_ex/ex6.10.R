mplus.out <- "ex6.10.mplus.out" 
lavaan.model <- '
    i =~ 1*y11 + 1*y12 + 1*y13 + 1*y14
    s =~ 0*y11 + 1*y12 + 2*y13 + 3*y14 
    i ~~ s   
 
    # latent means
    i + s ~ 1

    # regressions
    i + s ~ x1 + x2

    # time-varying covariates
    y11 ~ a31
    y12 ~ a32
    y13 ~ a33
    y14 ~ a34
  
'
lavaan.call <-  "lavaan" 
lavaan.args <- list(
   information = "observed",
   auto.var = TRUE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
