library(firstpackage)
context("runchart()")

# Basic functionality ---------------------------------------------------------

test_that("runchart() handles basic cases", {
  expect_equal(
    runchart(rep(0,8)),
    data.frame(base = rep(0,8),
               base_ext = rep(0,8),
               base_label = c(0, rep(NA, 7)),
               shift = rep(NA_real_,8),
               val = rep(0,8))
  )

  expect_equal(
    runchart(c(rep(0,8), rep(1,8))),
    data.frame(base = c(rep(0,8), rep(NA,8)),
               base_ext = rep(0,16),
               base_label = c(0, rep(NA, 15)),
               shift = c(rep(NA,8), rep(1,8)),
               val = c(rep(0,8), rep(1,8)))
    )

  expect_equal(
    runchart(c(rep(0,8), rep(1,9))),
    data.frame(base = c(rep(0,8), rep(1,8), NA),
               base_ext = c(rep(0,8), rep(1,9)),
               base_label = c(0, rep(NA, 7), 1, rep(NA, 8)),
               shift = rep(NA_real_,17),
               val = c(rep(0,8), rep(1,9)))
    )
})

# Corner cases ----------------------------------------------------------------

test_that("runchart() handles corner cases", {

  # shift then sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 6), rep(-1,9))),
    data.frame(base = c(rep(0, 8), rep(NA, 6), rep(-1,8), NA),
               base_ext = c(rep(0, 14), rep(-1, 9)),
               base_label = c(0, rep(NA, 13), -1, rep(NA, 8)),
               shift = c(rep(NA, 8), rep(1, 6), rep(NA, 9)),
               val = c(rep(0,8), rep(1, 6), rep(-1,9)))
  )

  # sus then shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 9), rep(-1,6))),
    data.frame(base = c(rep(0, 8), rep(1, 8), rep(NA,7)),
               base_ext = c(rep(0, 8), rep(1, 15)),
               base_label = c(0, rep(NA, 7), 1, rep(NA, 14)),
               shift = c(rep(NA, 17), rep(-1, 6)),
               val = c(rep(0,8), rep(1, 9), rep(-1,6)))
  )

  # almost shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA)),
    data.frame(base = c(rep(0, 8), rep(NA,9)),
               base_ext = rep(0, 17),
               base_label = c(0, rep(NA, 16)),
               shift = rep(NA_real_, 17),
               val = c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA))
  )

  # delayed shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA, 1)),
    data.frame(base = c(rep(0, 8), rep(NA,10)),
               base_ext = rep(0, 18),
               base_label = c(0, rep(NA, 17)),
               shift = c(rep(NA, 8), rep(1, 4), NA, NA, 1, NA, NA, 1),
               val = c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA, 1))
  )

  # delayed sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA, 1)),
    data.frame(base = c(rep(0, 8), rep(1,10), rep(NA, 3)),
               base_ext = c(rep(0, 8), rep(1, 13)),
               base_label = c(0, rep(NA, 7), 1, rep(NA, 12)),
               shift = rep(NA_real_, 21),
               val = c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA, 1))
  )

  # almost sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA)),
    data.frame(base = c(rep(0, 8), rep(NA, 12)),
               base_ext = rep(0, 20),
               base_label = c(0, rep(NA, 19)),
               shift = c(rep(NA, 8), rep(1, 7), NA, NA, 1, NA, NA),
               val = c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA))
  )

  # consecutive sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 9), rep(-1, 9))),
    data.frame(base = c(rep(0, 8), rep(1, 8), NA, rep(-1, 8), NA),
               base_ext = c(rep(0, 8), rep(1, 9), rep(-1, 9)),
               base_label = c(0, rep(NA, 7), 1, rep(NA, 8), -1, rep(NA, 8)),
               shift = rep(NA_real_, 26),
               val = c(rep(0,8), rep(1, 9), rep(-1, 9)))
  )

  # consecutive shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 7), rep(-1, 6))),
    data.frame(base = c(rep(0, 8), rep(NA, 13)),
               base_ext = rep(0, 21),
               base_label = c(0, rep(NA, 20)),
               shift = c(rep(NA, 8), rep(1, 7), rep(-1, 6)),
               val = c(rep(0,8), rep(1, 7), rep(-1, 6)))
  )

})

# NAs -------------------------------------------------------------------------

test_that("runchart() handles NAs", {

  # all NA
  expect_equal(
    runchart(rep(NA_real_, 10)),
    data.frame(base = rep(NA_real_, 10),
               base_ext = rep(NA_real_, 10),
               base_label = rep(NA_real_, 10),
               shift = rep(NA_real_, 10),
               val = rep(NA_real_, 10))
    )

  # NAs at beginning
  expect_equal(
    runchart(c(rep(NA, 3), rep(1, 8))),
    data.frame(base = c(rep(NA, 3), rep(1, 8)),
               base_ext = c(rep(NA, 3), rep(1, 8)),
               base_label = c(rep(NA, 3), 1, rep(NA, 7)),
               shift = rep(NA_real_, 11),
               val = c(rep(NA, 3), rep(1, 8)))
    )

  # constant
  expect_equal(
    runchart(c(rep(0, 8), rep(NA, 8))),
    data.frame(base = c(rep(0, 8), rep(NA, 8)),
               base_ext = rep(0, 16),
               base_label = c(0, rep(NA, 15)),
               shift = rep(NA_real_, 16),
               val = c(rep(0, 8), rep(NA, 8)))
    )

  # shift followed by NAs
  expect_equal(
    runchart(c(rep(0, 8), rep(1, 6), NA)),
    data.frame(base = c(rep(0, 8), rep(NA, 7)),
               base_ext = rep(0, 15),
               base_label = c(0, rep(NA, 14)),
               shift = c(rep(NA, 8), rep(1, 6), NA),
               val = c(rep(0, 8), rep(1, 6), NA))
  )

})
