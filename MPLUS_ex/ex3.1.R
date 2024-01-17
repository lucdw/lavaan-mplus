mplus.out <- "ex3.1.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.1.dat", na.strings = "-999999", 
col.names = c("y1", "x1", "x3"))

model <- '
 y1 ~ x1 + x3 
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , meanstructure  = TRUE
    )
summary(fit, fit.measures = TRUE)
