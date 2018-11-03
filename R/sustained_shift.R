#'Iterate through a vector and find the first sustained shift.
#'
#'Use this function to iterate through a vector by calling it multiple times
#'until it returns either: the indices of the first sustained shift; or the
#'string \code{No sus shift found}.
#'
#'@param base A numeric vector of length one. The current baseline value.
#'@param val A numeric vector. The vector \code{sus_ticker} iterates over.
#'@param trigger A numeric vector of length one. Specifies how many consecutive
#'  points are required for a sustained shift.
#'@return \code{NULL}, until either a sustained shift is found (then it returns
#'  the indices of the first sustained shift) or no sustained shift is found
#'  (then it returns the string \code{No sus shift found}). The indices of the
#'  first sustained shift (if one is found). Otherwise, \code{NULL}.
#'@examples
#'tick <- runchart:::sus_ticker(base = 2, val = 1:15)
#'tick()
#'tick()
#'tick()
# etc
#'@seealso \code{\link{sus}}
#'@keywords internal
#'@noRd

sus_ticker <- function(base, val, trigger = 9) {
  stopifnot(
    is.numeric(base),
    is.numeric(val),
    length(base) == 1,
    length(val) > 1
  )

  start  <- min(which(base != val))
  updown <- sign(val[start] - base)

  sus_indices <- start
  index       <- start

  function() {
    index <<- index + 1

    if (length(sus_indices) >= trigger) return(sus_indices)
    if (index > length(val))     return("No sus shift found")

    if (val[index] %in% c(NA, base)) {
      NULL
    }
    else if (sign(val[index] - base) == updown) {
      sus_indices <<- append(sus_indices, index)
    }
    else {
      sus_indices <<- index
      updown <<- sign(val[index] - base)
    }

    return(NULL)
  }
}

###############################################################################

#'Indices of the first sustained shift of \code{val}.
#'
#'A sustained shift is defined by 9 consecutive data points either all above or
#'all below the current baseline.
#'
#'@param base A numeric vector of length \code{1}.
#'@param val \code{sus_first} iterates along the elements of \code{val}.
#'@param trigger Number of data points required to create a sustained shift.
#'@return The indices of the first sustained shift of \code{val}. \code{sus_first}
#'  returns \code{NULL} if no sustained shift is found.
#'@examples
#'runchart:::sus_first(base = 0, val = 1:20)
#'@seealso \code{\link{sus_ticker}} \code{\link{sus}}
#'@keywords internal
#'@noRd

sus_first <- function(base, val, trigger = 9) {

  if (length(val) < trigger)
    return(NULL)

  stopifnot(
    is.numeric(base),
    is.numeric(val),
    is.numeric(trigger),
    length(base) == 1,
    length(trigger) == 1
  )

  if (sum(val %notin% c(NA, base)) < trigger)
    return(NULL)

  sus_ticker <- sus_ticker(base = base, val = val, trigger = trigger)

  while (is.null(sus_ticker()))
    NULL

  if (is.numeric(sus_ticker()))
    return(sus_ticker())
  else
    return(NULL)
}

###############################################################################

#'Create baseline(s) for \code{val}.
#'
#'The first baseline for \code{val} is the median of the first 8 useful
#'observations of \code{val}. It stretches from the first useful observation to
#'the 8th useful observation and is often black. A second line of the same value
#'is usually extended from the beginning of the black line to the end of
#'\code{val}. This second line is for visual comparison later in \code{val} and
#'is usually grey.
#'
#'If a sustained shift is detected after the first 8 useful data points, the
#'baseline is redrawn using the first 8 useful observations in the sustained
#'shift. Given a vector \code{val} the function \code{sus()} returns both the
#'grey and black lines in a \code{data.frame}.
#'
#'@param val \code{sus()} iterates along the elements of \code{val} to create
#'  baselines.
#'@param trigger Number of data points required to create a sustained shift.
#'@return A data.frame with two columns: 1. The median of the first n useful
#'  observations of a sustained shift (where n defaults to 8) 2: The same as the
#'  previous column, but with each median value extended to either the end of
#'  \code{val} or the beginning of the next sustained shift.
#'@examples
#'runchart:::sus(rep(1:20), trigger = 9)
#'@seealso \code{\link{ticker}}
#'@keywords internal
#'@noRd

sus <- function(val, trigger = 9) {
  stopifnot(
    is.numeric(val),
    is.numeric(trigger),
    length(trigger) == 1,
    length(val) > 0
  )

  base <- base_label <- val * NA

  if (length(which(!is.na(val))) < trigger - 1)
    return(df(base, base, base_label))

  base      <- rebase(base, start = index1(val),
                      end = index8(val, n = trigger - 1),
                      new_vals = elems8(val, n = trigger - 1))
  base_ext  <- rebase(base, start = index1(val), new_vals = base[index1(base)])
  start     <- index8(val, n = trigger - 1)
  base_label[index1(val)] <- base[index1(val)]

  if (length(which(!is.na(val))) < 2 * trigger - 1)
    return(df(base, base_ext, base_label))

  sus_first <- sus_first(base = base[index1(base)],
                         val = utils::tail(val, -start),
                         trigger = trigger)

  while (!is.null(sus_first)) {

    sus_first   <- sus_first + start
    sus_first   <- utils::head(sus_first, -1)

    base        <- rebase(base, start = sus_first[1],
                        end = sus_first[length(sus_first)],
                        new_vals = val[sus_first])
    base_ext    <- rebase(base_ext, start = sus_first[1],
                        new_vals = val[sus_first])
    base_label[sus_first[1]] <- base[sus_first[1]]
    start       <- sus_first[length(sus_first)]

    sus_first   <- sus_first(base = base_ext[length(base_ext)],
                           val = utils::tail(val, -start),
                           trigger = trigger)

  }

  return(df(base, base_ext, base_label))

}
