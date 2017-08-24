library(firstpackage)
context("base_gaps()")

# Basic functionality ---------------------------------------------------------

test_that("base_gaps() handles basic cases", {
  expect_equal(base_gaps(rep(0, 5)), NULL)
  expect_equal(base_gaps(c(rep(0, 5), rep(NA, 5))), list(6:10))
  expect_equal(base_gaps(c(rep(0, 5), rep(NA, 5), rep(0, 5))), list(6:10))
  expect_equal(base_gaps(c(rep(0, 5), rep(NA, 5), rep(0, 5), rep(NA, 5))),
               list(6:10, 16:20))
  expect_equal(base_gaps(c(rep(0, 5), rep(NA, 5), rep(0, 5), rep(NA, 5),
                           rep(0, 5))),
               list(6:10, 16:20))
  expect_equal(base_gaps(c(rep(NA, 5), rep(0, 5))), NULL)
  expect_equal(base_gaps(c(rep(NA, 5), rep(0, 5), rep(NA, 5))), list(11:15))
  expect_equal(base_gaps(c(rep(NA, 5), rep(0, 5), rep(NA, 5), rep(0, 5))),
               list(11:15))
  expect_equal(base_gaps(c(rep(NA, 5), rep(0, 5), rep(NA, 5), rep(0, 5),
                           rep(NA, 5))),
               list(11:15, 21:25))
})
