mplus.out <- "ex5.16_nox.WLS.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.16.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "u3", "u4", "u5", "u6", "x1", "x2", "x3", "g"))

elements <- c("1=male", "2=female")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew
model <- '
f1 =~ u1 + u2 + c(l3,l3b)*u3
f2 =~ u4 + u5 + u6
u3 | c(u3,u3b)*t1
u3 ~*~ c(1,1)*u3
'
fit <-  sem (model, data = Data
    , estimator  = "WLS"
    , meanstructure  = FALSE
    , group  = "g"
    , group.equal  = c("loadings", "thresholds")
    , ordered  = c("u1", "u2", "u3", "u4", "u5", "u6")
    )
summary(fit)  # summary(...): removed if executed in batch
