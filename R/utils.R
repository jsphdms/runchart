#'First n non-NA elements of x where n defaults to 8.
#'
#'Creating the first baseline of a run chart requires the first 8 non-NA data
#'points. \code{elems8(x, n)} finds the first n non-NA elements of x
#'where n defaults to 8.
#'
#'@param x A numeric vector.
#'@param n How many non-NA elements of x should be returned?
#'@return A numeric vector.
#'@examples
#'runchart:::elems8(1:9)
#'runchart:::elems8(1:9, 5)
#'@seealso \code{\link{index1}}, \code{\link{index8}}
#'@keywords internal
#'@noRd
elems8 <- function(x, n = 8L) {
  if (!is.numeric(c(x, n)))
    stop(paste("Both arguments must be of type numeric.",
               "Is there an 'NA' where there should be an NA?")
    )

  if (n > length(x)) {
    stop(paste("Input vector x needs at least", n, "elements."))
  }

  non_NA_count <- length(which(!is.na(x)))

  if (non_NA_count < n) {
    stop(
      paste("Input vector x only has", non_NA_count,
            "non-NA elements. It needs at least", n))
    }

  x[which(!is.na(x))[1:n]]
}

#'Index of the first non-NA element of x.
#'
#'@inheritParams elems8
#'@return A numeric vector of length one.
#'@examples
#'runchart:::index1(c(NA,1:9))
#'@seealso \code{\link{index8}}
#'@keywords internal
#'@noRd
index1 <- function(x) {
  min(which(!is.na(x)))
}

#'Index of the nth non-NA element of x where n defaults to 8.
#'
#'@param n Which non-NA element to return
#'@inheritParams elems8
#'@return A numeric vector of length one.
#'@examples
#'runchart:::index8(c(NA,1:9))
#'@seealso \code{\link{index1}}
#'@keywords internal
#'@noRd
index8 <- function(x,  n = 8L) {
  max(which(!is.na(x))[1:n])
}

#'Rebase \code{base} starting from \code{start} until \code{start} using the
#'median of \code{new_vals}
#'
#'@param base A numeric vector.
#'@param start Where to rebase \code{base} from (inclusive).
#'@param end Where to rebase \code{base} until (inclusive).
#'@param new_vals Rebase \code{base} using the median of \code{new_vals}
#'@return A numeric vector.
#'@examples
#'runchart:::rebase(1:9, start = 4, new_vals = 1)
#'runchart:::rebase(1:9, start = 4, new_vals = c(1,2,3))
#'@keywords internal
#'@noRd
rebase <- function(base, start = 1, end = length(base), new_vals) {
  stopifnot(
    is.numeric(base),
    is.numeric(start),
    is.numeric(new_vals),
    length(start) == 1,
    length(new_vals) >= 1,
    length(base) >= 1,
    length(base) >= start
    )
  base[start:end] <- stats::median(new_vals)
  base
}

#'Create a \code{data.frame} from the vectors \code{base} and \code{base_ext}.
#'
#'@param base A numeric vector.
#'@param base_ext A numeric vector.
#'@param base_label A character vector.
#'@return A \code{data.frame} with 2 columns: \code{base} and \code{base_ext}.
#'@examples
#'runchart:::df(c(rep(4.5, 8), NA), rep(4.5, 9))
#'@keywords internal
#'@noRd
df <- function(base, base_ext, base_label = rep(NA_character_, length(base))) {
  data.frame(base = base,
             base_ext = base_ext,
             base_label = base_label)
}

#'Convenience infix function.
#'
#'@param x A numeric vector.
#'@param y A numeric vector.
#'@return A logical vector.
#'@examples
#'runchart:::`%notin%`(1:3, 3:5)
#'@keywords internal
#'@noRd
`%notin%` <- function(x, y) {
  !(x %in% y)
}

#'Rephased baselines are joined up when plotted as a single vector. This means
#'that a line will join the end of a base line to the beginning of another.
#'Visually, this isn't very useful. In order to avoid this, we split baselines
#'into dataframes with a column for each rephased value. \code{split} is a
#'utility function which splits a vector into a dataframe for this purpose.
#'
#'@param v a vector for \code{split} to split into a dataframe.
#'@param vname the columns of the returned dataframe are named \code{vname1},
#'  \code{vname2}, \code{vname3}, etc
#'@return A data.frame with a column for each new value of \code{v}.
#'@examples
#'runchart:::split(
#'v = c(1,1,1,1,1,1,5,5,5,5,5,5,5,5,3,3,3,3,3,3,3),
#'vname = "example"
#')
#'@seealso \code{\link{sus}} \code{\link{multi_shift}}
#'@keywords internal
#'@noRd
split <- function(v, vname) {
  stopifnot(
    any(!is.na(v)),
    is.numeric(v),
    length(v) > 0,
    is.character(vname),
    length(vname) == 1
  )

  index <- 1
  new_bases <- v[index1(v)]

  # Build an ordered list of each base line
  for (i in index1(v):length(v)) {
    if (!is.na(v[i]) && v[i] != new_bases[length(new_bases)])
      new_bases <- append(new_bases, v[i])
  }

  ncols <- length(new_bases)

  # Create a data frame with a column for each different value of v
  df <- as.data.frame(tcrossprod(v, rep(1, ncols)))
  colnames(df) <- paste0(vname, 1:ncols)

  # Remove values until we have distinct non-overlapping columns for each base
  for (new_base in new_bases) {
    col <- df[[paste0(vname, index)]]
    top <- min(which(new_base == col))

    if (top == length(v)) break

    for (i in (top + 1):length(v)) {
      if (is.na(col[i]) || col[i] != col[i - 1]) {

        df[[paste0(vname, index)]][- (1:(i - 1))] <- NA_real_
        if (index < length(df)) {
          df[1:(i - 1), (index + 1):length(df)] <- NA_real_
        }

        index <- index + 1
        break
      }
    }
  }
  return(df)
}

