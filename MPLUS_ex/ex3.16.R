mplus.out <- "ex3.16.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.11.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "x1", "x2", "x3"))

model <- '
   y1 ~ a*x1 + b*x2 + c*x3
    y2 ~ d*x1 + e*x2 + f*x3
    y3 ~ g*y1 + h*y2 + i*x2

    # indirect effects
    ind.y3.y1.x1 := g*a
    ind.y3.y2.x1 := h*d
    tot.y3.x1 := ind.y3.y1.x1 + ind.y3.y2.x1
'
fit <-  sem (model, data = Data
    , meanstructure  = TRUE
    , se  = "bootstrap"
    )
summary(fit, fit.measures = TRUE, ci = TRUE)
