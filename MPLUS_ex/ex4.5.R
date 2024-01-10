mplus.out <- "ex4.5.out" 
lavaan.model <- NA
lavaan.call <-  "efa" 
lavaan.args <- list(
  ov.names = paste0("y", 1:6),
  nfactors = 1:2, 
  rotation = "geomin", 
  cluster = "clus"
)
test.comment <- '
Note: lavaan only supports the *same* number of factors at each level
 (for now)
'
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
