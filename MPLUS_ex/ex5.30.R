mplus.out <- "ex5.30.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.30.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10"))

model <- '
    fg =~ NA*y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10
    fg ~~ 1*fg

    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 

    fg ~~ 0*f1 + 0*f2
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
