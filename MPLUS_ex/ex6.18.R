mplus.out <- "ex6.18.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.18.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "x", "a21", "a22", "a23", "a24", "g"))

elements <- c("1=1990", "2=1989", "3=1988")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew
model <- '
    i =~ c(1,1,1)*y1 + c(1,1,1)*y2 + c(1,1,1)*y3 + c(1,1,1)*y4
    s =~ c(0,0.1,0.2)*y1 + c(0.2,0.3,0.4)*y2 + 
         c(0.4,0.5,0.6)*y3 + c(0.6,0.7,0.8)*y4 
    i ~~ c(rvi, rvi, rvi)*i
    s ~~ c(rvs, rvs, rvs)*s
    i ~~ c(cis, cis, cis)*s   
    i ~ c(inti, inti, inti)*1
    s ~ c(ints, ints, ints)*1

    i ~ c(bix, bix, bix)*x
    s ~ c(bsx, bsx, bsx)*x

    y1 ~ c(a11, a12, a21)*a21
    y2 ~ c(a21, a22, a31)*a22
    y3 ~ c(a31, a32, a41)*a23
    y4 ~ c(a41, a42, a43)*a24

    y1 ~~ c(ry11, ry12, ry21)*y1
    y2 ~~ c(ry21, ry22, ry31)*y2
    y3 ~~ c(ry31, ry32, ry41)*y3
    y4 ~~ c(ry41, ry42, ry43)*y4
'
fit <-  lavaan (model, data = Data
    , information  = "observed"
    , group  = "g"
    )
summary(fit, fit.measures = TRUE)
