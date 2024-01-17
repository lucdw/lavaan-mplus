# test compare with mplus not executed because fitMeasures abort if run with mimic = "Mplus"
# mplus.out <- "ex5.22.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex5.22.dat", na.strings = "-999999", 
col.names = c("u1", "u2", "g"))

elements <- c("=mz", "2=dz")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew
model <- '
    u1 | c(th,th)*t1
    u2 | c(th,th)*t1

    u1 ~~ c(covmz, covdz)*u2

    # dummu variables
    fa =~ 0; fa ~~ c(a,a)*fa + start(0.8)*fa
    fc =~ 0; fc ~~ c(c,c)*fc
    fe =~ 0; fe ~~ c(e,e)*fe
    fh =~ 0; fh ~~ c(h,h)*fh

    # constraints
    covmz == a^2 + c^2
    covdz == 0.5*a^2 + c^2
    e == 1 - (a^2 + c^2)
    h == a^2/1

    # optional (if you insist a/c/e should be positive)
    a > 0
    c > 0
    e > 0
'
test.comment <- 'test compare with mplus not executed because lavaan\n fitMeasures() aborts if run with mimic = "Mplus"'
fit <-  lavaan (model, data = Data
    , group  = "g"
    , ordered  = c("u1", "u2")
    )
summary(fit, fit.measures = TRUE)

