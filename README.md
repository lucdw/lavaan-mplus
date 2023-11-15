# lavaan-mplus
this project is intended to compare the results (parameters and fit measures) for the sem program Mplus and the sem R package lavaan

There are two main procedures: 
* create_rerun_mplus.R which creates input files and batch jobs (linux and windows) to re-execute the mplus program 
* run.all.tests.r which performs all comparisons defined in the subdirectories

At this moment the available subdirectories are 
* Bollen        : examples from the work of Bollen
* Categorical   : sem with categorical variables
* HS            : based on HolzingerSwineford1939 
* HS_missing    : idem, but with missing values
* HS_multi      : idem, with grouping
* MPLUS_ex      : examples of the Mplus documentation
* Syntax        : some special syntax examples

To perform a test one must have the output of a Mplus run, in a file which you let end in ".out", and the input data for the Mplus program.

Then we have a R source file, typically looking as follows:
```
mplus.out <- "HS.mean.ML.bootstrap.mplus.out" 
lavaan.model <- '
  visual  =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9
'
lavaan.call <-  "sem" 
lavaan.args <- list(
   estimator = "ML",
   information = "observed",
   se = "bootstrap",
   bootstrap = 200,
   meanstructure = TRUE)
test.comment <- '
because of random samples in bootstrap, 
fitted values will change on every run!
'
if (!exists("group.environment") || is.null(group.environment)) {
   source("../utilities.R", chdir = TRUE)
   execute_test(mplus.out, lavaan.model, lavaan.call, lavaan.args, test.comment)
}
```
The following values are set:
mplus.out : the name of the mplus out file
lavaan.model : the model to use in lavaan
lavaan.call : the model type to use in lavaan (sem, cfa, growth, ...)
lavaan.args : the parameters to specify for the call (except model, data and mimic)
test.comment : optional comment on the test, which will also be copied in the logging
The following lines execute the test if the file is sourced directly (not as a result of sourcing run.all.tests.r, where this is done the 'calling' script).

When executing:

The name and structure of the mplus input file is, with the help of the MplusAutomation R package, derived from the content of the mplus output file, whereafter the input data.frame for lavaan is created.

Then the lavaan function is called and the resulting parameters are compared with those from Mplus. 
A logging of the differences and the output summary of the lavaan calls are generated.
