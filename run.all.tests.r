rm(list =ls())
if (!file.exists("utilities.R")) stop("utilities.R not in current directory, wrong working directory?")
wd <- getwd()
testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
source("utilities.R")
group.environment <- new.env()
assign("i", 0L, group.environment)
cat("STARTING TIME:", format(Sys.time()), "\n")
extesterrors <- file()
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  on.exit({
    setwd(wd)
    })
  cat("Processing of tests in", basename(getwd()), "\n")
  testfiles <- list.files(pattern = "\\.R$")
  for (test.i in seq_along(testfiles)) {
    testfile <- testfiles[test.i]
    cat("        handling ", testfile, "\n")
    extest <- execute_test(testfile, group.environment)
    if (is.character(extest)) {
      cat("Comparison skipped: ", extest, "\n")
      cat(testfile, " --> ", extest, "\n", file = extesterrors)
      if (exists("test.comment")) cat(test.comment, "\n", file = extesterrors)
    }
  }
  setwd(wd)
}
max.i <- get("i", group.environment)
reportcon <- file("report.txt", "wt")
cat("Current lavaan version :", 
    packageDescription("lavaan", fields = "Version"), 
    "\n*******************************\n\n",
    file = reportcon)
cat("\nTests where comparison with Mplus is skipped: \n---------------------------------------------\n\n", file = reportcon)
cat(paste(readLines(extesterrors), collapse = "\n"), file=reportcon)
close(extesterrors)
cat("\n---------------------------------------------\n\n", file = reportcon)

for (i in seq_len(max.i)) {
  ich <- formatC(i, width=4, flag="0")
  df1 <- get(paste0("res", ich), group.environment)
  res1 <- get(paste0("lav", ich), group.environment)
  res2 <- get(paste0("mpl", ich), group.environment)
  cat(paste(res1, collapse="\n"), file=reportcon)
  cat(paste(res2, collapse="\n"), file=reportcon)
  if (i == 1) {
    df <- df1
  } else {
    df <- rbind(df, df1)
  }
}
close(reportcon)
rm(group.environment)
saveRDS(df, file = "result.rds")
cat("Logging of tests are in report.txt\n")
cat("Data.frame with overview (variable df) is saved in result.rds\n")
cat("ENDING TIME:", format(Sys.time()), "\n")
