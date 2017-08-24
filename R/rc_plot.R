#'Plot a run chart.
#'
#'@param df a data.frame for \code{rc_plot()} to plot. \code{df} must consist of
#'exactly two columns: a column of type Date called \code{date} and a column of
#'numeric type called \code{value}.
#'@return A plot.
#'@examples
#'n <- 30
#'runchart:::rc_plot(
#'data.frame(
#'  date = seq.Date(Sys.Date(), by = "week", length.out = n),
#'  value = cumsum(rnorm(n))))
#'@seealso \code{\link{rc_fields}} \code{\link{split}}
#'@keywords internal

rc_plot <- function(df) {
  stopifnot(
    any(!is.na(df[["value"]])),
    is.numeric(df[["value"]]),
    nrow(df) > 0
  )

  base_label <- val <- shift <- NULL

  rc <- cbind(df[, names(df) != "value", drop = FALSE],
              rc_fields(df[["value"]]))

  base <- split(rc[["base"]], "base")
  base_ext <- split(rc[["base_ext"]], "base_ext")

  rc <- cbind(rc, base)
  rc <- cbind(rc, base_ext)

  p <- ggplot2::ggplot(rc,
                       ggplot2::aes(label = signif(base_label, digits = 2))) +
    ggplot2::geom_line(ggplot2::aes(date, val),
                       colour = "skyblue", size = 1.1) +
    ggplot2::geom_point(ggplot2::aes(date, shift), shape = 16, size = 2,
                        colour = "black", stroke = 2)

  for (i in names(base)) {
    p <- p + ggplot2::geom_line(ggplot2::aes_string(rc[["date"]], i),
                                size = 1.3)
  }

  for (i in names(base_ext)) {
    p <- p + ggplot2::geom_line(ggplot2::aes_string(rc[["date"]], i))
  }

  p + ggplot2::theme_classic() +
    ggplot2::theme(axis.title.x = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank(),
                   axis.ticks.x = ggplot2::element_blank(),
                   axis.ticks.y = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(hjust = 0.5)) +
    ggplot2::geom_text(ggplot2::aes(date, base_label),
                       vjust = 1, hjust = 0, nudge_y = -.15)
}
