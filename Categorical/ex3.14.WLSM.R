mplus.out <- "ex3.14.WLSM.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.14.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "u1", "x1", "x2", "x3"))

model <- '
y1 + y2 ~ x1 + x2 + x3
u1 ~ y1 + y2 + x2 
'
fit <-  sem (model, data = Data
    , estimator  = "WLSM"
    , meanstructure  = FALSE
    , ordered  = "u1"
    )
summary(fit)  # summary(...): removed if executed in batch
