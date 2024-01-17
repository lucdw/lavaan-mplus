mplus.out <- "ex6.4.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.4.dat", na.strings = "-999999", 
col.names = c("u11", "u12", "u13", "u14"))

model <- '
    u11 + u12 + u13 + u14 | th*t1

    i =~ 1*u11 + 1*u12 + 1*u13 + 1*u14
    s =~ 0*u11 + 1*u12 + 2*u13 + 3*u14 
    i ~~ i
    s ~~ s
    i ~~ s   
 
    # latent means
    i ~ 0*1
    s ~ 1

    # scaling
    u11 ~*~ 1*u11
    u12 ~*~ u12
    u13 ~*~ u13
    u14 ~*~ u14
'
fit <-  lavaan (model, data = Data
    , ordered  = c("u11", "u12", "u13", "u14")
    )
summary(fit, fit.measures = TRUE)
