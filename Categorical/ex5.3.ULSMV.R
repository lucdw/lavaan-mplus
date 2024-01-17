mplus.out <- "ex5.3.ULSMV.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.3.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "u3", "y4", "y5", "y6"))

model <- '
f1 =~ u1 + u2 + u3
f2 =~ y4 + y5 + y6
'
fit <-  sem (model, data = Data
    , estimator  = "ULSMV"
    , meanstructure  = FALSE
    , ordered  = c("u1", "u2", "u3")
    )
summary(fit)  # summary(...): removed if executed in batch
