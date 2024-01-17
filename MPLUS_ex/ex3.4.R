mplus.out <- "ex3.4.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex3.4.dat", na.strings = "-999999", 
col.names = c("u1", "x1", "x3"))

model <- '
 u1 ~ x1 + x3 
'
fit <-  sem (model, data = Data
    , baseline.conditional.x.free.slopes  = FALSE
    , ordered  = "u1"
    )
summary(fit, fit.measures = TRUE, rsquare = TRUE)

# Note:
# Chi-Square Test of Model Fit for the Baseline Model
# 
#           Value                            193.243
#           Degrees of Freedom                     2
#           P-Value                           0.0000

# YR note:
# The baseline.conditional.x.free.slopes = FALSE certainly is needed to 
# mimic the Mplus result, but the values computed by lavaan are 192.852/168.527
# for the unscaled/scaled baseline chisquare.

# speculation: when df=0 for the user model, no scaling is used for the baseline# model?
