# test compare with mplus not executed because fitMeasures abort if run with mimic = "Mplus"
# mplus.out <- "ex5.19.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.19.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "g"))

elements <- c("1=mz", "2=dz")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew
model <- '
    u1 | c(a,a)*t1
    u2 | c(a,a)*t1

    a1 =~ c(la,la)*u1
    a2 =~ c(la,la)*u2
    c1 =~ c(lc,lc)*u1
    c2 =~ c(lc,lc)*u2

    a1 ~~ c(1,0.5)*a2
    c1 ~~ c(1,1)*c2

    u1 ~~ c(1,1)*u1
    u2 ~~ c(1,1)*u2
'
fit <-  lavaan (model, data = Data
    , group  = "g"
    , std.lv  = TRUE
    , ordered  = c("u1", "u2")
    , missing = "listwise"
    )
test.comment <- 'test compare with mplus not executed because lavaan\n fitMeasures() aborts if run with mimic = "Mplus"'
summary(fit, fit.measures = TRUE, rsquare = TRUE)

