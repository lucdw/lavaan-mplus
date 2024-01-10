mplus.out <- "ex9.1b.out" 
lavaan.model <- '
  level: 1
      y ~ gamma10*x

  level: 2
      y ~ w + gamma01*x

  betac := gamma01 - gamma10
'
lavaan.call <-  "sem" 
lavaan.args <- list(cluster = "clus", estimator = "MLR")
test.comment <- '!!! variable x not centered in this call'
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
