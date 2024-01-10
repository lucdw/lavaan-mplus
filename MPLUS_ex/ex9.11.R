mplus.out <- "ex9.11.out" 
lavaan.model <- '
   group: 1
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

    group: 2
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
lavaan.call <-  "sem" 
lavaan.args <- list(cluster = "clus", group = "g", estimator = "MLR")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
