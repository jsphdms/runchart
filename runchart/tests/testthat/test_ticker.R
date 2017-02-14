library(firstpackage)
context("ticker()")

# Basic functionality ---------------------------------------------------------

test_that("ticker() detects sus shift", {
  # sus <- ticker(base = 2, val = 1:15, start = 1, updown = -1)
  sus <- ticker(base = 2, val = 1:15)

  for (i in 1:10) {
    expect_equal(sus(), NULL)
  }

  expect_equal(sus(), 3:11)
  expect_equal(sus(), 3:11)
})

test_that("ticker() detects no sus shift", {
  # no_sus <- ticker(base = 2, val = rep(c(1, 3), 5), start = 1, updown = -1)
  no_sus <- ticker(base = 2, val = rep(c(1, 3), 5))

  for (i in 1:9) {
    expect_equal(no_sus(), NULL)
  }

  expect_equal(no_sus(), "No sus shift found")
  expect_equal(no_sus(), "No sus shift found")
})


# Corner cases ----------------------------------------------------------------

test_that("ticker() handles corner cases", {
  # decreasing <- ticker(base = 0, val = -1:-17, start = 1, updown = -1)
  # updown  <- ticker(base = 0, val = c(1:9,8:1), start = 1, updown = 1)
  # updown0 <- ticker(base = 0, val = c(0,1:8,8:1), start = 2, updown = 1)
  # downup  <- ticker(base = 0, val = c(-1:-9,-8:-1), start = 1, updown = -1)
  # downup0 <- ticker(base = 0, val = c(0,-1:-8,-8:-1), start = 2, updown = -1)
  # zigzag  <- ticker(base = 0, val = c(rep(c(1,-1),8),1), start = 1, updown = 1)
  # almost  <- ticker(base = 0, val = c(rep(1,8),rep(0,9)), start = 1, updown = 1)
  # delayed0 <- ticker(base = 0, val = c(rep(1,8),rep(0,8),1), start = 1, updown = 1)
  # delayed1 <- ticker(base = 0, val = c(rep(1,8),rep(NA,8),1), start = 1, updown = 1)
  #
  # missing0 <- ticker(base = 0, val = c(rep(NA,8),rep(1,9)), start = 9, updown = 1)
  # missing1 <- ticker(base = 0, val = c(rep(0,8),rep(1,9)), start = 9, updown = 1)
  # missing2 <- ticker(base = 0, val = c(rep(1,4),rep(NA,4),rep(1,9)), start = 1, updown = 1)
  # missing3 <- ticker(base = 0, val = c(rep(1,4),rep(0,4),rep(1,9)), start = 1, updown = 1)
  # missing4 <- ticker(base = 0, val = c(rep(c(1,NA),8),1), start = 1, updown = 1)
  # missing5 <- ticker(base = 0, val = c(rep(c(1,NA),8),0), start = 1, updown = 1)
  # missing6 <- ticker(base = 0, val = c(rep(c(1,NA),8),NA), start = 1, updown = 1)
  # missing7 <- ticker(base = 0, val = c(rep(c(1,NA),8),-1), start = 1, updown = 1)

  decreasing <- ticker(base = 0, val = -1:-17)
  updown  <- ticker(base = 0, val = c(1:9,8:1))
  updown0 <- ticker(base = 0, val = c(0,1:8,8:1))
  downup  <- ticker(base = 0, val = c(-1:-9,-8:-1))
  downup0 <- ticker(base = 0, val = c(0,-1:-8,-8:-1))
  zigzag  <- ticker(base = 0, val = c(rep(c(1,-1),8),1))
  almost  <- ticker(base = 0, val = c(rep(1,8),rep(0,9)))
  delayed0 <- ticker(base = 0, val = c(rep(1,8),rep(0,8),1))
  delayed1 <- ticker(base = 0, val = c(rep(1,8),rep(NA,8),1))

  missing0 <- ticker(base = 0, val = c(rep(NA,8),rep(1,9)))
  missing1 <- ticker(base = 0, val = c(rep(0,8),rep(1,9)))
  missing2 <- ticker(base = 0, val = c(rep(1,4),rep(NA,4),rep(1,9)))
  missing3 <- ticker(base = 0, val = c(rep(1,4),rep(0,4),rep(1,9)))
  missing4 <- ticker(base = 0, val = c(rep(c(1,NA),8),1))
  missing5 <- ticker(base = 0, val = c(rep(c(1,NA),8),0))
  missing6 <- ticker(base = 0, val = c(rep(c(1,NA),8),NA))
  missing7 <- ticker(base = 0, val = c(rep(c(1,NA),8),-1))

  for (i in 1:8) {
    expect_equal(decreasing(), NULL)
    expect_equal(updown(), NULL)
    expect_equal(updown0(), NULL)
    expect_equal(downup(), NULL)
    expect_equal(downup0(), NULL)

    expect_equal(missing0(), NULL)
    expect_equal(missing1(), NULL)
  }

  for (i in 1:12) {
    expect_equal(missing2(), NULL)
    expect_equal(missing3(), NULL)
  }

  for (i in 1:16) {
    expect_equal(zigzag(), NULL)
    expect_equal(almost(), NULL)
    expect_equal(delayed0(), NULL)
    expect_equal(delayed1(), NULL)

    expect_equal(missing4(), NULL)
    expect_equal(missing5(), NULL)
    expect_equal(missing6(), NULL)
    expect_equal(missing7(), NULL)
  }

  expect_equal(decreasing(), 1:9)
  expect_equal(updown(), 1:9)
  expect_equal(updown0(), 2:10)
  expect_equal(downup(), 1:9)
  expect_equal(downup0(), 2:10)

  expect_equal(zigzag(), "No sus shift found")
  expect_equal(almost(), "No sus shift found")
  expect_equal(delayed0(), c(1:8,17))
  expect_equal(delayed1(), c(1:8,17))

  expect_equal(missing0(), 9:17)
  expect_equal(missing1(), 9:17)
  expect_equal(missing2(), c(1:4,9:13))
  expect_equal(missing3(), c(1:4,9:13))
  expect_equal(missing4(), seq(1,17,by=2))
  expect_equal(missing5(), "No sus shift found")
  expect_equal(missing6(), "No sus shift found")
  expect_equal(missing7(), "No sus shift found")
})


# Invalid arguments handling --------------------------------------------------

test_that("ticker() handles invalid arguments", {
  # base
  expect_error(ticker(base = 1:15, val = 1:15, start = 1, updown = -1))
  expect_error(ticker(base = NULL, val = 1:15, start = 1, updown = -1))
  expect_error(ticker(base = NA, val = 1:15, start = 1, updown = -1))

  # val
  expect_error(ticker(base = 2, val = NULL, start = 1, updown = -1))
  expect_error(ticker(base = 2, val = NA, start = 1, updown = -1))
  expect_error(ticker(base = 2, val = "1", start = 1, updown = -1))

  # start
  expect_error(ticker(base = 2, val = 1:15, start = 1:2, updown = -1))
  expect_error(ticker(base = 2, val = 1:15, start = "1", updown = -1))
  expect_error(ticker(base = 2, val = 1:15, start = NULL, updown = -1))
  expect_error(ticker(base = 2, val = 1:15, start = NA, updown = -1))

  # updown
  expect_error(ticker(base = 2, val = 1:15, start = 2, updown = 0))
  expect_error(ticker(base = 2, val = 1:15, start = 2, updown = "1"))
  expect_error(ticker(base = 2, val = 1:15, start = 2, updown = NA))
  expect_error(ticker(base = 2, val = 1:15, start = 2, updown = NULL))

})
