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
#'sus_first(rep(0,20), 1:20, trigger = 9)
#'@seealso \code{\link{ticker}} \code{\link{sus()}}

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

  ticker <- ticker(base, val)

  while(is.null(ticker()))
    NULL

  if (is.numeric(ticker()))
    return(ticker())
  else
    return(NULL)
}
