mplus.out <- "ex5.22.out" 
lavaan.model <- '
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
lavaan.call <-  "lavaan" 
lavaan.args <- list(
  group = "g"
   )
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
