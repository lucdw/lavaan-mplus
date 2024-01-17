mplus.out <- "ex9.1b.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex9.1b.dat", na.strings = "-999999", 
col.names = c("y", "x", "w", "clus"))

model <- '
  level: 1
      y ~ gamma10*x

  level: 2
      y ~ w + gamma01*x

  betac := gamma01 - gamma10
'
fit <-  sem (model, data = Data
    , cluster  = "clus"
    , estimator  = "MLR"
    )
test.comment <- '!!! variable x not centered in this call'
summary(fit, fit.measures = TRUE)
