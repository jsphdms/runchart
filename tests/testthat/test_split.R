context("split()")

# Basic functionality ---------------------------------------------------------

test_that("split() handles basic cases", {
  expect_equal(
    split(c(1, 2, 3), "base"),
    data.frame(base1 = c(1, NA_real_, NA_real_),
               base2 = c(NA_real_, 2, NA_real_),
               base3 = c(NA_real_, NA_real_, 3))
  )

  expect_equal(
    split(c(1, 2), "base"),
    data.frame(base1 = c(1, NA_real_),
               base2 = c(NA_real_, 2))
  )
})

# NAs -------------------------------------------------------------------------

test_that("split() handles NAs", {

  expect_equal(
    split(c(NA, 1), "base"),
    data.frame(base1 = c(NA_real_, 1))
  )

  expect_equal(
    split(c(1, NA), "base"),
    data.frame(base1 = c(1, NA_real_))
  )

})
