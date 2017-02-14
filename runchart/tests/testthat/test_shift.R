library(firstpackage)
context("shift()")

# Basic functionality ---------------------------------------------------------

test_that("shift() handles basic cases", {
  expect_equal(
    shift(
      val = c(rep(0,8), rep(1,8)),
      base = c(rep(0,8), rep(NA,8)),
      base_ext = rep(0, 16)
      ),
    c(rep(NA,8), rep(1,8))
    )

  expect_equal(
    shift(
      val = c(rep(0,8), rep(-1,8)),
      base = c(rep(0,8), rep(NA,8)),
      base_ext = rep(0, 16)
      ),
    c(rep(NA,8), rep(-1,8))
    )
})

# Corner cases ----------------------------------------------------------------

test_that("shift() handles basic cases", {

  # constant
  expect_equal(
    shift(
      val = rep(0,16),
      base = c(rep(0,8), rep(NA,8)),
      base_ext = rep(0, 16)
    ),
    rep(NA_real_, 16))

  # all NA
  expect_equal(
    shift(
      val = rep(NA,16),
      base = rep(NA,16),
      base_ext = rep(NA, 16)
    ),
    rep(NA_real_, 16))
})
