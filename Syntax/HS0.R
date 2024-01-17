mplus.out <- "HS0.out" # needed for batch-execution
library(lavaan)

Data <- read.table("HS.raw", na.strings = "-999999", 
col.names = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9"))

model <- '
f1 =~ x1 + x2 + x3 + x4
f2 =~ x5 + x2 + x3 + x6
f3 =~ x7 + x8 + x9
'
fit <-  sem (model, data = Data
    , estimator  = "ML"
    , information  = "observed"
    , meanstructure  = TRUE
    )
summary(fit)  # summary(...): removed if executed in batch
