#'Rephased baselines are joined up when plotted as a single vector. This means
#'that a line will join the end of a base line to the beginning of another.
#'Visually, this isn't very useful. In order to avoid this, we split baselines
#'into dataframes with a column for each rephased value. \code{split} is a
#'utility function which splits a vector into a dataframe for this purpose.
#'
#'@param v a vector for \code{split} to split into a dataframe.
#'@return A data.frame with a column for each new value of \code{v}.
#'@examples
#'split(c(1,1,1,1,1,1,5,5,5,5,5,5,5,5,3,3,3,3,3,3,3))
#'@seealso \code{\link{sus}} \code{\link{shift}}

split <- function(v, vname) {
  stopifnot(
    any(!is.na(v)),
    is.numeric(v),
    length(v) > 0
  )

  index <- 1
  new_bases <- v[index1(v)]

  # Build an ordered list of each base line
  for (i in index1(v):length(v)) {
    if(!is.na(v[i]) && v[i] != new_bases[length(new_bases)])
      new_bases <- append(new_bases, v[i])
  }

  ncols <- length(new_bases)

  # Create a data frame with a column for each different value of v
  df <- as.data.frame(tcrossprod(v, rep(1,ncols)))
  colnames(df) <- paste0(vname, 1:ncols)

  # Remove values until we have distinct non-overlapping columns for each base
  for (new_base in new_bases) {
    col <- df[[paste0(vname, index)]]
    top <- min(which(new_base == col))

    if (top == length(v)) break

    for (i in (top + 1):length(v)) {
      if (is.na(col[i]) || col[i] != col[i - 1]) {

        df[[paste0(vname, index)]][-(1:(i-1))] <- NA_real_
        if (index < length(df)) df[1:(i-1), (index + 1):length(df)] <- NA_real_

        index <- index + 1
        break
      }
    }
  }
  return(df)
}
