source("test-utilities.R")
testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  cat("Processing of tests in", basename(getwd()), "\n")
  mplusfiles <- list.files(pattern = "\\.mplus\\.out$")
  file.remove(list.files(pattern = "\\.dcf$"))
  for (mplus.i in seq_along(mplusfiles)) {
    test.object <- list()
    mplusfile <- mplusfiles[mplus.i]
    cat("        handling ", mplusfile, "\n")
    parts <- strsplit(mplusfile, ".", fixed = TRUE)[[1]]
    if (length(parts) < 4) parts <- c("", "mean", "ML", "default")
    sink(tempfile())
    mplus.model <- readModels(mplusfile)
    sink()
    test.object$mplus.out <- mplusfile
    test.object$model <- paste0(mplus.model$input$data$file, ".lmd")
    test.object$model.type <- "sem"
    test.object$estimator <- parts[3]
    test.object$information <- ifelse(any(parts[4] == c("expected", "observed")), parts[4], "default")
    test.object$se <- ifelse(parts[4] == "bootstrap", "bootstrap", "default")
    if (test.object$se == "bootstrap") test.object$information <- "observed"
    test.object$meanstructure <- (parts[2] == "mean")
    test.object$missing <- "default"
    test.object$group <- ""
    test.object$group.equal <- ""
    test.object$group.partial <- ""
    test.object$mimic <- "Both"
    tobj <- as.data.frame(test.object)
    write.dcf(tobj, 
              file=paste0(gsub("\\.", "_", 
                               substring(mplusfile, 1, nchar(mplusfile) - 10L)),
                               ".dcf"))
  }
  setwd("..")
}
cat("ENDING TIME:", format(Sys.time()), "\n")
