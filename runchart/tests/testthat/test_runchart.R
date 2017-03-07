library(firstpackage)
context("runchart()")

# Basic functionality ---------------------------------------------------------

test_that("shift() handles basic cases", {
  expect_equal(
    runchart(rep(0,8)),
    data.frame(base = rep(0,8),
               base_ext = rep(0,8),
               shift = rep(NA_real_,8),
               val = rep(0,8))
  )

  expect_equal(
    runchart(c(rep(0,8), rep(1,8))),
    data.frame(base = c(rep(0,8), rep(NA,8)),
               base_ext = rep(0,16),
               shift = c(rep(NA,8), rep(1,8)),
               val = c(rep(0,8), rep(1,8)))
    )

  expect_equal(
    runchart(c(rep(0,8), rep(1,9))),
    data.frame(base = c(rep(0,8), rep(1,8), NA),
               base_ext = c(rep(0,8), rep(1,9)),
               shift = rep(NA_real_,17),
               val = c(rep(0,8), rep(1,9)))
    )
})

# nothing
# shift
# sus shift

# combinations:
# shift then sus
# sus then shift
# almost shift
# delayed shift
# delayed sus
# almost sus
# consecutive sus's
# consecutive shifts


# Corner cases ----------------------------------------------------------------

test_that("shift() handles corner cases", {

  # shift then sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 6), rep(-1,9))),
    data.frame(base = c(rep(0, 8), rep(NA, 6), rep(-1,8), NA),
               base_ext = c(rep(0, 14), rep(-1, 9)),
               shift = c(rep(NA, 8), rep(1, 6), rep(NA, 9)),
               val = c(rep(0,8), rep(1, 6), rep(-1,9)))
  )

  # sus then shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 9), rep(-1,6))),
    data.frame(base = c(rep(0, 8), rep(1, 8), rep(NA,7)),
               base_ext = c(rep(0, 8), rep(1, 15)),
               shift = c(rep(NA, 17), rep(-1, 6)),
               val = c(rep(0,8), rep(1, 9), rep(-1,6)))
  )

  # almost shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA)),
    data.frame(base = c(rep(0, 8), rep(NA,9)),
               base_ext = rep(0, 17),
               shift = rep(NA_real_, 17),
               val = c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA))
  )

  # delayed shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA, 1)),
    data.frame(base = c(rep(0, 8), rep(NA,10)),
               base_ext = rep(0, 18),
               shift = c(rep(NA, 8), rep(1, 4), NA, NA, 1, NA, NA, 1),
               val = c(rep(0,8), rep(1, 4), 0, NA, 1, 0, NA, 1))
  )

  # delayed sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA, 1)),
    data.frame(base = c(rep(0, 8), rep(1,10), rep(NA, 3)),
               base_ext = c(rep(0, 8), rep(1, 13)),
               shift = rep(NA_real_, 21),
               val = c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA, 1))
  )

  # almost sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA)),
    data.frame(base = c(rep(0, 8), rep(NA, 12)),
               base_ext = rep(0, 20),
               shift = c(rep(NA, 8), rep(1, 7), NA, NA, 1, NA, NA),
               val = c(rep(0,8), rep(1, 7), 0, NA, 1, 0, NA))
  )

  # consecutive sus
  expect_equal(
    runchart(c(rep(0,8), rep(1, 9), rep(-1, 9))),
    data.frame(base = c(rep(0, 8), rep(1, 8), NA, rep(-1, 8), NA),
               base_ext = c(rep(0, 8), rep(1, 9), rep(-1, 9)),
               shift = rep(NA_real_, 26),
               val = c(rep(0,8), rep(1, 9), rep(-1, 9)))
  )

  # consecutive shift
  expect_equal(
    runchart(c(rep(0,8), rep(1, 7), rep(-1, 6))),
    data.frame(base = c(rep(0, 8), rep(NA, 13)),
               base_ext = rep(0, 21),
               shift = c(rep(NA, 8), rep(1, 7), rep(-1, 6)),
               val = c(rep(0,8), rep(1, 7), rep(-1, 6)))
  )


# 2 consecutive shifts same side
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,6), -1, rep(1,6)),
#       base = c(rep(0,8), rep(NA,13)),
#       base_ext = rep(0, 21)
#     ),
#     c(rep(NA,8), rep(1,6), NA, rep(1,6)))
#
#   # 2 consecutive shifts different side
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,6), rep(-1,6)),
#       base = c(rep(0,8), rep(NA,12)),
#       base_ext = rep(0, 20)
#     ),
#     c(rep(NA,8), rep(1,6), rep(-1,6)))
#
#   # 2 shifts either side of sustained shift same side
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,6), rep(2,8), rep(3,6)),
#       base = c(rep(0,8), rep(NA,6), rep(2,8), rep(NA,6)),
#       base_ext = c(rep(0, 14), rep(2, 14))
#     ),
#     c(rep(NA,8), rep(1,6), rep(NA,8), rep(3,6)))
#
#   # 2 shifts either side of sustained shift different side
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,6), rep(2,8), rep(1,6)),
#       base = c(rep(0,8), rep(NA,6), rep(2,8), rep(NA,6)),
#       base_ext = c(rep(0, 14), rep(2, 14))
#     ),
#     c(rep(NA,8), rep(1,6), rep(NA,8), rep(1,6)))
#
#   # no shift
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,5)),
#       base = c(rep(0,8), rep(NA,5)),
#       base_ext = rep(0, 13)
#     ),
#     rep(NA_real_,13)
#   )
#
#   # almost shift
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,5), NA),
#       base = c(rep(0,8), rep(NA,6)),
#       base_ext = rep(0, 14)
#     ),
#     rep(NA_real_,14)
#   )
#
#   # almost shift
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,5), 0),
#       base = c(rep(0,8), rep(NA,6)),
#       base_ext = rep(0, 14)
#     ),
#     rep(NA_real_,14)
#   )
#
#   # delayed shift
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,5), 0, 1),
#       base = c(rep(0,8), rep(NA,7)),
#       base_ext = rep(0, 15)
#     ),
#     c(rep(NA,8), rep(1,5), NA, 1)
#   )
#
#   # almost shift followed by shift different side
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,5), rep(-1,6)),
#       base = c(rep(0,8), rep(NA,11)),
#       base_ext = rep(0, 14)
#     ),
#     c(rep(NA,13), rep(-1,6))
#   )
#
#   # shift at end
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,6)),
#       base = c(rep(0,8), rep(NA,6)),
#       base_ext = rep(0, 14)
#     ),
#     c(rep(NA,8), rep(1,6))
#   )
#
})

# NAs -------------------------------------------------------------------------

# test_that("shift() handles NAs", {
#
#   # all NA
#   expect_equal(
#     shift(
#       val = rep(NA,16),
#       base = rep(NA,16),
#       base_ext = rep(NA, 16)
#     ),
#     rep(NA_real_, 16))
#
#   # NAs at beginning
#   expect_equal(
#     shift(
#       val = c(rep(NA, 2), rep(0,8), rep(1,8)),
#       base = c(rep(NA, 2), rep(0,8), rep(NA,8)),
#       base_ext = c(rep(NA, 2), rep(0, 16))
#     ),
#     c(rep(NA_real_, 10), rep(1, 8)))
#
#   # constant
#   expect_equal(
#     shift(
#       val = rep(0,16),
#       base = c(rep(0,8), rep(NA,8)),
#       base_ext = rep(0, 16)
#     ),
#     rep(NA_real_, 16))
#
#   # shift followed by NAs
#   expect_equal(
#     shift(
#       val = c(rep(0,8), rep(1,6), NA),
#       base = c(rep(0,8), rep(NA,7)),
#       base_ext = rep(0, 15)
#     ),
#     c(rep(NA,8), rep(1,6), NA)
#   )
#
# })
