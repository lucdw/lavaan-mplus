# mplus.out definition removed because Mplus automation not working for this test 
# mplus.out <- "ex4.5.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex4.5.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "x1", "x2", "w", "clus"))

model <- 'NA'
fit <-  efa (model, data = Data
    , ov.names  = c("y1", "y2", "y3", "y4", "y5", "y6")
    , nfactors  = 1:2
    , rotation  = "geomin"
    , cluster  = "clus"
    )
test.comment <- '
Note: lavaan only supports the *same* number of factors at each level
 (for now)
'
summary(fit, cutoff = 0, se = TRUE, lambda.structure = TRUE)

# Note: lavaan only supports the *same* number of factors at each level
# (for now)
