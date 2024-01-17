mplus.out <- "ex9.1a.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex9.1a.dat", na.strings = "-999999", 
col.names = c("y", "x", "w", "xm", "clus"))

model <- '
  level: 1
      y ~ x

  level: 2
      y ~ w + xm
'
fit <-  sem (model, data = Data
    , cluster  = "clus"
    , estimator  = "MLR"
    )
test.comment <- '!!! variable x not centered in this call'
summary(fit, fit.measures = TRUE)
