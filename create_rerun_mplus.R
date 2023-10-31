testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
mplusgen <- "mplus_gen"
linuxcom <- c("#!/bin/sh", "", paste0("for f in ", mplusgen, "/*.mplus.in"), "do", 
              "  FILE=`basename $f .mplus.in`", 
              paste0("  mplus ", mplusgen, "/$FILE.mplus.in $FILE.mplus.out"), "done")
windowscom <- c("@echo off", "", paste0("for f in ", mplusgen, "/*.mplus.in"), "do", 
              "  FILE=`basename $f .mplus.in`", 
              paste0("  mplus ", mplusgen, "/$FILE.mplus.in $FILE.mplus.out"), "done")
# TODO: aanpassen windows commando's, check linux commando's met Yves
cat("Creating input files for MPlus regeneration of output.")
cat("STARTING TIME:", format(Sys.time()), "\n")
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  if (!dir.exists("mplus_gen")) dir.create(mplusgen)
  writeLines(linuxcom, paste0(mplusgen, "/rerun_mplus.sh"))    
  writeLines(windowscom, paste0(mplusgen, "/rerun_mplus.bat"))    
  cat("Processing files in", basename(getwd()), "\n")
  mplusfiles <- list.files(pattern = "\\.mplus\\.out$")
  for (mplus.i in seq_along(mplusfiles)) {
    mplusfile <- mplusfiles[mplus.i]
    basis <- substr(mplusfile, 1, nchar(mplusfile) - 3)
    mplusin <- paste0(mplusgen, "/", basis, "in")
    tmp <- suppressWarnings(readLines(mplusfile))
    startline <- which(grepl("INPUT INSTRUCTIONS", tmp, fixed = TRUE))[1] + 1L
    endline <- which(grepl("INPUT READING TERMINATED", tmp, fixed = TRUE))[1] - 1L
    writeLines(tmp[seq.int(startline, endline)], mplusin)
  }
  setwd("..")
}
cat("END TIME:", format(Sys.time()), "\n")
cat("Input files and examples of syntax for regeneration (Linux and Windows) are\n",
    "in subdirectories ", mplusgen, " of the test directories.\n", sep = "")