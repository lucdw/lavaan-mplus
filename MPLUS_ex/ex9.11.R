# test compare with mplus not executed because lavaan abort if run with mimic = "Mplus"
# mplus.out <- "ex9.11.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex9.11.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "g", "clus"))

elements <- c("1=g1", "2=g2")
groupnew <- vector("character", length(Data[["g"]]))
for (element in elements) {
  elems <- strsplit(element, "=", fixed = TRUE)[[1]]
  groupnew[Data[["g"]] == as.integer(elems[1])] <- elems[2]
}
Data[["g"]] <- groupnew

model <- '
   group: "g1"
        level: 1
            fw1 =~ y1 + y2 + y3
            fw2 =~ y4 + y5 + y6
        level: 2
            fb1 =~ y1 + a*y2 + b*y3
            fb2 =~ y4 + c*y5 + d*y6
 
            y1 ~ i1*1
            y2 ~ i2*1
            y3 ~ i3*1
            y4 ~ i4*1
            y5 ~ i5*1
            y6 ~ i6*1

   group: "g2"
        level: 1
            fw1 =~ y1 + y2 + y3
            fw2 =~ y4 + y5 + y6
        level: 2
            fb1 =~ y1 + a*y2 + b*y3
            fb2 =~ y4 + c*y5 + d*y6

            y1 ~ i1*1
            y2 ~ i2*1
            y3 ~ i3*1
            y4 ~ i4*1
            y5 ~ i5*1
            y6 ~ i6*1

            fb1 ~ 1
            fb2 ~ 1
'
fit <-  sem (model, data = Data
    , cluster  = "clus"
    , group  = "g"
    , estimator  = "MLR"
    )
test.comment = '
 lavaan abort if run with mimic = "Mplus": 
 Error in lav_partable_vnames(partable, "ov.nox", group = g) : 
  lavaan ERROR: group column does not contain value "1"
'
summary(fit, fit.measures = TRUE)
