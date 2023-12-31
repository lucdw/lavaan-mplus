mplus.out <- "HS.multi.mean.MLMV.mplus.out" 
lavaan.model <- '
            visual  =~ x1 + x2 + x3
            textual =~ x4 + x5 + x6
            speed   =~ x7 + x8 + x9
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "MLMV",
   meanstructure = TRUE,
   group = "school",
   group.equal = "none")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
