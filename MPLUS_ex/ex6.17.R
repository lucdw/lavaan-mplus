mplus.out <- "ex6.17.out" 
lavaan.model <- '
    i =~ 1*y1 + 1*y2 + 1*y3 + 1*y4
    s =~ 0*y1 + 1*y2 + 2*y3 + 3*y4 
    i ~~ i; s ~~ s; i ~~ s   
    i + s ~ 1

    y1 ~~ resvar*y1
    y2 ~~ resvar*y2
    y3 ~~ resvar*y3
    y4 ~~ resvar*y4

    y1 ~~ p1*y2 + p2*y3 + p3*y4
    y2 ~~ p1*y3 + p2*y4
    y3 ~~ p1*y4

    # phantom variable
    fcorr =~ 0
    fcorr ~~ corr*fcorr
   
    # constraints
    p1 == resvar*corr
    p2 == resvar*corr^2
    p3 == resvar*corr^3
'
lavaan.call <-  "lavaan" 
lavaan.args <- list(information = "observed")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
