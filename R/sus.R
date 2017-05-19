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
#'sus(rep(1:20), trigger = 9)
#'@seealso \code{\link{ticker}}

sus <- function(val, trigger = 9) {
  stopifnot(
    is.numeric(val),
    is.numeric(trigger),
    length(trigger) == 1,
    length(val) > 0
  )

  base <- base_label <- val*NA

  if (length(which(!is.na(val))) < trigger - 1)
    return(df(base, base, base_label))

  base      <- rebase(base, start = index1(val), end = index8(val), new_vals = elems8(val))
  base_ext  <- rebase(base, start = index1(val), new_vals = base[index1(base)])
  start     <- index8(val)
  base_label[index1(val)] <- base[index1(val)]

  if (length(which(!is.na(val))) < 2*trigger - 1)
    return(df(base, base_ext, base_label))

  sus_first <- sus_first(base = base[index1(base)],
                         val = tail(val, -start),
                         trigger = trigger)

  while(!is.null(sus_first)) {

    sus_first   <- sus_first + start
    sus_first   <- head(sus_first, -1)

    base        <- rebase(base, start = sus_first[1],
                        end = sus_first[length(sus_first)],
                        new_vals = val[sus_first])
    base_ext    <- rebase(base_ext, start = sus_first[1],
                        new_vals = val[sus_first])
    base_label[sus_first[1]] <- base[sus_first[1]]
    start       <- sus_first[length(sus_first)]

    sus_first   <- sus_first(base = base_ext[length(base_ext)],
                           val = tail(val,-start),
                           trigger = trigger)

  }

  return(df(base, base_ext, base_label))

}
