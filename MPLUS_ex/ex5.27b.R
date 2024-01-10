mplus.out <- "ex5.27b.out" 
lavaan.model <- '
    efa("efa")*f1 +
    efa("efa")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  information = "observed",
  group = "group",
  rotation = "geomin",
  group.equal = "loadings",
  rotation.args = list(rstarts = 30, geomin.epsilon = 0.0001,
                       std.ov = FALSE)
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
