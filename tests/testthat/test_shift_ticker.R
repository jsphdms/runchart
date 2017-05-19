library(firstpackage)
context("basic_shift()")

# Basic functionality ---------------------------------------------------------

test_that("basic_shift() detects shift", {
  expect_equal(basic_shift(base = 0, val = 1:5),NULL)
  expect_equal(basic_shift(base = 0, val = 1:6),1:6)
  expect_equal(basic_shift(base = 0, val = 1:7),1:7)
  expect_equal(basic_shift(base = 0, val = 1:8),1:8)
  expect_equal(basic_shift(base = 0, val = 1:9),1:9)
})

# Corner cases ----------------------------------------------------------------

test_that("basic_shift() handles corner cases", {
  expect_equal(basic_shift(base = 2, val = rep(c(1, 3), 5)), NULL)

  # decreasing
  expect_equal(basic_shift(base = 0, val = -1:-7), 1:7)

  # updown
  expect_equal(basic_shift(base = 0, val = -1:-17), 1:17)
  expect_equal(basic_shift(base = 0, val = c(1:9,8:1)), 1:17)
  expect_equal(basic_shift(base = 0, val = c(1:4,3:1)), 1:7)
  expect_equal(basic_shift(base = 0, val = c(0,1:3,3:1)), 2:7)
  expect_equal(basic_shift(base = 0, val = c(-1:-4,-3:-1)), 1:7)
  expect_equal(basic_shift(base = 0, val = c(0,-1:-3,-3:-1)), 2:7)
  expect_equal(basic_shift(base = 0, val = c(rep(c(1,-1),3),1)), NULL)

  # almost/delayed
  expect_equal(basic_shift(base = 0, val = c(rep(1,5),rep(0,9))), NULL)
  expect_equal(basic_shift(base = 0, val = c(rep(1,5),rep(0,2),1)), c(1:5, 8))
  expect_equal(basic_shift(base = 0, val = c(rep(1,5),rep(NA,2),1)), c(1:5, 8))
  expect_equal(basic_shift(base = 0, val = c(1:5, NA, 0,-1:-5,0,NA)), NULL)
  expect_equal(basic_shift(base = 0, val = c(1:5, NA, 0,1)), c(1:5,8))

  # missing
  expect_equal(basic_shift(base = 0, val = rep(NA,15)), NULL)
  expect_equal(basic_shift(base = 0, val = rep(0,15)), NULL)
  expect_equal(basic_shift(base = 0, val = rep(c(0,NA),5)), NULL)
  expect_equal(basic_shift(base = 0, val = c(rep(NA,5),rep(1,7))), 6:12)
  expect_equal(basic_shift(base = 0, val = c(rep(0,5),rep(1,8))), 6:13)
  expect_equal(basic_shift(base = 0, val = c(rep(1,4),rep(NA,4),rep(1,2))), c(1:4, 9:10))
  expect_equal(basic_shift(base = 0, val = c(rep(1,4),rep(0,4),rep(1,2))), c(1:4, 9:10))
  expect_equal(basic_shift(base = 0, val = c(rep(c(1,NA),5),1)), seq(1,11,by=2))
  expect_equal(basic_shift(base = 0, val = c(rep(c(1,NA),5),0)), NULL)
  expect_equal(basic_shift(base = 0, val = c(rep(c(1,NA),5),NA)), NULL)
  expect_equal(basic_shift(base = 0, val = c(rep(c(1,NA),5),-1)), NULL)
  expect_equal(basic_shift(base = 0, val = c(1:6,NA)), 1:6)
  expect_equal(basic_shift(base = 0, val = c(1:6,0)), 1:6)
  expect_equal(basic_shift(base = 0, val = c(1:6,NA,1:2)), c(1:6, 8:9))
  expect_equal(basic_shift(base = 0, val = c(1:6,0,1:2)), c(1:6, 8:9))
  expect_equal(basic_shift(base = 0, val = c(1:6,-1,1:2)), 1:6)
})

# Multiple shifts -------------------------------------------------------------

test_that("basic_shift() handles multiple shifts", {

  # multiple shifts
  expect_equal(basic_shift(base = 0, val = c(1:6,-1:-6)), 1:12)
  expect_equal(basic_shift(base = 0, val = c(1:6, NA, -1:-6)), c(1:6, 8:13))
  expect_equal(basic_shift(base = 0, val = c(1:6, 0, -1:-6)), c(1:6, 8:13))
  expect_equal(basic_shift(base = 0, val = c(1:6, 0, 1:6)), c(1:6, 8:13))
  expect_equal(basic_shift(base = 0, val = c(1:6, NA, 1:6)), c(1:6, 8:13))

})
