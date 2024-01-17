mplus.out <- "ex3.14.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.14.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "u1", "x1", "x2", "x3"))

model <- '
y1 + y2 ~ x1 + x2 + x3
     u1 ~ y1 + y2 + x2 
'
fit <-  sem (model, data = Data
    , baseline.conditional.x.free.slopes  = FALSE
    , ordered  = "u1"
    )
summary(fit, fit.measures = TRUE, rsquare = TRUE)


