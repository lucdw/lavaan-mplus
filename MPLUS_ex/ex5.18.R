mplus.out <- "ex5.18.out" 
lavaan.model <- '
    y1 ~ c(a,a)*1
    y2 ~ c(a,a)*1

    a1 =~ c(la,la)*y1
    a2 =~ c(la,la)*y2
    c1 =~ c(lc,lc)*y1
    c2 =~ c(lc,lc)*y2
    e1 =~ c(le,le)*y1
    e2 =~ c(le,le)*y2

    a1 ~~ c(1,0.5)*a2
    c1 ~~ c(1,1)*c2
'
lavaan.call <-  "lavaan" 
lavaan.args <- list(
   information = "observed",
   group = "g",
   std.lv = TRUE
   )
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
