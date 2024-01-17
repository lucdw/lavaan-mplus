mplus.out <- "ex5.1.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.1.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6"))

model <- '
 f1 =~ y1 + y2 + y3
 f2 =~ y4 + y5 + y6 
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , meanstructure  = TRUE
    )
summary(fit, fit.measures = TRUE)
