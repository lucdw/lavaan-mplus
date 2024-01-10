mplus.out <- "ex3.13.out" 
lavaan.model <- '
u1 + u2 ~ x1 + x2 + x3
     u3 ~ u1 + u2 + x2 
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  parameterization = "theta",
  baseline.conditional.x.free.slopes = FALSE
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
