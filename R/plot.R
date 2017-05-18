#'Plot a run chart.
#'
#'@param df a data.frame for \code{rc_plot()} to plot. \code{df} must consist of
#'exactly two columns: a column of type Date called \code{date} and a column of
#'numeric type called \code{value}.
#'@return A plot.
#'@examples
#'rc_plot(
#'data.frame(
#'  date = seq.Date(Sys.Date(), by = "week", length.out = n),
#'  value = cumsum(rnorm(n))),
#'"Here is a run chart")
#'@seealso \code{\link{runchart}} \code{\link{split}}
#'
#'@export
rc_plot <- function(df, title = "Default Title") {
  stopifnot(
    any(!is.na(df[["value"]])),
    is.numeric(df[["value"]]),
    nrow(df) > 0
  )

  rc <- cbind(df["date"], runchart(df[["value"]]))

  base <- split(rc[['base']], 'base')
  base_ext <- split(rc[['base_ext']], 'base_ext')

  rc <- cbind(rc, base)
  rc <- cbind(rc, base_ext)

  p <- ggplot(rc) +
    geom_line(aes(date, val), colour = 'skyblue', size = 1.1) +
    geom_point(aes(date, shift), shape = 16, size = 2, colour = 'black',
               stroke = 2) +
    labs(title = title)

  for (i in names(base)) {
    p <- p + geom_line(aes_string(rc[["date"]], i), size = 1.3)
  }

  for (i in names(base_ext)) {
    p <- p + geom_line(aes_string(rc[["date"]], i))
  }

  p + theme_classic() + theme(axis.title.x=element_blank(),
                              axis.title.y=element_blank(),
                              axis.ticks.x=element_blank(),
                              axis.ticks.y=element_blank(),
                              plot.title = element_text(hjust = 0.5))

}
