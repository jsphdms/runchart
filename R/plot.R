#'Plot a run chart.
#'
#'@param v a vector for \code{plot()} to plot.
#'@return A plot.
#'@examples
#'plot(c(0,1,5,2,3,8,2,2,3,4,7,4,3,4,2,3,1,2,3,2,8,9,7,8,7,9,NA,7,7,8,6,5))
#'@seealso \code{\link{runchart}} \code{\link{split}}
#'
#'@export
plot <- function(v) {
  stopifnot(
    any(!is.na(v)),
    is.numeric(v),
    length(v) > 0
  )

  rc <- runchart(v)
  base <- split(rc[['base']], 'base')
  base_ext <- split(rc[['base_ext']], 'base_ext')

  p <- ggplot() +
    geom_line(data = rc, aes(1:nrow(rc), val), colour = 'blue') +
    geom_point(data = rc, aes(1:nrow(rc), shift), shape = 21, size = 3, colour = 'red',
               stroke = 2)

  for (i in names(base)) {
    p <- p + geom_line(data = base, aes_string(1:nrow(base), i), size = 1.3)
  }

  for (i in names(base_ext)) {
    p <- p + geom_line(data = base_ext, aes_string(1:nrow(base_ext), i))
  }

  p

}
