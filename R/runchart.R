#'Create a run chart fields for dataframe \code{df}.
#'
#'@param df a data.frame which must consist of exactly two columns: a column of
#'type Date called \code{date} and a column of numeric type called \code{value}.
#'@param trend include trends? Defaults to \code{TRUE}.
#'@param shift include shifts? Defaults to \code{TRUE}.
#'@param rephase rephase baselines? Defaults to \code{FALSE}.
#'@param output return a dataframe or a plot? Either one of
#'\code{c("plot"), ("df")} Defaults to \code{"plot"}.
#'
#'@return Either a data.frame with runchart fields, or a plot.
#'@examples
#'df <- data.frame(
#'date  = seq.Date(Sys.Date(), by = "day", length.out = 30),
#'value = c(4,3,3,2,2,3,3,4,4,4,4,3,3,2,2,1,2,1,0,3,3,4,5,6,7,9,8,7,6,6)
#')
#'runchart(df)

#'@export
runchart <- function(df, shift = TRUE, trend = TRUE, rephase = FALSE, output = 'plot') {
  stopifnot(
    is.data.frame(df),
    setequal(names(df), c("date", "value")),
    is.numeric(df[["value"]]),
    inherits(df[["date"]], 'Date') || inherits(df[["date"]], 'POSIXct'),
    is.logical(c(trend, shift, rephase)),
    length(shift) == 1,
    length(trend) == 1,
    length(rephase) == 1,
    output %in% c('df', 'plot'),
    nrow(df) > 0
  )

  df[["date"]] <- as.Date(df[["date"]])
  df <- df[order(df[["date"]]),]

  value <- df[["value"]]
  date  <- df[["date"]]

# Regardless of the requested output, we always need a dataframe --------------

  if (rephase) {
    rc        <- cbind(df, sus(df[['value']]))

    base      <- split(rc[['base']], 'base')
    base_ext  <- split(rc[['base_ext']], 'base_ext')
    rc        <- cbind(rc, base, base_ext)

    shift_vec <- multi_shift(rc[['value']], rc[['base']], rc[['base_ext']])
  }
  else if (rephase == FALSE) {
    base  <- stats::median(value, na.rm = T)

    shift_vec     <- trend_vec <- base_label <- value*NA_real_
    shift_index   <- basic_shift(base = base, val = value)
    trend_index   <- basic_trend(val = value)

    base_label[1] <- base
    shift_vec[shift_index] <- value[shift_index]
    trend_vec[trend_index] <- value[trend_index]
    base  <- rep(base, length(value))

    rc <- data.frame(date  = date,
                     base  = base,
                     value = value)

    if (trend) rc[['trend']] <- trend_vec
  }

  if (shift) rc[['shift']] <- shift_vec

  if (output == 'df') {
    return(rc)
  }
  else if (output == 'plot') {
    p <- ggplot2::ggplot(rc) +
      ggplot2::geom_line(ggplot2::aes(date, value), colour = 'skyblue', size = 1.1) +
      ggplot2::geom_text(ggplot2::aes(date, base_label,
                             label = signif(base_label, digits = 2)), vjust = 1,
                         hjust = 0, nudge_y = -.15) +
      ggplot2::theme_classic() +
      ggplot2::theme(axis.title.x=ggplot2::element_blank(),
                     axis.title.y=ggplot2::element_blank(),
                     axis.ticks.x=ggplot2::element_blank(),
                     axis.ticks.y=ggplot2::element_blank(),
                     plot.title = ggplot2::element_text(hjust = 0.5))

    if (rephase) {
      for (i in names(base)) {
        p <- p + ggplot2::geom_line(ggplot2::aes_string("date", i), size = 1.3)
        }

      for (i in names(base_ext)) {
        p <- p + ggplot2::geom_line(ggplot2::aes_string("date", i))
        }
    }
    else if (rephase == FALSE) {
      p <- p + ggplot2::geom_line(ggplot2::aes(date, base))
      if (trend) p <- p + ggplot2::geom_line(colour = 'blue', ggplot2::aes(date, trend),
                                    size = 1.1)
    }

    if (shift) p <- p + ggplot2::geom_point(ggplot2::aes(date, shift), shape = 16,
                                            size = 2, colour = 'black',
                                            stroke = 2)
    return(p)
  }
}
