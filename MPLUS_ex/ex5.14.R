mplus.out <- "ex5.14.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.14.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "x1", "x2", "x3", "g"))

elements <- c("1=male", "2=female")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew
model <- '
f1 =~ y1 + y2 + y3
f2 =~ y4 + y5 + y6
f1 + f2 ~ x1 + x2 + x3 
'
fit <-  sem (model, data = Data
    , meanstructure  = FALSE
    , group  = "g"
    , group.equal  = "loadings"
    , group.partial  = "f1=~y3"
    , missing = "listwise"
    )
summary(fit, fit.measures = TRUE)
