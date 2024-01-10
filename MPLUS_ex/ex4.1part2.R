mplus.out <- "ex4.1part2.out" 
lavaan.model <- '
    efa("set1")*f1 +
    efa("set1")*f2 +
    efa("set1")*f3 +
    efa("set1")*f4 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 +
                      y11 + y12
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   rotation = "geomin",
   meanstructure = TRUE,
   information = "observed",
   rotation.args = list(rstart = 30L, geomin.epsilon = 0.01))
test.comment <- '
Note: standardizedSolution and modindices not executed in this test 
'
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
