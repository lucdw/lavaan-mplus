mplus.out <- "ex5.21.out" 
lavaan.model <- '
    y1 ~ c(int,int)*1
    y2 ~ c(int,int)*1

    y1 ~~ c(var,var)*y1
    y2 ~~ c(var,var)*y2

    y1 ~~ c(covmz, covdz)*y2

    # dummy variables
    fa =~ 0; fa ~~ c(a,a)*fa + start(0.8)*fa
    fc =~ 0; fc ~~ c(c,c)*fc
    fe =~ 0; fe ~~ c(e,e)*fe
    fh =~ 0; fh ~~ c(h,h)*fh

    # constraints
    var == a^2 + c^2 + e^2
    covmz == a^2 + c^2
    covdz == 0.5*a^2 + c^2
    h == a^2/(a^2 + c^2 + e^2)

    # optional (if you insist a/c/e should be positive)
    a > 0
    c > 0
    e > 0
'
lavaan.call <-  "lavaan" 
lavaan.args <- list(
  information = "observed",
  group = "g"
   )
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
