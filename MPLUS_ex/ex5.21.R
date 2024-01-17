mplus.out <- "ex5.21.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.21.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "g"))

elements <- c("=mz", "2=dz")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew
model <- '
    y1 ~ c(int,int)*1
    y2 ~ c(int,int)*1

    y1 ~~ c(var,var)*y1
    y2 ~~ c(var,var)*y2

    y1 ~~ c(covmz, covdz)*y2

    # dummy variables
    fa =~ 0; fa ~~ c(a,a)*fa + start(0.8)*fa
    fc =~ 0; fc ~~ c(c,c)*fc
    fe =~ 0; fe ~~ c(e,e)*fe
    fh =~ 0; fh ~~ c(h,h)*fh

    # constraints
    var == a^2 + c^2 + e^2
    covmz == a^2 + c^2
    covdz == 0.5*a^2 + c^2
    h == a^2/(a^2 + c^2 + e^2)

    # optional (if you insist a/c/e should be positive)
    a > 0
    c > 0
    e > 0
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    , group  = "g"
    )
summary(fit, fit.measures = TRUE)

