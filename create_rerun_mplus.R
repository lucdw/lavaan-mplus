testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
mplusgen <- "mplus_gen"
cat("Creating input files for MPlus regeneration of output.\n")
cat("STARTING TIME:", format(Sys.time()), "\n")
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  if (!dir.exists("mplus_gen")) dir.create(mplusgen)
  linuxcom <- file(paste0(mplusgen, "/rerun_mplus.sh"), "w")
  cat("#!/bin/sh\n", file = linuxcom)
  windowscom <- file(paste0(mplusgen, "/rerun_mplus.bat"), "w")
  cat("@echo off\n", file = windowscom)
  cat("Processing files in", basename(getwd()), "\n")
  testfiles <- list.files(pattern = "\\.dcf$")
  for (dcf.i in seq_along(testfiles)) {
    dcffile <- testfiles[dcf.i]
    dcf <- read.dcf(dcffile, all = TRUE)
    mplusfile <- dcf$mplus.out
    basis <- substr(dcffile, 1, nchar(dcffile) - 3)
    mplusin <- paste0(mplusgen, "/", basis, "in")
    tmp <- suppressWarnings(readLines(mplusfile))
    startline <- which(grepl("INPUT INSTRUCTIONS", tmp, fixed = TRUE))[1] + 1L
    endline <- which(grepl("INPUT READING TERMINATED", tmp, fixed = TRUE))[1] - 1L
    if (is.na(endline)) endline <- which(grepl("*** WARNING", tmp, fixed = TRUE))[1] - 1L
    writeLines(tmp[seq.int(startline, endline)], mplusin)
    cat ("mplus", mplusin, mplusfile, "\n", file = linuxcom)
    cat ("mplus", mplusin, mplusfile, "\n", file = windowscom)
  }
  close(linuxcom)
  close(windowscom)
  setwd("..")
}
cat("END TIME:", format(Sys.time()), "\n")
cat("Input files and examples of syntax for regeneration (Linux and Windows) are\n",
    "in subdirectories ", mplusgen, " of the test directories.\n", sep = "")