library(lavaan)
options(warn = -1)
suppressMessages(library(MplusAutomation, quietly = TRUE))
options(warn = 1)
split_range <- function(x) {
  if (!grepl("-", x, fixed = TRUE)) return(x)
  delen <- strsplit(x, "-", fixed = TRUE)[[1]]
  jj <- 1
  while(substr(delen[1], 1, jj) == substr(delen[2], 1, jj) && all(jj < nchar(delen))) jj <- jj + 1
  jja1 <- substring(delen[1],jj)
  jja2 <- substring(delen[2],jj)
  if (any(jja1 == letters)) {
    jj1 <- which(jja1 == letters)
    jj2 <- which(jja2 == letters)
    return(paste0(substr(delen[1], 1, jj - 1L), letters[seq.int(jj1, jj2)]))
  }
  if (any(jja1 == LETTERS)) {
    jj1 <- which(jja1 == LETTERS)
    jj2 <- which(jja2 == LETTERS)
    return(paste0(substr(delen[1], 1, jj - 1L), LETTERS[seq.int(jj1, jj2)]))
  }
  jj1 <- as.integer(substring(delen[1],jj))
  jj2 <- as.integer(substring(delen[2],jj))
  return(paste0(substr(delen[1], 1, jj - 1L), seq.int(jj1, jj2)))
}
create_r_data <- function(mplusdatafile, 
                          mplusinputvariablenames, 
                          mplusinputcategoricals = NULL,
                          mplusinputgrouping = NULL) {
  rdatafile <- paste0(mplusdatafile, ".rds")
  mplusinputvariables <- strsplit(mplusinputvariablenames, " ", fixed = TRUE)[[1]]
  columnnames <- unlist(lapply(mplusinputvariables, split_range))
  if (!file.exists(rdatafile) || file.mtime(mplusdatafile) > file.mtime(rdatafile)) {
    the.data <- read.table(mplusdatafile, na.strings = "-999999",
                           col.names = columnnames)
    if (!is.null(mplusinputcategoricals)) {
      mpluscategoricalvariables <- strsplit(mplusinputcategoricals, " ", fixed = TRUE)[[1]]
      factornames <- unlist(lapply(mpluscategoricalvariables, split_range))
      for (x in factornames) {
        the.data[[x]] <- ordered(the.data[[x]])
      }
    }
    if (!is.null(mplusinputgrouping)) {
      i1 <- regexpr(" ", mplusinputgrouping, fixed = TRUE)
      groupvar <- substring(mplusinputgrouping, 1L, i1 - 1L)
      elements <- strsplit(substring(mplusinputgrouping, i1 + 2L, nchar(mplusinputgrouping) - 1L),
                           "[ ,]+")[[1]]
      groupnew <- vector("character", length(the.data[[groupvar]]))
      for (element in elements) {
        elems <- strsplit(element, "=", fixed = TRUE)[[1]]
        groupnew[the.data[[groupvar]] == as.integer(elems[1])] <- elems[2]
      }
      the.data[[groupvar]] <- groupnew
    }
    saveRDS(the.data, file = rdatafile)
  }
  rdatafile
}

# match Mplus parameters with lavaan parameters
# (based on the names and variable type)
match_mplus_param <- function(lav = NULL, mpl = NULL, group.label = character(0)) {

  # replace '|t' by '$' to match mplus thresholds
  idx <- which(lav$op == "|")
  if (length(idx) > 0L) {
    lav$rhs[idx] <- paste(lav$lhs[idx], gsub("t", "$", x = lav$rhs[idx]), sep = "")
  }

  mpl.lhs <- tolower(mpl$unstandardized$paramHeader)
  mpl.rhs <- tolower(mpl$unstandardized$param)
  mpl.idx <- integer(nrow(lav))

  # groups?
  if (length(group.label) > 0L) {
    group.label <- tolower(group.label)
    mpl.group <- tolower(mpl$unstandardized$Group)
    for (g in seq_along(group.label)) {
      idx <- which(lav$group == as.character(g))
      lav$group[idx] <- group.label[g]
    }
  } else {
    mpl.group <- rep(1L, length(mpl.lhs))
    #lav$group <- rep(1L, length(lav$lhs))
  }

  for (i in seq_along(lav$lhs)) {
    idx <- integer(0L)
    # find corresponding Mplus parameter
    if (lav$op[i] == "=~") {
      # try 1
      idx <- which(grepl(paste(lav$lhs[i], ".by", sep = ""), mpl.lhs) &
                     lav$group[i] == mpl.group &
                     mpl.rhs == lav$rhs[i])
      # try 2 (growth models)
      if (length(idx) == 0L) {
        idx <- which(grepl(paste(lav$lhs[i], ".\\|", sep = ""), mpl.lhs) &
                       lav$group[i] == mpl.group &
                       mpl.rhs == lav$rhs[i])
      }
    } else if (lav$op[i] == "~~") {
      if (lav$lhs[i] == lav$rhs[i]) {
        idx <- which(grepl("variances", mpl.lhs) &
                       lav$group[i] == mpl.group &
                       mpl.rhs == lav$rhs[i])
      } else {
        # try 1
        idx <- which(grepl(paste(lav$lhs[i], ".with", sep = ""),
                           mpl.lhs) &
                       lav$group[i] == mpl.group &
                       mpl.rhs == lav$rhs[i])
        # try 2
        if (length(idx) == 0L) {
          idx <- which(grepl(paste(lav$rhs[i], ".with", sep = ""),
                             mpl.lhs) &
                         lav$group[i] == mpl.group &
                         mpl.rhs == lav$lhs[i])
        }
      }
    } else if (lav$op[i] == "~") {
      idx <- which(grepl(paste(lav$lhs[i], ".on", sep = ""), mpl.lhs) &
                     lav$group[i] == mpl.group &
                     mpl.rhs == lav$rhs[i])
    } else if (lav$op[i] == "~1") {
      # try 1
      idx <- which(grepl("intercepts", mpl.lhs) &
                     lav$group[i] == mpl.group &
                     mpl.rhs == lav$lhs[i])
      # try 2
      if (length(idx) == 0L) {
        idx <- which(grepl("means", mpl.lhs) &
                       lav$group[i] == mpl.group &
                       mpl.rhs == lav$lhs[i])
      }
    } else if (lav$op[i] == "|") {
      idx <- which(grepl("thresholds", mpl.lhs) &
                     lav$group[i] == mpl.group &
                     mpl.rhs == lav$rhs[i])
    } else if (lav$op[i] == "~*~") {
      idx <- which(grepl("scales", mpl.lhs) &
                     lav$group[i] == mpl.group &
                     mpl.rhs == lav$rhs[i])
    }
    # check if found
    if (length(idx) == 0L) {
      browser()
      stop("lav param not found in mpl: ",
           paste(lav$lhs[i], lav$op[i], lav$rhs[i], sep = ""))
    } else if (length(idx) > 1L) {
      stop("lav param matched multiple elements in mpl: ",
           paste(lav$lhs[i], lav$op[i], lav$rhs[i], sep = ""))
    } else {
      mpl.idx[i] <- idx
    }
  }
  mpl.idx
}

# join lav/Mplus, put est/se/est.std/est.std.all/est.std.nox under each other
# otherwise, the table would be too wide
join_par_lav_mplus <- function(lav = NULL, mpl = NULL, group.label = character(0)) {
  mpl.idx <- match_mplus_param(lav = lav, mpl = mpl, group.label = group.label)
  if (length(mpl) == 5L) { # unstandardized + r2 + stdyx + stdy + std
    lav.df <- data.frame(lhs = rep(lav$lhs, times = 5),
                       op = rep(lav$op,  times = 5),
                       rhs = rep(lav$rhs, times = 5),
                       group = rep(lav$group, times = 5),
                       type = rep(c("est", "se",
                                    "est.std", "est.std.all", "est.std.nox"),
                                  each = nrow(lav)),
                       lav = round(c(lav$est, lav$se,
                                      lav$std.lv, lav$std.all,
                                      lav$std.nox), 3),
                       mpl = c(mpl$unstandardized$est[mpl.idx],
                               mpl$unstandardized$se[mpl.idx],
                               mpl$std.standardized$est[mpl.idx],
                               mpl$stdyx.standardized$est[mpl.idx],
                               mpl$stdy.standardized$est[mpl.idx]))
  } else if (length(mpl) == 4L) { # unstandardized + r2 + stdyx + std
    lav.df <- data.frame(lhs = rep(lav$lhs, times = 4),
                       op = rep(lav$op,  times = 4),
                       rhs = rep(lav$rhs, times = 4),
                       group = rep(lav$group, times = 4),
                       type = rep(c("est", "se",
                                    "est.std", "est.std.all"),
                                  each = nrow(lav)),
                       lav = round(c(lav$est, lav$se,
                                      lav$std.lv, lav$std.all), 3),
                       mpl = c(mpl$unstandardized$est[mpl.idx],
                               mpl$unstandardized$se[mpl.idx],
                               mpl$std.standardized$est[mpl.idx],
                               mpl$stdyx.standardized$est[mpl.idx]))
  } else if (length(mpl) == 1L) { # unstandardized + se
    lav.df <- data.frame(lhs = rep(lav$lhs, times = 2),
                       op = rep(lav$op,  times = 2),
                       rhs = rep(lav$rhs, times = 2),
                       group = rep(lav$group, times = 2),
                       type = rep(c("est", "se"), each = nrow(lav)),
                       lav = round(c(lav$est, lav$se), 3),
                       mpl = c(mpl$unstandardized$est[mpl.idx],
                               mpl$unstandardized$se[mpl.idx]))
  } else {
    stop("length(mpl) == ", length(mpl))
  }
  lav.df$delta <- (round(lav.df$lav, 3) - lav.df$mpl)
  lav.df
}

# joint fit measures lav mpl
join_fit_lav_mplus <- function(lav, mpl) {
  # match fit names in mpl
  lav.names <- names(lav)
  fit <- rep(as.numeric(NA), length(lav))
  for (i in seq_along(lav)) {
    if (lav.names[i] == "chisq" ||
       lav.names[i] == "chisq.scaled") {
      fit[i] <- mpl[1, "ChiSqM_Value"]
    } else if (lav.names[i] == "df" ||
              lav.names[i] == "df.scaled") {
      fit[i] <- mpl[1, "ChiSqM_DF"]
    } else if (lav.names[i] == "pvalue" ||
              lav.names[i] == "pvalue.scaled") {
      fit[i] <- round(mpl[1, "ChiSqM_PValue"], 3)
    } else if (lav.names[i] == "baseline.chisq" ||
              lav.names[i] == "baseline.chisq.scaled") {
      fit[i] <- mpl[1, "ChiSqBaseline_Value"]
    } else if (lav.names[i] == "chisq.scaling.factor") {
      fit[i] <- mpl[1, "ChiSqM_ScalingCorrection"]
    }else if (lav.names[i] == "baseline.df" ||
             lav.names[i] == "baseline.df.scaled") {
      fit[i] <- mpl[1, "ChiSqBaseline_DF"]
    } else if (lav.names[i] == "baseline.pvalue" ||
              lav.names[i] == "baseline.pvalue.scaled") {
      fit[i] <- mpl[1, "ChiSqBaseline_PValue"]
    } else if (lav.names[i] == "cfi" ||
              lav.names[i] == "cfi.scaled") {
      fit[i] <- mpl[1, "CFI"]
    } else if (lav.names[i] == "tli" ||
              lav.names[i] == "tli.scaled") {
      fit[i] <- mpl[1, "TLI"]
    } else if (lav.names[i] == "logl") {
      fit[i] <- mpl[1, "LL"]
    } else if (lav.names[i] == "unrestricted.logl") {
      fit[i] <- mpl[1, "UnrestrictedLL"]
    } else if (lav.names[i] == "npar") {
      fit[i] <- mpl[1, "Parameters"]
    } else if (lav.names[i] == "aic") {
      fit[i] <- mpl[1, "AIC"]
    } else if (lav.names[i] == "bic") {
      fit[i] <- mpl[1, "BIC"]
    } else if (lav.names[i] == "ntotal") {
      fit[i] <- mpl[1, "Observations"]
    } else if (lav.names[i] == "bic2") {
      fit[i] <- mpl[1, "aBIC"]
    } else if (lav.names[i] == "rmsea" ||
              lav.names[i] == "rmsea.scaled") {
      fit[i] <- mpl[1, "RMSEA_Estimate"]
    } else if (lav.names[i] == "rmsea.ci.lower" ||
              lav.names[i] == "rmsea.ci.lower.scaled") {
      fit[i] <- mpl[1, "RMSEA_90CI_LB"]
    } else if (lav.names[i] == "rmsea.ci.upper" ||
              lav.names[i] == "rmsea.ci.upper.scaled") {
      fit[i] <- mpl[1, "RMSEA_90CI_UB"]
    } else if (lav.names[i] == "rmsea.pvalue" ||
              lav.names[i] == "rmsea.pvalue.scaled") {
      fit[i] <- mpl[1, "RMSEA_pLT05"]
    } else if (lav.names[i] == "srmr") {
      fit[i] <- mpl[1, "SRMR"]
    }
  }
  lav.df <- data.frame(fit = names(lav),
                     lav = round(as.numeric(lav), 3),
                     mpl = fit)
  lav.df$delta <- (round(lav.df$lav, 3) - lav.df$mpl)
  lav.df
}

one_test_mplus <- function(mpl.file, test.object, mplus.model, logfile, log.lavoutput = TRUE) {
  cat("Mplus file: ", mpl.file, "\n", file = logfile)
  cat("estimator =", test.object$estimator, "information =",
        test.object$information, "meanstructure =", test.object$meanstructure, "\n", file = logfile)
  if (test.object$se == "boot" || test.object$se == "bootstrap") cat("se = BOOTSTRAP\n", file = logfile)
  if (test.object$group != "") {
    if (grepl(";", test.object$group.equal)) test.object$group.equal <- strsplit(test.object$group.equal, ";")[[1]]
    if (grepl(";", test.object$group.partial)) test.object$group.partial <- strsplit(test.object$group.partial, ";")[[1]]
    cat("grouping variable: ", test.object$group, "\n", file = logfile)
    cat("group equality constraints: ",
        ifelse(is.null(test.object$group.equal), "none",
               paste(test.object$group.equal, collapse = " ")), "\n", file = logfile)
    cat("group partial equality: ",
        ifelse(is.null(test.object$group.partial), "none", test.object$group.partial), "\n", file = logfile)
  } else {
    test.object$group <- NULL
  }
  if (!is.null(test.object$missing)) cat("missing = ", test.object$missing, "\n", file = logfile)
  model <- paste(readLines(test.object$model, warn = FALSE), collapse = "\n")
  if (test.object$model.type == "sem" || test.object$model.type == "cfa") {
    fit <- sem(model, data = readRDS(test.object$data), estimator = test.object$estimator,
               information = test.object$information, meanstructure = test.object$meanstructure,
               mimic = test.object$mimic, se = test.object$se,
               group = test.object$group, missing = test.object$missing, bootstrap = 100L,
               group.equal = test.object$group.equal, group.partial = test.object$group.partial)
  } else if (test.object$model.type == "growth") {
    fit <- growth(model, data = readRDS(test.object$data), estimator = test.object$estimator,
                  information = test.object$information, mimic = test.object$mimic, se = test.object$se,
                  group = test.object$group, missing = test.object$missing,  bootstrap = 100L,
                  group.equal = test.object$group.equal, group.partial = test.object$group.partial)
  }
  cat("Lavaan total timing: ", fit@timing$total, file = logfile)
  cat(" -- mimic = ", fit@Options$mimic, "\n", file = logfile)
  cat(" Number of iterations: ", fit@optim$iterations, "\n", file = logfile)
  mpl.par <- mplus.model
  lav.par <- parameterEstimates(fit, ci = FALSE, fmi = FALSE,
                                remove.system.eq = FALSE,
                                remove.eq = FALSE, remove.ineq = FALSE,
                                standardized = TRUE)
  if (fit@SampleStats@ngroups == 1L) lav.par$group <- rep(1L, length(lav.par$lhs))
  # remove some (fixed) parameters from lav.par (since they will not
  # be included in mpl.par
  ov.names <- lavaan:::vnames(fit@ParTable, "ov")
  lv.names <- lavaan:::vnames(fit@ParTable, "lv")
  ov.ord   <- lavaan:::vnames(fit@ParTable, "ov.ord")
  partable <- as.data.frame(fit@ParTable, stringsAsFactors = FALSE)
  # rm 'da' entries from partable (if any)
  da.idx <- which(partable$op == "da")
  if (length(da.idx) > 0L) {
    partable <- partable[-da.idx, ]
  }
  # fixed ov intercepts?
  idx <- which(lav.par$op == "~1" & lav.par$lhs %in% ov.names
               & lav.par$se == 0.0)
  if (length(idx) > 0L && !fit@call$int.ov.free) {
    lav.par <- lav.par[-idx, ]
    partable    <- partable[-idx, ]
  }
  # fixed lv intercepts?
  idx <- which(lav.par$op == "~1" & lav.par$lhs %in% lv.names
               & lav.par$se == 0.0)
  if (length(idx) > 0L && !fit@call$int.lv.free) {
    lav.par <- lav.par[-idx, ]
    partable    <- partable[-idx, ]
  }
  # fixed.x
  idx <- which(partable$exo > 0L & lav.par$se == 0.0)
  if (length(idx) > 0L) {
    lav.par <- lav.par[-idx, ]
    partable    <- partable[-idx, ]
  }
  # variances of binary/ordinal variables (using delta parameterization)
  idx <- which(partable$op == "~~" &
                 partable$lhs == partable$rhs &
                 partable$lhs %in% ov.ord)
  if (length(idx) > 0L) {
    lav.par <- lav.par[-idx, ]
    partable    <- partable[-idx, ]
  }
  # intercepts of binary/ordinal variables
  idx <-  which(partable$op == "~1" &
                  partable$lhs %in% ov.ord)
  if (length(idx) > 0L) {
    lav.par <- lav.par[-idx, ]
    partable    <- partable[-idx, ]
  }
  # scale ~*~ parameters in single group
  if (fit@SampleStats@ngroups == 1L) {
    idx <- which(partable$op == "~*~")
    if (length(idx) > 0L) {
      lav.par <- lav.par[-idx, ]
      partable    <- partable[-idx, ]
    }
  }
  # p?__ == constraints
  idx <- which(partable$op == "==" & partable$user == 2L)
  if (length(idx) > 0L) {
    lav.par <- lav.par[-idx, ]
    partable    <- partable[-idx, ]
  }
  # join parameters lav and mpl
  lav.df.par <- join_par_lav_mplus(lav = lav.par, mpl = mpl.par,
                             group.label = fit@Data@group.label)
  # get fit measures
  #mpl.fit <- extractModelSummaries(mpl.file)
  #sink(tempfile()) # to avoid cat() output
  sink(tempfile())
  mpl.fit <- readModels(mpl.file)$summaries
  sink()
  lav.fit <- fitMeasures(fit)
  # remove some fit values
  if (test.object$estimator %in% c("WLS", "WLSM", "WLSMV", "ULS", "ULSM", "ULSMV")) {
    idx <- which(names(lav.fit) == "srmr")
    if (length(idx) > 0L) lav.fit <- lav.fit[-idx]
  }
  if (test.object$estimator %in% c("MLMV", "MLMVS", "WLSM", "WLSMV", "ULSM", "ULSMV")) {
    idx <- which(names(lav.fit) == "chisq.scaling.factor")
    if (length(idx) > 0L) lav.fit <- lav.fit[-idx]
  }
  if (test.object$estimator %in% c("MLM", "MLMV", "MLMVS", "MLR",
                      "WLSM", "WLSMV", "ULSM", "ULSMV")) {
    # remove all non-scaled versions
    idx <- which(names(lav.fit) %in% c("chisq", "df", "pvalue",
                                        "baseline.chisq", "baseline.df", "baseline.pvalue",
                                        "cfi", "tli",
                                        "rmsea", "rmsea.ci.lower", "rmsea.ci.upper",
                                        "rmsea.pvalue"))
    lav.fit <- lav.fit[-idx]
  }
  if (!is.null(test.object$group)) {
    idx <- which(names(lav.fit) == "ntotal")
    if (length(idx)) lav.fit <- lav.fit[-idx]
  }
  # joint fit measures lav mpl
  lav.df.fit <- join_fit_lav_mplus(lav = lav.fit, mpl = mpl.fit)
  if (log.lavoutput) {
    # write log
    log.file <- paste(mpl.file, "mim", test.object$mimic, ".log", sep = "")
    sink(log.file)
    # header
    version <- read.dcf(file = system.file("DESCRIPTION", package = "lavaan"),
                        fields = "Version")
    cat("# lavaan TESTsuite -- lavaan version ", version, "\n")
    cat("# date: ", date(), "\n")
    cat("# file: ", mpl.file, "\n\n")
    print(lav.df.par, max = 10000L)
    cat("\n")
    print(lav.df.fit, max = 10000L)
    sink()
  }
  par.idx <- which(abs(lav.df.par$delta) > 0.0005)
  cat("parameter values: number of delta's > 0.0005: ",
      length(par.idx), "\n", file = logfile)
  if (length(par.idx) > 0L) {
    sink(logfile)
    print(lav.df.par[par.idx, ])
    sink()
  }
  na.idx <- which(is.na(lav.df.par$delta))
  if (length(na.idx) > 0L) {
    cat("parameter values: number of NA's:", length(na.idx), "\n", file = logfile)
    sink(logfile)
    print(lav.df.par[na.idx, ])
    sink()
  }
  fit.idx <- which(abs(lav.df.fit$delta) > 0.0005)
  cat("fit values:       number of delta's > 0.0005: ",
      length(fit.idx), "\n", file = logfile)
  if (length(fit.idx) > 0L) {
    sink(logfile)
    print(lav.df.fit[fit.idx, ])
    sink()
  }
  cat("\n", file = logfile)
  return(c(length(par.idx), length(na.idx), length(fit.idx)))
}
