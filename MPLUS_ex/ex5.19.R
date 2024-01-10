mplus.out <- "ex5.19.out" 
lavaan.model <- '
    u1 | c(a,a)*t1
    u2 | c(a,a)*t1

    a1 =~ c(la,la)*u1
    a2 =~ c(la,la)*u2
    c1 =~ c(lc,lc)*u1
    c2 =~ c(lc,lc)*u2

    a1 ~~ c(1,0.5)*a2
    c1 ~~ c(1,1)*c2

    u1 ~~ c(1,1)*u1
    u2 ~~ c(1,1)*u2
'
lavaan.call <-  "lavaan" 
lavaan.args <- list(
   group = "g",
   std.lv = TRUE
   )
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
