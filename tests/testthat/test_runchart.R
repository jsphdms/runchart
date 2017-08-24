context("runchart()")

# Basic functionality ---------------------------------------------------------

n <- 40
date <- seq.Date(Sys.Date(), by = "day", length.out = n)
datetime <- seq(Sys.time(), by = "day", length.out = n)

df_Date <- data.frame(date  = date,
                 value = rep(0,n))

df_POSIXct <- data.frame(date  = datetime,
                 value = rep(0,n))

test_that("runchart() handles basic cases with output = 'df'", {
  expect_equal(
    runchart(df_Date, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_Date[['value']],
               trend = rep(NA_real_, n),
               shift = rep(NA_real_,n)
  ))

  expect_equal(
    runchart(df_Date, trend = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_Date[['value']],
               shift = rep(NA_real_,n)
  ))

  expect_equal(
    runchart(df_Date, shift = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_Date[['value']],
               trend = rep(NA_real_, n)
  ))

  expect_equal(
    runchart(df_Date, shift = FALSE, trend = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_Date[['value']]
  ))

})

test_that("runchart() handles basic cases with output = 'df' and rephase = TRUE", {
  df <- data.frame(date  = date,
                   value = rep(0,n))

  expect_equal(
    runchart(df_Date, rephase= TRUE, output = 'df'),
    data.frame(date = date,
               value = df_Date[['value']],
               base = c(rep(0, 8), rep(NA, n - 8)),
               base_ext = rep(0, n),
               base_label = c(0, rep(NA, n - 1)),
               base1 = c(rep(0, 8), rep(NA, n - 8)),
               base_ext1 = rep(0, n),
               shift = rep(NA_real_, n)
    ))
})

test_that("runchart() handles data of both types POSIXct and Date", {
  expect_equal(
    runchart(df_POSIXct, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_POSIXct[['value']],
               trend = rep(NA_real_, n),
               shift = rep(NA_real_,n)
    ))

  expect_equal(
    runchart(df_POSIXct, trend = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_POSIXct[['value']],
               shift = rep(NA_real_,n)
    ))

  expect_equal(
    runchart(df_POSIXct, shift = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_POSIXct[['value']],
               trend = rep(NA_real_, n)
    ))

  expect_equal(
    runchart(df_POSIXct, shift = FALSE, trend = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df_POSIXct[['value']]
    ))

})
