mplus.out <- "ex5.2.WLSMV.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.2.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "u3", "u4", "u5", "u6"))

model <- '
f1 =~ u1 + u2 + u3
f2 =~ u4 + u5 + u6 
'
fit <-  sem (model, data = Data
    , estimator  = "WLSMV"
    , meanstructure  = FALSE
    , ordered  = c("u1", "u2", "u3", "u4", "u5", "u6")
    )
summary(fit)  # summary(...): removed if executed in batch
