# mplus.out definition removed because Mplus automation not working for this test 
# mplus.out <- "ex4.1part1.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex4.1a.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "y11", "y12"))

model <- 'NA'
fit <-  efa (model, data = Data
    , nfactors  = 1:4
    , rotation  = "geomin"
    )
summary(fit, cutoff = 0, se = TRUE, lambda.structure = TRUE)


