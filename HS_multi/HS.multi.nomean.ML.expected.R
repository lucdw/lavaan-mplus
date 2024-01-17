mplus.out <- "HS.multi.nomean.ML.expected.out" # needed for batch-execution
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
            visual  =~ x1 + x2 + x3
            textual =~ x4 + x5 + x6
            speed   =~ x7 + x8 + x9
'
fit <-  sem (model, data = Data
    , estimator  = "ML"
    , information  = "expected"
    , meanstructure  = FALSE
    , missing  = "listwise"
    , group  = "school"
    , group.equal  = "none"
    )
summary(fit)  # summary(...): removed if executed in batch
