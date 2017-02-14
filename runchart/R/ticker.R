#'Iterate through a vector and find the first sustained shift.
#'
#'Use this function to iterate through a vector by calling it multiple times
#'until it returns either: the indices of the first sustained shift; or the
#'string \code{No sus shift found}.
#'
#'@param base A numeric vector of length one. The current baseline value.
#'@param val A numeric vector. The vector \code{ticker} iterates over.
#'@param start The index of the first useful element of \code{val}. Begin
#'  iterating here.
#'@param updown Takes value \code{1} or \code{-1}. Is the first useful element
#'  of \code{val} above (\code{1}) or below (\code{-1}) \code{base}?
#'@return \code{NULL}, until either a sustained shift is found (then it returns
#'  the indices of the first sustained shift) or no sustained shift is found
#'  (then it returns the string \code{No sus shift found}). The indices of the
#'  first sustained shift (if one is found). Otherwise, \code{NULL}.
#'@examples
#'tick <- ticker(base = 2, val = 1:15, start = 1, updown = -1)
#'tick()
#'tick()
#'tick()
#'etc
#'@seealso \code{\link{sus}}

ticker <- function(base, val, trigger = 9) {
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
