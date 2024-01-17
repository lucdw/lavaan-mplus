mplus.out <- "ex5.24.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.24.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "x1", "x2"))

model <- '
    efa("efa1")*f1 + 
    efa("efa1")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8

    f1 + f2 ~ x1 + x2
    y1 ~ x1
    y8 ~ x2
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , meanstructure  = TRUE
    , rotation  = "geomin"
    , rotation.args  = list(30, 1e-04)
    )
summary(fit, fit.measures = TRUE)
