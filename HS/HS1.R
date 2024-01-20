mplus.out <- "HS1.out" # needed for batch-execution
library(lavaan)

Data <- read.table("HS.raw", na.strings = "-999999", 
col.names = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9"))

model <- '
 visual  =~ NA*x1 +
label("A1")*
x1+ NB*x2 + NC*x3
           textual =~
NA*x4 +
label("ND")*x5

 + label("NE")*x6
           speed   =~ as.numeric(NA)*x7 + NAA*x8 + label("NA")*x9
           visual  ~~ 1*visual; textual ~~ 1*textual
           speed   ~~ 1*speed 
'
fit <-  sem (model, data = Data
    , estimator  = "ML"
    , information  = "observed"
    , meanstructure  = TRUE
    )
summary(fit)  # summary(...): removed if executed in batch
