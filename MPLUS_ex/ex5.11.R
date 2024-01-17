mplus.out <- "ex5.11.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.11.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "y11", "y12"))

model <- '
f1 =~ y1 + y2 + y3
f2 =~ y4 + y5 + y6
f3 =~ y7 + y8 + y9
f4 =~ y10 + y11 + y12
f3 ~ f1 + f2
f4 ~ f3 
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , meanstructure  = TRUE
    )
summary(fit, fit.measures = TRUE)
