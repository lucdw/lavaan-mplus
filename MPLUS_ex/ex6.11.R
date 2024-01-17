mplus.out <- "ex6.11.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.11.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5"))

model <- '
     i =~ 1*y1 + 1*y2 + 1*y3 + 1*y4 + 1*y5
    s1 =~ 0*y1 + 1*y2 + 2*y3 + 2*y4 + 2*y5
    s2 =~ 0*y1 + 0*y2 + 0*y3 + 1*y4 + 2*y5
    i ~~ s1 + s2
    s1 ~~ s2
 
    # latent means
    i + s1 + s2 ~ 1
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    , auto.var  = TRUE
    )
summary(fit, fit.measures = TRUE)
