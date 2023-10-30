wd <- getwd()
if (exists("dfrestot")) rm(dfrestot)
testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
source("test-utilities.R")
cat("STARTING TIME:", format(Sys.time()), "\n")
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  logcon <- file("test_result.log", "wt")
  on.exit({
    try(close(logcon), silent = TRUE)
    setwd(wd)
    })
  cat("Processing of tests in", basename(getwd()), "\n")
  cat("Processing of tests in", basename(getwd()), "\n", file = logcon)
  testfiles <- list.files(pattern = "\\.dcf$")
  for (dcf.i in seq_along(testfiles)) {
    dcffile <- testfiles[dcf.i]
    cat("        handling ", dcffile, "\n")
    dcf <- read.dcf(dcffile, all = TRUE)
    if (dcf$meanstructure == "TRUE") dcf$meanstructure = TRUE
    if (dcf$meanstructure == "FALSE") dcf$meanstructure = FALSE
    mplusfile <- dcf$mplus.out
    sink(tempfile())
    mplus.model <- readModels(mplusfile)
    sink()
    dcf$data <- create_r_data(mplus.model$input$data$file, 
                              mplus.model$input$variable$names,
                              mplus.model$input$variable$categorical,
                              mplus.model$input$variable$grouping)
    if (dcf$mimic == "Both") {
      dcf$mimic <- "lavaan"
      res <- one_test_mplus(mplusfile, as.list(dcf), mplus.model$parameters, logcon)
      dcf$Dpar <- res[1]
      dcf$NApar <- res[2]
      dcf$Dfit <- res[3]
      if (!exists("dfres")) {
        dfres <- dcf
      } else {
        dfres <- rbind(dfres, dcf, make.row.names = FALSE)
      }
      dcf$mimic <- "Mplus"
    }
    res <- one_test_mplus(mplusfile, as.list(dcf), mplus.model$parameters, logcon)
    dcf$Dpar <- res[1]
    dcf$NApar <- res[2]
    dcf$Dfit <- res[3]
    if (!exists("dfres")) {
      dfres <- dcf
    } else {
      dfres <- rbind(dfres, dcf, make.row.names = FALSE)
    }
  }
  cat("End processing of tests in", basename(getwd()), "\n", file = logcon)
  close(logcon)
  saveRDS(dfres, "result.RDS")
  if (!exists("dfrestot")) {
    dfrestot <- dfres
  } else {
    dfrestot <- rbind(dfrestot, dfres, make.row.names = FALSE)
  }
  rm(dfres)
  setwd(wd)
}
cat("ENDING TIME:", format(Sys.time()), "\n")
View(dfrestot)
