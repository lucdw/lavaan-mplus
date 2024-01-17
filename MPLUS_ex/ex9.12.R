mplus.out <- "ex9.12.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex9.12.dat", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "x", "w", "clus"))

model <- '
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
fit <-  sem (model, data = Data
    , cluster  = "clus"
    , estimator  = "MLR"
    )
summary(fit, fit.measures = TRUE)
