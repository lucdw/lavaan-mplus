mplus.out <- "ex5.10.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.10.dat", na.strings = "-999999", 
col.names = c("u1a", "u1b", "u1c", "u2a", "u2b", "u2c"))

model <- '
f1 =~ 1*u1a + 1*u1b + 1*u1c
f2 =~ 1*u2a + 1*u2b + 1*u2c
u1a + u1b + u1c | a*t1
u2a + u2b + u2c | b*t1
'
fit <-  sem (model, data = Data
    , ordered  = c("u1a", "u1b", "u1c", "u2a", "u2b", "u2c")
    )
summary(fit, fit.measures = TRUE, rsquare = TRUE)
