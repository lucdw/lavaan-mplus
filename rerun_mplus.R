wd <- getwd()
testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
if (!any("Bollen" == testdirs)) stop(getwd(), " is not the main directory of tests!")
testdirs <- testdirs[grepl("^[^.]", testdirs)]
isWindows <- (.Platform$OS.type == "windows")
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  on.exit({
    setwd(wd)
  })
  existingfiles <- list.files(".")
  infiles <- existingfiles[grepl("\\.in$", existingfiles, ignore.case = TRUE)]
  outfiles <- sub("in$", "out", infiles, ignore.case = TRUE)
  cat("Processing of .in files in", basename(getwd()), "\n")
  for (in.i in seq_along(infiles)) {
    infile <- infiles[in.i]
    outfile <- outfiles[in.i] 
    cat("   Mplus ", infile, "-->", outfile, "\n")
    if (isWindows) {
      tmp <- shell(paste("mplus.exe", infile, outfile), intern = TRUE)
    } else {
      tmp <- system(paste("mplus", infile, outfile), intern = TRUE)
    }
  }
  setwd(wd)
}
cat("\nall done\n")