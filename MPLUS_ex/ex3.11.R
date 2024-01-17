mplus.out <- "ex3.11.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.11.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "x1", "x2", "x3"))

model <- '
y1 + y2 ~ x1 + x2 + x3
     y3 ~ y1 + y2 + x2 
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , meanstructure  = TRUE
    )
summary(fit, fit.measures = TRUE)
