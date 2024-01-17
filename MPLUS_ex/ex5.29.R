mplus.out <- "ex5.29.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.29.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10"))

model <- '
    efa("efa1")*fg +
    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , rotation  = "bigeomin"
    , meanstructure  = TRUE
    , group.equal  = c("loadings", "intercepts", "lv.variances", "lv.covariances", 
"means")
    , rotation.args  = list(5, 1e-04, TRUE)
    )
summary(fit, fit.measures = TRUE)
