# mplus.out definition removed because Mplus automation not working for this test 
# mplus.out <- "ex4.2.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex4.2.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "u3", "u4", "u5", "u6", "u7", "u8", "u9", "u10", "u11", "u12"))

model <- 'NA'
fit <-  efa (model, data = Data
    , nfactors  = 1:4
    , rotation  = "geomin"
    , ordered  = c("u1", "u2", "u3", "u4", "u5", "u6", "u7", "u8", "u9", "u10", 
"u11", "u12")
    )
summary(fit, cutoff = 0, se = TRUE, lambda.structure = TRUE)

