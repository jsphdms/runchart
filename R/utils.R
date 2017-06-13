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
#'elems8(1:9)
#'elems8(1:9, 5)
#'@seealso \code{\link{index1}}, \code{\link{index8}}
elems8 <- function(x, n = 8L) {
  if (!is.numeric(c(x, n)))
    stop("Both arguments must be of type numeric. Is there an 'NA' where there should be an NA?"
    )

  if (n > length(x)) {
    stop(paste("Input vector x needs at least", n, "elements."))
  }

  non_NA_count <- length(which(!is.na(x)))

  if (non_NA_count < n) {
    stop(
      paste("Input vector x only has", non_NA_count, "non-NA elements. It needs at least", n))
    }

  x[which(!is.na(x))[1:n]]
}

#'Index of the first non-NA element of x.
#'
#'@inheritParams elems8
#'@return A numeric vector of length one.
#'@examples
#'index1(c(NA,1:9))
#'@seealso \code{\link{elems8}}, \code{\link{index8}}
index1 <- function(x) {
  min(which(!is.na(x)))
}

#'Index of the nth non-NA element of x where n defaults to 8.
#'
#'@param n Which non-NA element to return
#'@inheritParams elems8
#'@return A numeric vector of length one.
#'@examples
#'index8(c(NA,1:9))
#'@seealso \code{\link{elems8}}, \code{\link{index1}}
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
#'rebase(1:9, start = 4, new_vals = 1)
#'rebase(1:9, start = 4, new_vals = c(1,2,3))
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
  base[start:end] <- median(new_vals)
  base
}

#'Create a \code{data.frame} from the vectors \code{base} and \code{base_ext}.
#'
#'@param base A numeric vector.
#'@param base_ext A numeric vector.
#'@param base_label A character vector.
#'@return A \code{data.frame} with 2 columns: \code{base} and \code{base_ext}.
#'@examples
#'df(c(rep(4.5, 8), NA), rep(4.5, 9))
df <- function(base, base_ext, base_label) {
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
#'1:3 %notin% 3:5
`%notin%` <- function(x,y) {
  !(x %in% y)
}
