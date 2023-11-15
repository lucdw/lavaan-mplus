mplus.out <- "BB.mean.ML.mplus.out" 
lavaan.model <- '
  # measurement model
    dem60 =~ y1 + y2 + y3 + y4
    dem65 =~ y5 + equal("dem60=~y2")*y6
                + equal("dem60=~y3")*y7
                + equal("dem60=~y4")*y8
    ind60 =~ x1 + x2 + x3

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   meanstructure = TRUE,
   missing = "ml")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
