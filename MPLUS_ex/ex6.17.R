mplus.out <- "ex6.17.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.17.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4"))

model <- '
    i =~ 1*y1 + 1*y2 + 1*y3 + 1*y4
    s =~ 0*y1 + 1*y2 + 2*y3 + 3*y4 
    i ~~ i; s ~~ s; i ~~ s   
    i + s ~ 1

    y1 ~~ resvar*y1
    y2 ~~ resvar*y2
    y3 ~~ resvar*y3
    y4 ~~ resvar*y4

    y1 ~~ p1*y2 + p2*y3 + p3*y4
    y2 ~~ p1*y3 + p2*y4
    y3 ~~ p1*y4

    # phantom variable
    fcorr =~ 0
    fcorr ~~ corr*fcorr
   
    # constraints
    p1 == resvar*corr
    p2 == resvar*corr^2
    p3 == resvar*corr^3
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    )
summary(fit, fit.measures = TRUE)
