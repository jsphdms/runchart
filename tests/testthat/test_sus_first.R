library(firstpackage)
context("sus_first()")

test_that("sus_first() meets basic requirements", {
  expect_equal(sus_first(0, 1:9), 1:9)
  expect_equal(sus_first(0,-1:-9), 1:9)
})

test_that("sus_first() handles corner cases", {
  # base == val == constant
  expect_equal(sus_first(base = 0, val = rep(0,9)), NULL)
  expect_equal(sus_first(base = 1, val = rep(1,9)), NULL)

  # UpDown
  expect_equal(sus_first(base = 0, val = c(1:9,8:1)), 1:9)
  expect_equal(sus_first(base = 0, val = c(1:9,9:1)), 1:9)
  expect_equal(sus_first(base = 0, val = c(0,1:9,8:1)), 2:10)

  # DownUp
  expect_equal(sus_first(base = 0, val = c(-1:-9,-8:-1)), 1:9)
  expect_equal(sus_first(base = 0, val = c(-1:-9,-9:-1)), 1:9)
  expect_equal(sus_first(base = 0, val = c(0,-1:-9,-8:-1)), 2:10)

  # Delayed sus_firsttained shift
  expect_equal(sus_first(base = 0, val = c(rep(0,9),rep(1,8),rep(0,9))), NULL)
  expect_equal(sus_first(base = 0, val = c(rep(0,9),rep(1,8),rep(0,8),1)), c(10:17, 26))

  # ZigZag
  expect_equal(sus_first(base = 0, val = rep(c(1,-1),10)), NULL)
  expect_equal(sus_first(base = 0, val = rep(c(0,1),10)), seq(2,18,by=2))
  expect_equal(sus_first(base = 0, val = c(rep(c(0,1),8),rep(0,4))), NULL)

  # Box
  expect_equal(sus_first(base = 0, val = rep(c(1,1,-1,-1),5)), NULL)
  expect_equal(sus_first(base = 0, val = rep(c(1,1,0,0),5)), c(1,2,5,6,9,10,13,14,17))

  # Missing <8 at begining
  expect_equal(sus_first(base = 0, val = c(rep(NA,5), rep(1,15))), 6:14)

  # Missing 8 at begining
  expect_equal(sus_first(base = 0, val = c(rep(NA,8), rep(1,12))), 9:17)

  # Missing >8 at begining
  expect_equal(sus_first(base = 0, val = c(rep(NA,10), rep(1,10))), 11:19)

  expect_equal(sus_first(base = 0, val = c(rep(NA,15), rep(1,5))), NULL)

  # Missing <8 within first 8
  expect_equal(sus_first(base = 0, val = c(1,rep(NA,3), rep(1,16))), c(1,5:12))

  # Missing from before 8th to after 8th
  expect_equal(sus_first(base = 0, val = c(1:3,rep(NA,7), rep(0,10))), NULL)

  # Missing after 8
  expect_equal(sus_first(base = 0, val = c(rep(0,10), rep(NA,5), rep(0,5))), NULL)

  # Missing at end
  expect_equal(sus_first(base = 0, val = c(rep(0,10), rep(NA,10))), NULL)
  expect_equal(sus_first(base = 0, val = c(rep(1,10), rep(NA,10))), 1:9)
})
