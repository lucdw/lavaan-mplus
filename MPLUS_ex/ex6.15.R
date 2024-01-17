mplus.out <- "ex6.15.out" # needed for batch-execution
library(lavaan)

Data <- read.table("ex6.15.dat", na.strings = "-999999", 
col.names = c("u11", "u21", "u31", "u12", "u22", "u32", "u13", "u23", "u33"))

model <- '
    f1 =~ 1*u11 + l2*u21 + l3*u31
    f2 =~ 1*u12 + l2*u22 + l3*u32
    f3 =~ 1*u13 + l2*u23 + l3*u33
    f1 ~~ f1
    f2 ~~ f2
    f3 ~~ f3

    u11 + u12 + u13 | int1*t1
    u21 + u22 + u23 | int2*t1
    u31 + u32 + u33 | int3*t1

    u11 ~*~ 1*u11
    u21 ~*~ 1*u21
    u31 ~*~ 1*u31
    u12 ~*~ u12
    u22 ~*~ u22
    u32 ~*~ u32
    u13 ~*~ u13
    u23 ~*~ u23
    u33 ~*~ u33

    i =~ 1*f1 + 1*f2 + 1*f3
    s =~ 0*f1 + 1*f2 + 2*f3
    i ~~ i
    s ~~ s
    i ~~ s   
 
    # latent mean
    i ~ 0*1
    s ~ 1
'
fit <-  lavaan (model, data = Data
    , ordered  = c("u11", "u21", "u31", "u12", "u22", "u32", "u13", "u23", "u33"
)
    )
summary(fit, fit.measures = TRUE, rsquare = TRUE)
