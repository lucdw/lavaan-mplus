library(lavaan)
options(warn = -1)
suppressMessages(library(MplusAutomation, quietly = TRUE))
options(warn = 1)
# function to read the R file, modify the line 'fit <- ...' to include mimic = ...,
# remove lines beginning with 'summary' and source the result
adapt_and_source <- function(rfile, mimic = c("lavaan", "Mplus")) {
  mimic <- match.arg(mimic)
  rfilenu <- parse(file = rfile, keep.source = TRUE)
  rfiledf <- getParseData(rfilenu, includeText = TRUE)
  fitje <- which(grepl("^fit *<- ", rfiledf$text))
  fitjeendline <- rfiledf$line2[fitje]
  fitjeendcol <- rfiledf$col2[fitje]
  rfilelines <- readLines(rfile)
  rfilelines[fitjeendline] <- paste0(
    substr(rfilelines[fitjeendline], 1, fitjeendcol - 1),
    ", mimic = \"", mimic, "\"",
    substr(rfilelines[fitjeendline], fitjeendcol, nchar(rfilelines[fitjeendcol]))
  )
  todelete <- grepl("^ *summary", rfilelines)
  if (any(todelete)) rfilelines <- rfilelines[!todelete]
  txtcon <- textConnection(rfilelines, name = "adapted")
  source(txtcon)
  close(txtcon)
}

# function to execute test with parameters set in .R files in subdirectories
# group.environment is NULL when function is called from this R-file
# the logging of differences is stored in the group.environment or displayed immediately
execute_test <- function(rfile, group.environment = NULL) {
  stopifnot(is.character(rfile), length(rfile) == 1L)
  for (mimic in c("lavaan", "Mplus")) {
    test.comment <- ""
    if (exists("mplus.out")) rm(mplus.out, inherits = TRUE)
    if (exists("fit")) rm(fit, inherits = TRUE)
    adapt_and_source(rfile, mimic)
    if (!exists("mplus.out")) {
      return(paste0("Warning: mplus.out not defined!"))
    }
    if (!exists("fit")) {
      return(paste0("Error: fit not defined!"))
    }
    if (!file.exists(mplus.out)) {
      return(paste0("Error: Cannot find ", mplus.out, " in ", getwd(), "!"))
    }
    sink(tempfile())
    mplus.model <- readModels(mplus.out)
    sink()
    if (is.null(mplus.model$parameters)) return("Error: Mplus parameters NULL!")
    if (length(mplus.model$parameters) == 0) return("Error: 0 Mplus parameters!")
    res <- one_test_mplus(mplus.out, fit, mimic, mplus.model, test.comment)
    if (mimic == "Mplus") res2 <- res
    if (mimic != "Mplus") res1 <- res
  }
  i <- get("i", group.environment)
  i <- i + 1L
  assign("i", i, group.environment)
  ich <- formatC(i, width = 4, flag = "0")
  df1 <- data.frame(
    mplus.out = mplus.out,
    lavDpar = res1[[1]][1],
    lavNApar = res1[[1]][2],
    lavDfit = res1[[1]][3],
    mplDpar = res2[[1]][1],
    mplNApar = res2[[1]][2],
    mplDfit = res2[[1]][3]
  )
  assign(paste0("res", ich), df1, group.environment)
  assign(paste0("lav", ich), res1[[2]], group.environment)
  assign(paste0("mpl", ich), res2[[2]], group.environment)
  invisible(TRUE)
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
  mpl.idx <- rep(NA_integer_, length(lav$lhs))
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
      cat("lav param not found in mpl: ",
          paste(lav$lhs[i], lav$op[i], lav$rhs[i], sep = ""), "\n")
    } else if (length(idx) > 1L) {
      cat("lav param matched multiple elements in mpl: ",
          paste(lav$lhs[i], lav$op[i], lav$rhs[i], sep = ""), "\n")
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
  if (!is.null(mpl$unstandardized)) {
    lav.df <- data.frame(lhs = lav$lhs, op = lav$op, rhs = lav$rhs, group = lav$group,
                     type = "est", lav = round(lav$est, 3),
                     mpl = mpl$unstandardized$est[mpl.idx])
    df1 <- data.frame(lhs = lav$lhs, op = lav$op, rhs = lav$rhs, group = lav$group,
                      type = "se", lav = round(lav$se, 3),
                      mpl = mpl$unstandardized$se[mpl.idx])
    lav.df <- rbind(lav.df, df1, make.row.names = FALSE)
  }
  if (!is.null(mpl$std.standardized)) {
    df1 <- data.frame(lhs = lav$lhs, op = lav$op, rhs = lav$rhs, group = lav$group,
                      type = "est.std", lav = round(lav$std.lv, 3),
                      mpl = mpl$std.standardized$est[mpl.idx])
    if (exists("lav.df", inherits = FALSE)) {
      lav.df <- rbind(lav.df, df1, make.row.names = FALSE)
    } else {
      lav.df <- df1
    }
  }
  if (!is.null(mpl$stdyx.standardized)) {
    df1 <- data.frame(lhs = lav$lhs, op = lav$op, rhs = lav$rhs, group = lav$group,
                      type = "est.std.all", lav = round(lav$std.all, 3),
                      mpl = mpl$stdyx.standardized$est[mpl.idx])
    if (exists("lav.df", inherits = FALSE)) {
      lav.df <- rbind(lav.df, df1, make.row.names = FALSE)
    } else {
      lav.df <- df1
    }
  }
  if (!is.null(mpl$stdy.standardized)) {
    df1 <- data.frame(lhs = lav$lhs, op = lav$op, rhs = lav$rhs, group = lav$group,
                      type = "est.std.nox", lav = round(lav$std.nox, 3),
                      mpl = mpl$stdy.standardized$est[mpl.idx])
    if (exists("lav.df", inherits = FALSE)) {
      lav.df <- rbind(lav.df, df1, make.row.names = FALSE)
    } else {
      lav.df <- df1
    }
  }
  # if (length(mpl) == 5L) { # unstandardized + r2 + stdyx + stdy + std
  #   lav.df <- data.frame(lhs = rep(lav$lhs, times = 5),
  #                      op = rep(lav$op,  times = 5),
  #                      rhs = rep(lav$rhs, times = 5),
  #                      group = rep(lav$group, times = 5),
  #                      type = rep(c("est", "se",
  #                                   "est.std", "est.std.all", "est.std.nox"),
  #                                 each = nrow(lav)),
  #                      lav = round(c(lav$est, lav$se,
  #                                     lav$std.lv, lav$std.all,
  #                                     lav$std.nox), 3),
  #                      mpl = c(mpl$unstandardized$est[mpl.idx],
  #                              mpl$unstandardized$se[mpl.idx],
  #                              mpl$std.standardized$est[mpl.idx],
  #                              mpl$stdyx.standardized$est[mpl.idx],
  #                              mpl$stdy.standardized$est[mpl.idx]))
  # } else if (length(mpl) == 4L) { # unstandardized + r2 + stdyx + std
  #   lav.df <- data.frame(lhs = rep(lav$lhs, times = 4),
  #                      op = rep(lav$op,  times = 4),
  #                      rhs = rep(lav$rhs, times = 4),
  #                      group = rep(lav$group, times = 4),
  #                      type = rep(c("est", "se",
  #                                   "est.std", "est.std.all"),
  #                                 each = nrow(lav)),
  #                      lav = round(c(lav$est, lav$se,
  #                                     lav$std.lv, lav$std.all), 3),
  #                      mpl = c(mpl$unstandardized$est[mpl.idx],
  #                              mpl$unstandardized$se[mpl.idx],
  #                              mpl$std.standardized$est[mpl.idx],
  #                              mpl$stdyx.standardized$est[mpl.idx]))
  # } else if (length(mpl) == 1L) { # unstandardized + se
  #   lav.df <- data.frame(lhs = rep(lav$lhs, times = 2),
  #                      op = rep(lav$op,  times = 2),
  #                      rhs = rep(lav$rhs, times = 2),
  #                      group = rep(lav$group, times = 2),
  #                      type = rep(c("est", "se"), each = nrow(lav)),
  #                      lav = round(c(lav$est, lav$se), 3),
  #                      mpl = c(mpl$unstandardized$est[mpl.idx],
  #                              mpl$unstandardized$se[mpl.idx]))
  # } else {
  #   stop("length(mpl) == ", length(mpl))
  # }
  lav.df$delta <- (round(lav.df$lav, 3) - lav.df$mpl)
  lav.df
}

# joint fit measures lav mpl
join_fit_lav_mplus <- function(lav, mpl) {
  # match fit names in mpl
  lav.names <- names(lav)
  names.lav <- c("chisq", "df", "pvalue", "baseline.chisq", "chisq.scaling.factor",
                 "baseline.df", "baseline.pvalue", "cfi", "tli", "logl",
                 "unrestricted.logl", "npar", "aic", "bic", "ntotal", "bic2",
                 "rmsea", "rmsea.ci.lower", "rmsea.ci.upper", "rmsea.pvalue", "srmr")
  names.mpl <- c("ChiSqM_Value", "ChiSqM_DF", "ChiSqM_PValue", "ChiSqBaseline_Value", "ChiSqM_ScalingCorrection",
                 "ChiSqBaseline_DF", "ChiSqBaseline_PValue", "CFI", "TLI", "LL",
                 "UnrestrictedLL", "Parameters", "AIC", "BIC", "Observations", "aBIC",
                 "RMSEA_Estimate", "RMSEA_90CI_LB", "RMSEA_90CI_UB", "RMSEA_pLT05", "SRMR")
  fit <- rep(as.numeric(NA), length(lav))
  for (i in seq_along(lav)) {
    j <- which(lav.names[i] == names.lav)
    if (length(j) == 0) j <- which(lav.names[i] == paste0(names.lav, ".scaled"))
    if (length(j) > 0) {
      mplname <- names.mpl[j]
      if (any(mplname == names(mpl))) fit[i] <- round(mpl[1, mplname], 3)
    }
  }
  lav.df <- data.frame(fit = names(lav),
                     lav = round(as.numeric(lav), 3),
                     mpl = fit)
  lav.df$delta <- (round(lav.df$lav, 3) - lav.df$mpl)
  lav.df
}

one_test_mplus <- function(mpl.file, fit, mimic, mplus.model, test.comment) {
  logfile <- file() # anonymous file connection, see R-help for file, examples
  on.exit({
    if (isOpen(logfile)) close(logfile)
    })
  log.file <- paste(mpl.file, "_mim", mimic, ".log", sep = "")
  mpl.file.dir <- basename(dirname(normalizePath(mpl.file)))
  cat("Mplus file: ", mpl.file.dir, "/", mpl.file,
      " (mimic = \"", mimic, "\")\n",
      sep = "", file = logfile)
  cat(strrep("=", 26 + nchar(mpl.file) + nchar(mpl.file.dir) + nchar(mimic)),
      "\n", file = logfile)
  if (test.comment != "") {
    cat("test comment:\n",
        gsub("\n", "\n# ", gsub("^ *\n", "# ", gsub("\n *$", "", test.comment))),
        "\n", sep = "", file = logfile)
  }
  mpl.par <- mplus.model$parameters
  lav.par <- try(parameterEstimates(fit, ci = FALSE, fmi = FALSE,
                                remove.system.eq = FALSE,
                                remove.eq = FALSE, remove.ineq = FALSE,
                                standardized = TRUE))
  if (inherits(lav.par, "try-error")) {
    sink(logfile)
    str(lav.par)
    cat("\n")
    sink()
    return(list(c(0L, 0L, 0L), readLines(logfile)))
  }
  if (fit@SampleStats@ngroups == 1L) lav.par$group <- rep(1L, length(lav.par$lhs))
  # remove some (fixed) parameters from lav.par (since they will not
  # be included in mpl.par)
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
  if (length(idx) > 0L && !fit@Options$int.ov.free) {
    lav.par <- lav.par[-idx, ]
    partable    <- partable[-idx, ]
  }
  # fixed lv intercepts?
  idx <- which(lav.par$op == "~1" & lav.par$lhs %in% lv.names
               & lav.par$se == 0.0)
  if (length(idx) > 0L && !fit@Options$int.lv.free) {
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
  lav.df.par <- try(join_par_lav_mplus(lav = lav.par, mpl = mpl.par,
                             group.label = fit@Data@group.label))
  if (inherits(lav.df.par, "try-error")) {
    sink(logfile)
    str(lav.df.par)
    cat("\n")
    sink()
    return(list(c(0L, 0L, 0L), readLines(logfile)))
  }
  # get fit measures
  mpl.fit <- mplus.model$summaries
  lav.fit <- fitMeasures(fit)
  # remove some fit values
  estimator <- fit@Options$estimator
  if (estimator %in% c("WLS", "WLSM", "WLSMV", "ULS", "ULSM", "ULSMV")) {
    idx <- which(names(lav.fit) == "srmr")
    if (length(idx) > 0L) lav.fit <- lav.fit[-idx]
  }
  if (estimator %in% c("MLMV", "MLMVS", "WLSM", "WLSMV", "ULSM", "ULSMV")) {
    idx <- which(names(lav.fit) == "chisq.scaling.factor")
    if (length(idx) > 0L) lav.fit <- lav.fit[-idx]
  }
  if (estimator %in% c("MLM", "MLMV", "MLMVS", "MLR",
                      "WLSM", "WLSMV", "ULSM", "ULSMV")) {
    # remove all non-scaled versions
    idx <- which(names(lav.fit) %in% c("chisq", "df", "pvalue",
                                        "baseline.chisq", "baseline.df", "baseline.pvalue",
                                        "cfi", "tli",
                                        "rmsea", "rmsea.ci.lower", "rmsea.ci.upper",
                                        "rmsea.pvalue"))
    lav.fit <- lav.fit[-idx]
  }
  # if (!is.null(test.object$group)) {
    idx <- which(names(lav.fit) == "ntotal")
    if (length(idx)) lav.fit <- lav.fit[-idx]
  # }
  # joint fit measures lav mpl
  lav.df.fit <- join_fit_lav_mplus(lav = lav.fit, mpl = mpl.fit)
  # write log
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
  # cat("Detailed output lavaan in", normalizePath(log.file), "\n", file = logfile)
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
  cat("\n\n", file = logfile)
  return(list(c(length(par.idx), length(na.idx), length(fit.idx)), readLines(logfile)))
}
