mplus.out <- "ex3.16.out" 
lavaan.model <- '
   y1 ~ a*x1 + b*x2 + c*x3
    y2 ~ d*x1 + e*x2 + f*x3
    y3 ~ g*y1 + h*y2 + i*x2

    # indirect effects
    ind.y3.y1.x1 := g*a
    ind.y3.y2.x1 := h*d
    tot.y3.x1 := ind.y3.y1.x1 + ind.y3.y2.x1
'
lavaan.call <-  "sem" 
lavaan.args <- list(
  meanstructure = TRUE, se = "bootstrap"
)
test.comment <- ''
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
