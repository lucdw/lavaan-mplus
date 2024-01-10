wd <- getwd()
testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
source("utilities.R")
group.environment <- new.env()
assign("i", 0L, group.environment)
cat("STARTING TIME:", format(Sys.time()), "\n")
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
    source(testfile)
    extest <- execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment, group.environment)
    if (is.character(extest)) cat(extest, "\n")
  }
  setwd(wd)
}
max.i <- get("i", group.environment)
reportcon <- file("report.txt", "wt")
cat("Current lavaan version :", 
    packageDescription("lavaan", fields = "Version"), 
    "\n*******************************\n\n",
    file = reportcon)
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