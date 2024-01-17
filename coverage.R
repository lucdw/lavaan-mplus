setwd("C:/GitHub/lavaan-mplus")
rat <- '
wd <- getwd()
testdirs <- list.dirs(full.names = FALSE, recursive = FALSE)
testdirs <- testdirs[grepl("^[^.]", testdirs)]
for (testdir.i in seq_along(testdirs)) {
  setwd(testdirs[testdir.i])
  on.exit({
    setwd(wd)
    })
  testfiles <- list.files(pattern = "\\\\.R$")
  for (test.i in seq_along(testfiles)) {
    testfile <- testfiles[test.i]
    source(testfile)
  }
  setwd(wd)
}
'
cover <- covr::package_coverage("C:/GitHub/lavaan", type="none", code = strsplit(rat, "\n")[[1]])
covr::report(x = cover, file = "c:/temp/lavaan-mplus.html")