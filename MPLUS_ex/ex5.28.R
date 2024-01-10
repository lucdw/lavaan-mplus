mplus.out <- "ex5.28.out" 
lavaan.model <- '
    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10
 
    y1  ~~ v1*y1   + lower(0)*y1
    y2  ~~ v2*y2   + lower(0)*y2 
    y3  ~~ v3*y3   + lower(0)*y3
    y4  ~~ v4*y4   + lower(0)*y4
    y5  ~~ v5*y5   + lower(0)*y5
    y6  ~~ v6*y6   + lower(0)*y6
    y7  ~~ v7*y7   + lower(0)*y7
    y8  ~~ v8*y8   + lower(0)*y8
    y9  ~~ v9*y9   + lower(0)*y9
    y10 ~~ v10*y10 + lower(0)*y10
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
