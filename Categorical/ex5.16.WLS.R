mplus.out <- "ex5.16.WLS.mplus.out" 
lavaan.model <- '
f1 =~ u1 + u2 + c(l3,l3b)*u3
f2 =~ u4 + u5 + u6
f1 + f2 ~ x1 + x2 + x3
u3 | c(u3,u3b)*t1
u3 ~*~ c(1,1)*u3
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "WLS",
   meanstructure = FALSE,
   group = "g",
   group.equal = c("loadings", "thresholds"))
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args)
}
