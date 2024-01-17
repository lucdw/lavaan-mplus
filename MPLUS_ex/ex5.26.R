mplus.out <- "ex5.26.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.26.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "y11", "y12"))

model <- '
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
fit <-  sem (model, data = Data
    , information  = "observed"
    , meanstructure  = TRUE
    , rotation  = "geomin"
    , rotation.args  = list(30, 1e-04, FALSE)
    )
summary(fit, fit.measures = TRUE)
