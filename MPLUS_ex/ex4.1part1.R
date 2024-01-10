mplus.out <- "ex4.1part1.out" 
lavaan.model <- NA
lavaan.call <-  "efa" 
lavaan.args <- list(
   nfactors = 1:4,
   rotation = "geomin")
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
