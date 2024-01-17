mplus.out <- "ex5.9.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.9.dat", na.strings = "-999999", 
col.names = c("y1a", "y1b", "y1c", "y2a", "y2b", "y2c"))

model <- '
f1 =~ 1*y1a + 1*y1b + 1*y1c
f2 =~ 1*y2a + 1*y2b + 1*y2c

y1a + y1b + y1c ~ a*1
y2a + y2b + y2c ~ b*1
'
fit <-  sem (model, data = Data
    , information  = "observed"
    )
summary(fit, fit.measures = TRUE)
