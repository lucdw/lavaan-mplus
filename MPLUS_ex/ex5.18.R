mplus.out <- "ex5.18.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.18.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "g"))

elements <- c("1=mz", "2=dz")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew
model <- '
    y1 ~ c(a,a)*1
    y2 ~ c(a,a)*1

    a1 =~ c(la,la)*y1
    a2 =~ c(la,la)*y2
    c1 =~ c(lc,lc)*y1
    c2 =~ c(lc,lc)*y2
    e1 =~ c(le,le)*y1
    e2 =~ c(le,le)*y2

    a1 ~~ c(1,0.5)*a2
    c1 ~~ c(1,1)*c2
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    , group  = "g"
    , std.lv  = TRUE
    , missing = "listwise"
    )
summary(fit, fit.measures = TRUE)

