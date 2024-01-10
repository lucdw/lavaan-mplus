mplus.out <- "ex5.30.out" 
lavaan.model <- '
    fg =~ NA*y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10
    fg ~~ 1*fg

    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 

    fg ~~ 0*f1 + 0*f2
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  information = "observed",
  rotation = "geomin",
  meanstructure = TRUE,
  group.equal = c("loadings", "intercepts", "lv.variances",
                  "lv.covariances", "means"),
  rotation.args = list(rstarts = 30, geomin.epsilon = 0.0001,
                       std.ov = TRUE)
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
