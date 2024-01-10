mplus.out <- "ex6.5.out" 
lavaan.model <- '
    u11 + u12 + u13 + u14 | th1*t1 + th2*t2 + th3*t3

    i =~ 1*u11 + 1*u12 + 1*u13 + 1*u14
    s =~ 0*u11 + 1*u12 + 2*u13 + 3*u14 
    i ~~ i
    s ~~ s
    i ~~ s   
 
    # latent means
    i ~ 0*1
    s ~ 1

    # residual variances
    u11 ~~ 1*u11
    u12 ~~ u12
    u13 ~~ u13
    u14 ~~ u14
'
lavaan.call <-  "lavaan" 
lavaan.args <- list(parameterization= "theta")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
