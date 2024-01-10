mplus.out <- "ex9.6.out" 
lavaan.model <- '
    level: 1
        fw =~ y1 + y2 + y3 + y4
        fw ~ x1 + x2

    level: 2
        fb =~ y1 + y2 + y3 + y4

        y1 ~~ 0.0001*y1
        y2 ~~ 0.0001*y2
        y3 ~~ 0.0001*y3
        y4 ~~ 0.0001*y4

        fb ~ w
'
lavaan.call <-  "sem" 
lavaan.args <- list(cluster = "clus", estimator = "MLR")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
