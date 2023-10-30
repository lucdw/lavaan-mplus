testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
source("test-utilities.R")
cat("STARTING TIME:", format(Sys.time()), "\n")
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  cat("entering", basename(getwd()), "...\n")
  mplusfiles <- list.files(pattern = "\\.mplus\\.out$")
  for (mplus.i in seq_along(mplusfiles)) {
    mplusfile <- mplusfiles[mplus.i]
    mplus.model <- readModels(mplusfile)
    rdatafile <- create_r_data(mplus.model$input$data$file, mplus.model$input$variable$names)
  }  
  setwd("..")
}
cat("ENDING TIME:", format(Sys.time()), "\n")
