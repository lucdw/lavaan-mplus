mplus.out <- "ex6.9.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.9.dat", na.strings = "-999999", 
col.names = c("y11", "y12", "y13", "y14"))

model <- '
    i =~ 1*y11 + 1*y12 + 1*y13 + 1*y14
    s =~ 0*y11 + 1*y12 + 2*y13 + 3*y14 
    q =~ 0*y11 + 1*y12 + 4*y13 + 9*y14
    i ~~ s + q
    s ~~ q  
 
    # latent means
    i + s + q ~ 1
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    , auto.var  = TRUE
    )
summary(fit, fit.measures = TRUE)
