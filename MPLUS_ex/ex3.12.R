mplus.out <- "ex3.12.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.12.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "u3", "x1", "x2", "x3"))

model <- '
u1 + u2 ~ x1 + x2 + x3
     u3 ~ u1 + u2 + x2 
'
fit <-  sem (model, data = Data
    , baseline.conditional.x.free.slopes  = FALSE
    , ordered  = c("u1", "u2", "u3")
    )
summary(fit, fit.measures = TRUE, rsquare = TRUE)


