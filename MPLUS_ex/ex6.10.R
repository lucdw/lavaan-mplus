mplus.out <- "ex6.10.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.10.dat", na.strings = "-999999", 
col.names = c("y11", "y12", "y13", "y14", "x1", "x2", "a31", "a32", "a33", "a34"))

model <- '
    i =~ 1*y11 + 1*y12 + 1*y13 + 1*y14
    s =~ 0*y11 + 1*y12 + 2*y13 + 3*y14 
    i ~~ s   
 
    # latent means
    i + s ~ 1

    # regressions
    i + s ~ x1 + x2

    # time-varying covariates
    y11 ~ a31
    y12 ~ a32
    y13 ~ a33
    y14 ~ a34
  
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    , auto.var  = TRUE
    )
summary(fit, fit.measures = TRUE)
