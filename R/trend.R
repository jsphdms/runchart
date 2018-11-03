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
#'runchart:::basic_trend(val = 1:8)
#'runchart:::basic_trend(val = 1:7)
#'@seealso \code{\link{basic_shift}}
#'@keywords internal
#'@noRd

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

  start  <- min(which(!is.na(val)))
  trend2 <- min(which(val != val[start]))
  trend1 <- max(which(val[1:trend2] != val[trend2]))

  trend  <- c(trend1, trend2)
  updown <- sign(val[trend[2]] - val[trend[1]])
  non_useful_obs <- trends <- NULL

  trend_index <- 0

  for (index in (trend[2] + 1):length(val)) {

    if (is.na(val[index])) {
      NULL
    }
    else if (val[index] == val[max(trend)]) {
      non_useful_obs <- append(non_useful_obs, index)
    }
    else if (sign(val[index] - val[max(trend)]) == updown) {
      trend <- append(trend, index)
    }
    else {
      if (length(trend) >= trigger) {
        trend_index <- trend_index + 1

        trends[[paste0("trend", trend_index)]] <- val * NA_real_
        trends[[paste0("trend", trend_index)]][trend] <- val[trend]
        trends[[paste0("trend", trend_index)]][non_useful_obs] <-
          val[non_useful_obs]

      }
      trend <- append(max(trend), index)
      non_useful_obs <- non_useful_obs[non_useful_obs > min(trend)]
      updown <- -updown
    }
  }

  non_useful_obs <- non_useful_obs[non_useful_obs > min(trend)]

  if (length(trend) >= trigger) {
    trend_index <- trend_index + 1

    trends[[paste0("trend", trend_index)]] <- val * NA_real_
    trends[[paste0("trend", trend_index)]][trend] <- val[trend]
    trends[[paste0("trend", trend_index)]][non_useful_obs] <-
      val[non_useful_obs]

  }

  trends <- as.data.frame(trends)

  if (length(trends) == 0) return(NULL) else return(trends)
}
