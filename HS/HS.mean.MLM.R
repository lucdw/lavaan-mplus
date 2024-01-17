mplus.out <- "HS.mean.MLM.out" # needed for batch-execution
library(lavaan)

Data <- read.table("HS.raw", na.strings = "-999999", 
col.names = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9"))

model <- '
  visual  =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9
'
fit <-  sem (model, data = Data
    , estimator  = "MLM"
    , meanstructure  = TRUE
    )
summary(fit)  # summary(...): removed if executed in batch
