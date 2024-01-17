mplus.out <- "HS6.out" # needed for batch-execution
library(lavaan)

Data <- read.table("HS.multi.raw", na.strings = "-999999", 
col.names = c("school", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9"))

elements <- c("1=Pasteur", "2=GrantWhite")
groupnew <- vector("character", length(Data[["school"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["school"]] == as.integer(elems[1])] <- elems[2]
}
Data[["school"]] <- groupnew
model <- '
visual  =~ x1 + 0.5*x2 + c(0.6, 0.8)*x3
textual =~ x4 + start(c(1.2, 0.6))*x5 + c(a,b)*x6
speed   =~ x7 + equal(c("textual=~x5","textual=~x5.g2"))*x8
            + equal(c("a","a"))*x9
speed ~~ equal(c("","speed~~speed"))*speed
visual ~~ label(c("V1","V2"))*visual
'
fit <-  sem (model, data = Data
    , estimator  = "ML"
    , information  = "observed"
    , meanstructure  = TRUE
    , group  = "school"
    )
summary(fit)  # summary(...): removed if executed in batch
