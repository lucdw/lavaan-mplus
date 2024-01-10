wd <- getwd()
testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
mplusgen <- "mplus_gen"
group.environment <- "empty"
cat("Creating input files for MPlus regeneration of output.\n")
cat("STARTING TIME:", format(Sys.time()), "\n")
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  if (!dir.exists("mplus_gen")) dir.create(mplusgen)
  existingfiles <- list.files("mplus_gen")
  if (length(existingfiles) > 0L) {
    file.remove(paste("mplus_gen", existingfiles, sep="/"))
  }
  linuxcom <- file(paste0(mplusgen, "/rerun_mplus.sh"), "w")
  cat("#!/bin/sh\n", file = linuxcom)
  windowscom <- file(paste0(mplusgen, "/rerun_mplus.bat"), "w")
  cat("@echo off\n", file = windowscom)
  cat("cd \"", normalizePath(getwd()), "\"\n", sep = "", file = windowscom)
  on.exit({
    setwd(wd)
  })
  cat("Processing of tests in", basename(getwd()), "\n")
  testfiles <- list.files(pattern = "\\.R$")
  for (test.i in seq_along(testfiles)) {
    testfile <- testfiles[test.i]
    cat("        handling ", testfile, "\n")
    source(testfile)
#    execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, group.environment)
    basis <- substr(testfile, 1, nchar(testfile) - 1)
    mplusin <- paste0(mplusgen, "/", basis, "in")
    tmp <- suppressWarnings(readLines(mplus.out))
    startline <- which(grepl("INPUT INSTRUCTIONS", tmp, fixed = TRUE))[1] + 1L
    endline <- which(grepl("INPUT READING TERMINATED", tmp, fixed = TRUE))[1] - 1L
    if (is.na(endline)) endline <- which(grepl("*** WARNING", tmp, fixed = TRUE))[1] - 1L
    writeLines(tmp[seq.int(startline, endline)], mplusin)
    cat ("mplus", mplusin, mplus.out, "\n", file = linuxcom)
    cat ("mplus", mplusin, mplus.out, "\n", file = windowscom)
  }
  close(linuxcom)
  close(windowscom)
  setwd(wd)
}
cat("END TIME:", format(Sys.time()), "\n")
cat("Input files and examples of syntax for regeneration (Linux and Windows) are\n",
    "in subdirectories ", mplusgen, " of the test directories.\n", sep = "")