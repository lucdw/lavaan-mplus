mplus.out <- "HS.missing.MLR.observed.out" # needed for batch-execution
library(lavaan)

Data <- read.table("HS.missing.raw", na.strings = "-999999", 
col.names = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9"))

model <- '
visual  =~ x1 + x2 + x3
textual =~ x4 + x5 + x6
speed   =~ x7 + x8 + x9
'
fit <-  sem (model, data = Data
    , estimator  = "MLR"
    , information  = "observed"
    , missing  = "ml"
    )
summary(fit)  # summary(...): removed if executed in batch
