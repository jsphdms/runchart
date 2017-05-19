#'Iterate through a vector and find the indices of all trends.
#'
#'Call this function once to iterate through all elements of a vector and return
#'the indices of all trends relative to a single (constant) baseline. For a
#'changing baseline this function is used multiple times by \code{multi_trend()}.
#'
#'@param val A numeric vector. The vector \code{basic_trend} iterates over.
#'@param trigger The default number of observations for a trend is 5.
#'@return If trends are found, the indices of these trends. If not, \code{NULL}.
#'@examples
#'basic_trend(val = 1:8)
#'basic_trend(val = 1:7)
#'@seealso \code{\link{multi_trend()}}

#'@export
basic_trend <- function(val, trigger = 5) {
  stopifnot(
    is.numeric(trigger),
    length(trigger) == 1,
    length(val) > 1
  )

  if (!is.numeric(val))
    return(NULL)

  if (length(unique(val[!is.na(val)])) < trigger)
    return(NULL)

  start <- min(which(!is.na(val)))
  trend2 <- min(which(val != val[start]))
  trend1 <- max(which(val[1:trend2] != val[trend2]))

  trend  <- c(trend1, trend2)
  updown <- sign(val[trend[2]] - val[trend[1]])
  trends <- NULL

  for (index in (trend[2] + 1):length(val)) {

    if (is.na(val[index])) {
      NULL
    }
    else if (val[index] == val[trend[length(trend)]]) {
      trends <- append(trends, index)
    }
    else if (sign(val[index] - val[trend[length(trend)]]) == updown) {
      trend <- append(trend, index)
    }
    else {
      if (length(trend) >= trigger)
        trends <- append(trends, trend)
      trend <- append(trend[length(trend)], index)
      updown <- -updown
    }
  }

  if (length(trend) >= trigger)
    trends <- append(trends, trend)

  return(sort(unique(trends)))
}
