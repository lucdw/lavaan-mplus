mplus.out <- "ex5.24.out" 
lavaan.model <- '
    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8

    f1 + f2 ~ x1 + x2
    y1 ~ x1
    y8 ~ x2
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  information = "observed",
  meanstructure = TRUE,
  rotation = "geomin",
  rotation.args = list(rstarts = 30, geomin.epsilon = 0.0001)
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
