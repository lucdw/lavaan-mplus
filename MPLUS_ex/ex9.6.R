mplus.out <- "ex9.6.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex9.6.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "x1", "x2", "w", "clus"))

model <- '
    level: 1
        fw =~ y1 + y2 + y3 + y4
        fw ~ x1 + x2

    level: 2
        fb =~ y1 + y2 + y3 + y4

        y1 ~~ 0.0001*y1
        y2 ~~ 0.0001*y2
        y3 ~~ 0.0001*y3
        y4 ~~ 0.0001*y4

        fb ~ w
'
fit <-  sem (model, data = Data
    , cluster  = "clus"
    , estimator  = "MLR"
    )
summary(fit, fit.measures = TRUE)
