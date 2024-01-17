mplus.out <- "ex5.25.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.25.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "y11", "y12"))

model <- '
    # efa block 
    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6

    # cfa block
    f3 =~ y7 + y8 + y9
    f4 =~ y10 + y11 + y12

    # regressions
    f3 ~ f1 + f2
    f4 ~ f3
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , meanstructure  = TRUE
    , rotation  = "geomin"
    , rotation.args  = list(30, 1e-04)
    )
summary(fit, fit.measures = TRUE)
