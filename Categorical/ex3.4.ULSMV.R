mplus.out <- "ex3.4.ULSMV.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.4.dat", na.strings = "-999999", 
col.names = c("u1", "x1", "x3"))

model <- '
 u1 ~ x1 + x3 
'
fit <-  sem (model, data = Data
    , estimator  = "ULSMV"
    , meanstructure  = FALSE
    , ordered  = "u1"
    )
summary(fit)  # summary(...): removed if executed in batch
