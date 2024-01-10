mplus.out <- "ex4.7.out" 
lavaan.model <- NA
lavaan.call <-  "efa" 
lavaan.args <- list(
  nfactors = 2:3, 
  rotation = "bigeomin"
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
