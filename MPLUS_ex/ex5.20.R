mplus.out <- "ex5.20.out" 
lavaan.model <- '
    f1 =~ y1 + lam2*y2 + lam3*y3
    f2 =~ y4 + lam5*y5 + lam6*y6

    f1 ~~ vf1*f1 + lower(0.001)*f1
    f2 ~~ vf2*f2 + lower(0.001)*f2

    y1 ~~ ve1*y1; y2 ~~ ve2*y2; y3 ~~ ve3*y3
    y4 ~~ ve4*y4; y5 ~~ ve5*y5; y6 ~~ ve6*y6

    # constraints
    rel2 := lam2^2*vf1/(lam2^2*vf1 + ve2)
    rel5 := lam5^2*vf2/(lam5^2*vf2 + ve5)
  	rel5 == rel2
  	stan3 := lam3*sqrt(vf1)/sqrt(lam3^2*vf1 + ve3)
  	stan6 := lam6*sqrt(vf2)/sqrt(lam6^2*vf2 + ve6)
  	0 == stan6 - stan3
  	ve2 > ve5
  	ve4 > 0
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  information = "observed",
  meanstructure = TRUE
   )
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
