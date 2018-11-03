context("basic_trend()")

# Basic functionality ---------------------------------------------------------

test_that("basic_trend() detects trends", {
  expect_equal(basic_trend(1:4), NULL)
  expect_equal(basic_trend(1:5), data.frame(trend1 = 1:5))
  expect_equal(basic_trend(1:6), data.frame(trend1 = 1:6))

  expect_equal(basic_trend(-1:-4), NULL)
  expect_equal(basic_trend(-1:-5), data.frame(trend1 = -1:-5))
  expect_equal(basic_trend(-1:-6), data.frame(trend1 = -1:-6))
})

# Corner cases ----------------------------------------------------------------

test_that("basic_trend() handles corner cases", {

  expect_equal(basic_trend(rep(c(1, 3), 5)), NULL)

  # updown
  expect_equal(basic_trend(1:17), data.frame(trend1 = 1:17))
  expect_equal(basic_trend(c(1:9, 8:1)),
               data.frame(trend1 = c(1:9, rep(NA, 8)),
                          trend2 = c(rep(NA, 8), 9:1)))
  expect_equal(basic_trend(c(1:4, 3:1)), NULL)

  expect_equal(basic_trend(-1:-17), data.frame(trend1 = -1:-17))
  expect_equal(basic_trend(c(-1:-9, -8:-1)),
               data.frame(trend1 = c(-1:-9, rep(NA, 8)),
                          trend2 = c(rep(NA, 8), -9:-1)))
  expect_equal(basic_trend(c(-1:-4, -3:-1)), NULL)

  # almost/delayed #nolint
  expect_equal(basic_trend(c(1:4, rep(4, 9))), NULL)
  expect_equal(basic_trend(c(1:4, rep(4, 2), 5)),
               data.frame(trend1 = c(1:4, rep(4, 2), 5)))
  expect_equal(basic_trend(c(1:4, rep(NA, 2), 5)),
               data.frame(trend1 = c(1:4, rep(NA, 2), 5)))
  expect_equal(basic_trend(c(1:4, NA, 0, -1:-3, 0, NA)),
               data.frame(trend1 = c(rep(NA, 3), 4, NA, 0:-3, rep(NA, 2))))
  expect_equal(basic_trend(c(1:4, NA, 4, 5)),
               data.frame(trend1 = c(1:4, NA, 4, 5)))

  # missing
  expect_equal(basic_trend(rep(NA, 15)), NULL)
  expect_equal(basic_trend(rep(0, 15)), NULL)
  expect_equal(basic_trend(rep(c(0, NA), 5)), NULL)
  expect_equal(basic_trend(c(rep(NA, 5), 1:7)),
               data.frame(trend1 = c(rep(NA, 5), 1:7)))
  expect_equal(basic_trend(c(rep(0, 5), 1:8)),
               data.frame(trend1 = c(rep(NA, 4), 0:8)))
  expect_equal(basic_trend(c(1:3, rep(NA, 4), 4:5)),
               data.frame(trend1 = c(1:3, rep(NA, 4), 4:5)))
  expect_equal(basic_trend(c(1:3, rep(3, 4), 4:5)),
               data.frame(trend1 = c(1:3, rep(3, 4), 4:5)))
  expect_equal(basic_trend(c(1, NA, 2, NA, 3, NA, 4, NA, 5)),
               data.frame(trend1 = c(1, NA, 2, NA, 3, NA, 4, NA, 5)))
  expect_equal(basic_trend(c(1, NA, 2, NA, 3, NA, 4, NA, 4)), NULL)
  expect_equal(basic_trend(c(1, NA, 2, NA, 3, NA, 4, NA, NA)), NULL)
  expect_equal(basic_trend(c(1, NA, 2, NA, 3, NA, 4, NA, 3)), NULL)
  expect_equal(basic_trend(c(1:6, NA)),
               data.frame(trend1 = c(1:6, NA)))
  expect_equal(basic_trend(c(1:6, 0)),
               data.frame(trend1 = c(1:6, NA)))
  expect_equal(basic_trend(c(1:5, NA, 6:7)),
               data.frame(trend1 = c(1:5, NA, 6:7)))
  expect_equal(basic_trend(c(1:4, 4, 5)),
               data.frame(trend1 = c(1:4, 4, 5)))
  expect_equal(basic_trend(c(1:5, -1, 1:2)),
               data.frame(trend1 = c(1:5, rep(NA, 3))))
})

# Multiple shifts -------------------------------------------------------------

test_that("basic_trend() handles multiple trends", {

  # multiple shifts
  expect_equal(basic_trend(c(1:5, -1:-5)),
               data.frame(trend1 = c(1:5, rep(NA, 5)),
                          trend2 = c(rep(NA, 4), 5, -1:-5)))
  expect_equal(basic_trend(c(1:5, NA, -1:-5)),
               data.frame(trend1 = c(1:5, rep(NA, 6)),
                          trend2 = c(rep(NA, 4), 5, NA, -1:-5)))
  expect_equal(basic_trend(c(1:5, 0, -1:-5)),
               data.frame(trend1 = c(1:5, rep(NA, 6)),
                          trend2 = c(rep(NA, 4), 5, 0:-5)))
  expect_equal(basic_trend(c(1:5, 0, 1:5)),
               data.frame(trend1 = c(1:5, rep(NA, 6)),
                          trend2 = c(rep(NA, 5), 0:5)))
  expect_equal(basic_trend(c(1:5, NA, 1:5)),
               data.frame(trend1 = c(1:5, rep(NA, 6)),
                          trend2 = c(rep(NA, 6), 1:5)))

})

# Bugs -------------------------------------------------------------

test_that("basic_trend() handles realistic data", {

  # multiple shifts
  expect_equal(basic_trend(c(0, 1, 5, 2, 3, 8, 2, 2, 3, 4, 7, 4, 3, 4, 2, 3, 1,
                             2, 3, 2, 8, 9, 7, 8, 7, 9, NA, 7, 7, 8)),
               NULL)
  expect_equal(basic_trend(c(5, 6, 6, 5, 5, 6, 7, 8, 9)),
               data.frame(trend1 = c(rep(NA, 3), 5, 5:9)))
  expect_equal(basic_trend(c(1:5, 5)),
               data.frame(trend1 = c(1:5, 5)))
})
