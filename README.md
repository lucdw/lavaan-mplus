# lavaan-mplus

this project is intended to compare the results (parameters and fit measures) for the sem program Mplus and the sem R package lavaan

There are two main procedures:

-   rerun_mplus.R which recreates the Mplus output files (mplus program must be installed, of course)

-   run.all.tests.r which performs all comparisons defined in the subdirectories

At this moment the available subdirectories are

-   Bollen : examples from the work of Bollen

-   Categorical : sem with categorical variables

-   HS : based on HolzingerSwineford1939

-   HS_missing : idem, but with missing values

-   HS_multi : idem, with grouping

-   MPLUS_ex : examples of the Mplus documentation

-   Syntax : some special syntax examples

To perform a test one must have the output of a Mplus run, in a file which you let end in ".out", and the input data for the Mplus program.

Then we have a R source file, typically looking as follows:

```         
mplus.out <- "BB.mean.ML.out" # needed for batch-execution
library(lavaan)

Data <- read.table("BB.missing.raw", na.strings = "-999999", 
col.names = c("y1", "y2", "y3", "y4", "y5", "y6", "y7", "y8", "x1", "x2", "x3"))

model <- '
  # measurement model
    dem60 =~ y1 + y2 + y3 + y4
    dem65 =~ y5 + equal("dem60=~y2")*y6
                + equal("dem60=~y3")*y7
                + equal("dem60=~y4")*y8
    ind60 =~ x1 + x2 + x3

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'
fit <-  sem (model, data = Data
    , estimator  = "ML"
    , information  = "observed"
    , meanstructure  = TRUE
    , missing  = "ml"
    )
summary(fit)  # summary(...): removed if executed in batch

```

The following values are set:

-   mplus.out : the name of the mplus out file, when omitted the comparison with Mplus value will be skipped in run.all.tests

-   model : the model to use in lavaan

-   Data : the data.frame to use in lavaan (read from Mplus data + modify if necessary)

-   fit : fit the model with the data and possibly other parameters (do NOT specify mimic)

-   test.comment : optional comment on the test, which will also be copied in the logging.

When executing run.all.tests:

The R-file is executed with added parameter mimic ("lavaan"/"Mplus") and suppression of lines starting with 'summary'.
The resulting parameters from object fit are compared with those from Mplus. A logging of the differences and the output summary of the lavaan calls are generated.
