mplus.out <- "ex5.16.out" 
lavaan.model <- '
           f1 =~ u1 + u2 + c(l3,l3b)*u3
           f2 =~ u4 + u5 + u6

           f1 + f2 ~ x1 + x2 + x3

           # equal thresholds, but free u3|1 in second group
           u3 | c(u3,u3b)*t1

           # fix scale of u3-star to 1 in second group
           u3 ~*~ c(1,1)*u3
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   group = "g",
   group.equal = c("loadings", "thresholds")
   )
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
