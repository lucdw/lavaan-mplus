# mplus.out definition removed because Mplus automation not working for this test 
# mplus.out <- "ex4.1part2.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex4.1b.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "y11", "y12"))

model <- '
    efa("set1")*f1 +
    efa("set1")*f2 +
    efa("set1")*f3 +
    efa("set1")*f4 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 +
                      y11 + y12
'
fit <-  sem (model, data = Data
    , rotation  = "geomin"
    , meanstructure  = TRUE
    , information  = "observed"
    , rotation.args  = list(30L, 0.01)
    )
test.comment <- '
Note: standardizedSolution and modindices not executed in this test 
'
summary(fit, fit.measures = TRUE, rsquare = TRUE)
standardizedSolution(fit, type = "std.all", output = "text")
standardizedSolution(fit, type = "std.lv", output = "text")
standardizedSolution(fit, type = "std.nox", output = "text")
modindices(fit, minimum.value = 10)

