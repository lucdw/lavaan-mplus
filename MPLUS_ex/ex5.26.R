mplus.out <- "ex5.26.out" 
lavaan.model <- '
    efa("time1")*f1 =~ a*y1 + b*y2 + c*y3 + d*y4 + e*y5 + f*y6
    efa("time1")*f2 =~ g*y1 + h*y2 + i*y3 + j*y4 + k*y5 + l*y6

    efa("time2")*f3 =~ a*y7 + b*y8 + c*y9 + d*y10 + e*y11 + f*y12
    efa("time2")*f4 =~ g*y7 + h*y8 + i*y9 + j*y10 + k*y11 + l*y12

    y1 ~~ y7
    y2 ~~ y8
    y3 ~~ y9
    y4 ~~ y10
    y5 ~~ y11
    y6 ~~ y12

    # free var f3 and f4
    f3 ~~ NA*f3 + start(1)*f3
    f4 ~~ NA*f4 + start(1)*f4
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  information = "observed",
  meanstructure = TRUE,
  rotation = "geomin",
  rotation.args = list(rstarts = 30, geomin.epsilon = 0.0001,
                       std.ov = FALSE)
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
