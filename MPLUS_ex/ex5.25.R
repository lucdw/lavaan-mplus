mplus.out <- "ex5.25.out" 
lavaan.model <- '
    # efa block 
    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6

    # cfa block
    f3 =~ y7 + y8 + y9
    f4 =~ y10 + y11 + y12

    # regressions
    f3 ~ f1 + f2
    f4 ~ f3
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
