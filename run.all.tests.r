testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
source("test-utilities.R")
cat("STARTING TIME:", format(Sys.time()), "\n")
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  logcon <- file("test_result.log", "wt")
  cat("Processing of tests in", basename(getwd()), "\n", file = logcon)
  mplusfiles <- list.files(pattern = "\\.mplus\\.out$")
  for (mplus.i in seq_along(mplusfiles)) {
    test.object <- list()
    mplusfile <- mplusfiles[mplus.i]
    parts <- strsplit(mplusfile, ".", fixed = TRUE)[[1]]
    sink(tempfile())
    mplus.model <- readModels(mplusfile)
    sink()
    test.object$data <- create_r_data(mplus.model$input$data$file, mplus.model$input$variable$names)
    test.object$model <- suppressWarnings(readLines(paste0(mplus.model$input$data$file, ".lmd")))
    test.object$model.type <- "sem"
    test.object$estimator <- parts[3]
    test.object$information <- ifelse(any(parts[4] == c("expected", "observed")), parts[4], "default")
    test.object$se <- ifelse(parts[4] == "bootstrap", "bootstrap", "default")
    if (test.object$se == "bootstrap") test.object$information <- "observed"
    test.object$meanstructure <- (parts[2] == "mean")
    test.object$mimic <- "default"
    test.object$missing <- ifelse(mplus.model$input$data$listwise == "on", "listwise", "default")
    test.object$group <- ""
    test.object$group.equal <- ""
    test.object$group.partial <- ""
    test.object$log <- TRUE
    one_test_mplus(mplusfile, test.object, mplus.model$parameters, logcon)
    test.object$mimic <- "Mplus"
    one_test_mplus(mplusfile, test.object, mplus.model$parameters, logcon)
  }
  cat("End processing of tests in", basename(getwd()), "\n", file = logcon)
  close(logcon)
  setwd("..")
}
cat("ENDING TIME:", format(Sys.time()), "\n")
sink()