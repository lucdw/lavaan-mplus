mplus.out <- "ex5.27b.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.27.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "y9", "y10", "group"))

elements <- c("1=g1", "2=g2")
groupnew <- vector("character", length(Data[["group"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["group"]] == as.integer(elems[1])] <- elems[2]
}
Data[["group"]] <- groupnew
model <- '
    efa("efa")*f1 +
    efa("efa")*f2 =~ y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10
'
fit <-  sem (model, data = Data
    , information  = "observed"
    , group  = "group"
    , rotation  = "geomin"
    , group.equal  = "loadings"
    , rotation.args  = list(30, 1e-04, FALSE)
    )
summary(fit, fit.measures = TRUE)
