#'Create run chart fields for vector \code{val}.
#'
#'
#'@param val create run chart fields for \code{val}.
#'@param sus_trigger Number of data points required to create a sustained shift.
#'@param shift_trigger Number of data points required to create a shift.
#'@return A data.frame with four columns: 1. The original data. 2. A base line.
#'  3. An extended base line. 4: Shifts.
#'@examples
#'runchart(rep(1:20))
#'@seealso \code{\link{sus}} \code{\link{shift}}

#'@export
runchart <- function(val, sus_trigger = 9, shift_trigger = 6) {
  stopifnot(
    is.numeric(val),
    is.numeric(sus_trigger),
    is.numeric(shift_trigger),
    length(sus_trigger) == 1,
    length(shift_trigger) == 1,
    length(val) > 0
  )

  rc <- sus(val, trigger = sus_trigger)
  shift <- shift(val, rc[['base']], rc[['base_ext']], trigger = shift_trigger)

  rc[['shift']] <- shift
  rc[['val']] <- val

  return(rc)
}
