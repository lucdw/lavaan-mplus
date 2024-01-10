mplus.out <- "ex5.29.out" 
lavaan.model <- '
    efa("efa1")*fg +
    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  information = "observed",
  rotation = "bigeomin",
  meanstructure = TRUE,
  group.equal = c("loadings", "intercepts", "lv.variances",
                  "lv.covariances", "means"),
  rotation.args = list(rstarts = 5, geomin.epsilon = 0.0001,
                       std.ov = TRUE)
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
