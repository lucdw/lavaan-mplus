mplus.out <- "ex6.14.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.14.dat", na.strings = "-999999", 
col.names = c("y11", "y21", "y31", "y12", "y22", "y32", "y13", "y23", "y33"))

model <- '
   f1 =~ 1*y11 + l2*y21 + l3*y31
    f2 =~ 1*y12 + l2*y22 + l3*y32
    f3 =~ 1*y13 + l2*y23 + l3*y33

    y11 + y12 + y13 ~ int1*1
    y21 + y22 + y23 ~ int2*1
    y31 + y32 + y33 ~ int3*1

    i =~ 1*f1 + 1*f2 + 1*f3
    s =~ 0*f1 + 1*f2 + 2*f3
    i ~~ s   
 
    # latent mean
    s ~ 1
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    , auto.var  = TRUE
    )
summary(fit, fit.measures = TRUE)
