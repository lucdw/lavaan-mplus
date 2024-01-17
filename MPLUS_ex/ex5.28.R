mplus.out <- "ex5.28.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.28.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10"))

model <- '
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
fit <-  sem (model, data = Data
    , information  = "observed"
    , rotation  = "geomin"
    , meanstructure  = TRUE
    , group.equal  = c("loadings", "intercepts", "lv.variances", "lv.covariances", 
"means")
    , rotation.args  = list(30, 1e-04, TRUE)
    )
summary(fit, fit.measures = TRUE)
