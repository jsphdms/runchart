library(firstpackage)
context("basic_trend()")

# Basic functionality ---------------------------------------------------------

test_that("basic_trend() detects shift", {
  expect_equal(basic_trend(1:4),NULL)
  expect_equal(basic_trend(1:5),1:5)
  expect_equal(basic_trend(1:6),1:6)

  expect_equal(basic_trend(-1:-4),NULL)
  expect_equal(basic_trend(-1:-5),1:5)
  expect_equal(basic_trend(-1:-6),1:6)
})

# Corner cases ----------------------------------------------------------------

test_that("basic_trend() handles corner cases", {

  expect_equal(basic_trend(rep(c(1, 3), 5)), NULL)

  # updown
  expect_equal(basic_trend(1:17), 1:17)
  expect_equal(basic_trend(c(1:9,8:1)), 1:17)
  expect_equal(basic_trend(c(1:4,3:1)), NULL)

  expect_equal(basic_trend(-1:-17), 1:17)
  expect_equal(basic_trend(c(-1:-9,-8:-1)), 1:17)
  expect_equal(basic_trend(c(-1:-4,-3:-1)), NULL)

  # almost/delayed
  expect_equal(basic_trend(c(1:4,rep(4,9))), NULL)
  expect_equal(basic_trend(c(1:4,rep(4,2),5)), 1:7)
  expect_equal(basic_trend(c(1:4,rep(NA,2),5)), c(1:4, 7))
  expect_equal(basic_trend(c(1:4, NA, 0,-1:-3,0,NA)), c(4, 6:9))
  expect_equal(basic_trend(c(1:4, NA, 4,5)), c(1:4,6,7))

  # missing
  expect_equal(basic_trend(rep(NA,15)), NULL)
  expect_equal(basic_trend(rep(0,15)), NULL)
  expect_equal(basic_trend(rep(c(0,NA),5)), NULL)
  expect_equal(basic_trend(c(rep(NA,5),1:7)), 6:12)
  expect_equal(basic_trend(c(rep(0,5),1:8)), 5:13)
  expect_equal(basic_trend(c(1:3,rep(NA,4),4:5)), c(1:3, 8:9))
  expect_equal(basic_trend(c(1:3,rep(3,4),4:5)), 1:9)
  expect_equal(basic_trend(c(1,NA,2,NA,3,NA,4,NA,5)), seq(1,9,by=2))
  expect_equal(basic_trend(c(1,NA,2,NA,3,NA,4,NA,4)), NULL)
  expect_equal(basic_trend(c(1,NA,2,NA,3,NA,4,NA,NA)), NULL)
  expect_equal(basic_trend(c(1,NA,2,NA,3,NA,4,NA,3)), NULL)
  expect_equal(basic_trend(c(1:6,NA)), 1:6)
  expect_equal(basic_trend(c(1:6,0)), 1:6)
  expect_equal(basic_trend(c(1:5,NA,6:7)), c(1:5,7:8))
  expect_equal(basic_trend(c(1:4,4,5)), 1:6)
  expect_equal(basic_trend(c(1:5,-1,1:2)), 1:5)
})

# Multiple shifts -------------------------------------------------------------

test_that("basic_trend() handles multiple shifts", {

  # multiple shifts
  expect_equal(basic_trend(c(1:5,-1:-5)), 1:10)
  expect_equal(basic_trend(c(1:5, NA, -1:-5)), c(1:5, 7:11))
  expect_equal(basic_trend(c(1:5, 0, -1:-5)), c(1:11))
  expect_equal(basic_trend(c(1:5, 0, 1:5)), c(1:11))
  expect_equal(basic_trend(c(1:5, NA, 1:5)), c(1:5, 7:11))

})
