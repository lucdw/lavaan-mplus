mplus.out <- "HS3.out" # needed for batch-execution
library(lavaan)

Data <- read.table("HS.raw", na.strings = "-999999", 
col.names = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9"))

model <- '
visual  =~ x1 + A*x2  + A*x3
textual =~ B*x4 + B*x5 + x6
speed   =~ label("NA")*x7 + abc*x8 + label*x9
speed ~~ label*speed
'
fit <-  sem (model, data = Data
    , estimator  = "ML"
    , information  = "observed"
    , meanstructure  = TRUE
    )
summary(fit)  # summary(...): removed if executed in batch
