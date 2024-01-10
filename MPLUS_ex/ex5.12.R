mplus.out <- "ex5.12.out" 
lavaan.model <- '
    f1 =~ y1 + y2 + y3
    f2 =~ y4 + y5 + y6
    f3 =~ y7 + y8 + y9
    f4 =~ y10 + y11 + y12

    f4 ~ a*f3
    f3 ~ b*f1 + c*f2

    # indirect effect
    ind.f4.f3.f1 := a*b
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   information = "observed",
   meanstructure = TRUE)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
