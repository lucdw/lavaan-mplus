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

Then we have a file in DCF format (see help for read.dcf in R), typically looking as follows:
```
mplus.out: HS.mean.ML.expected.mplus.out 
model: HS.raw.lmd
model.type: sem
estimator: ML
information: expected
se: default
meanstructure: TRUE
missing: default
group:
group.equal:
group.partial:
mimic: Both
```

The first value is the name of the mplus out file, the second the name of the file where we put the lavaan model, the other parameters are input for the lavaan function.
The value "Both" for the mimic item means: test with mimic = 'lavaan' and with mimic = 'Mplus'.

The name and structure of the mplus input file is, with the help of the MplusAutomation R package, derived from the content of the mplus output file, whereafter the input data.frame for lavaan is created and stored in an RDS file.

When all tests are done the results in counts of differences are shown in a data.frame dfrestot, which is also stored in an RDS file.
