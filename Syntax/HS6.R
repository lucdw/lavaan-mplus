mplus.out <- "HS6.mplus.out" 
lavaan.model <- '
visual  =~ x1 + 0.5*x2 + c(0.6, 0.8)*x3
textual =~ x4 + start(c(1.2, 0.6))*x5 + c(a,b)*x6
speed   =~ x7 + equal(c("textual=~x5","textual=~x5.g2"))*x8
            + equal(c("a","a"))*x9
speed ~~ equal(c("","speed~~speed"))*speed
visual ~~ label(c("V1","V2"))*visual
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   meanstructure = TRUE,
   group = "school")
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args)
}
