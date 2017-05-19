#'Iterate through a vector and find the indices of all shifts relative to a
#'single (constant) baseline.
#'
#'Call this function once to iterate through all elements of a vector and return
#'the indices of all shifts relative to a single (constant) baseline. For a
#'changing baseline this function is used multiple times.
#'
#'@param base A numeric vector of length one. The current baseline value.
#'@param val A numeric vector. The vector \code{basic_shift} iterates over.
#'@param trigger The default number of observations for a shift is 6.
#'@return If shifts are found, the indices of these shifts. If not, \code{NULL}.
#'@examples
#'basic_shift(base = 2, val = 1:8)
#'basic_shift(base = 2, val = 1:7)
#'@seealso \code{\link{shift}}

#'@export
basic_shift <- function(base, val, trigger = 6) {
  stopifnot(
    is.numeric(base),
    is.numeric(trigger),
    length(base) == 1,
    length(trigger) == 1,
    length(val) > 1
  )

  if (!is.numeric(val))
    return(NULL)

  if (sum(val %notin% c(NA, base)) < trigger)
    return(NULL)

  start  <- shift <- min(which(base != val))
  updown <- sign(val[start] - base)
  shifts <- NULL

  for (index in (start + 1):length(val)) {

    if (val[index] %in% c(NA, base)) {
      NULL
    }
    else if (sign(val[index] - base) == updown) {
      shift <- append(shift, index)
    }
    else {
      if (length(shift) >= trigger)
        shifts <- append(shifts, shift)
      shift <- index
      updown <- -updown
    }
  }

  if (length(shift) >= trigger)
    shifts <- append(shifts, shift)

  return(shifts)
}
