mplus.out <- "ex9.12.out" 
lavaan.model <- '
    level: 1
        iw =~ 1*y1 + 1*y2 + 1*y3 + 1*y4
        sw =~ 0*y1 + 1*y2 + 2*y3 + 3*y4
        iw ~~ iw
        sw ~~ sw
        iw ~~ sw

        y1 ~~ wv*y1
        y2 ~~ wv*y2
        y3 ~~ wv*y3
        y4 ~~ wv*y4

        iw + sw ~ x

    level: 2

        ib =~ 1*y1 + 1*y2 + 1*y3 + 1*y4
        sb =~ 0*y1 + 1*y2 + 2*y3 + 3*y4
        ib ~~ ib
        sb ~~ sb
        ib ~~ sb
        ib + sb ~ 1

        y1 + y2 + y3 + y4 ~ 0*1

        y1 ~~ 0.0001*y1
        y2 ~~ 0.0001*y2
        y3 ~~ 0.0001*y3
        y4 ~~ 0.0001*y4

        ib + sb ~ w
'
lavaan.call <-  "sem" 
lavaan.args <- list(cluster = "clus", estimator = "MLR")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
