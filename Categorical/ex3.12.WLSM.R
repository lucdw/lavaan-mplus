mplus.out <- "ex3.12.WLSM.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.12.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "u3", "x1", "x2", "x3"))

model <- '
u1 + u2 ~ x1 + x2 + x3
u3 ~ u1 + u2 + x2
'
fit <-  sem (model, data = Data
    , estimator  = "WLSM"
    , ordered  = c("u1", "u2", "u3")
    )
summary(fit)  # summary(...): removed if executed in batch
