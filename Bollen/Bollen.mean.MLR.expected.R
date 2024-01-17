mplus.out <- "Bollen.mean.MLR.expected.out" # needed for batch-execution
library(lavaan)

Data <- read.table("democindus.txt", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "x1", "x2", "x3"))

model <- '
  # measurement model
    dem60 =~ y1 + y2 + y3 + y4
    dem65 =~ y5 + equal("dem60=~y2")*y6
                + equal("dem60=~y3")*y7
                + equal("dem60=~y4")*y8
    ind60 =~ x1 + x2 + x3

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'
fit <-  sem (model, data = Data
    , estimator  = "MLR"
    , information  = "expected"
    , meanstructure  = TRUE
    )
summary(fit)  # summary(...): removed if executed in batch
