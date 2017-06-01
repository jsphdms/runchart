context("runchart()")

# Basic functionality ---------------------------------------------------------

n <- 40
date <- seq.Date(Sys.Date(), by = "day", length.out = n)
df <- data.frame(date  = date,
                 value = rep(0,n))

test_that("runchart() handles basic cases with output = 'df'", {
  expect_equal(
    runchart(df, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df[['value']],
               trend = rep(NA_real_, n),
               shift = rep(NA_real_,n)
  ))

  expect_equal(
    runchart(df, trend = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df[['value']],
               shift = rep(NA_real_,n)
  ))

  expect_equal(
    runchart(df, shift = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df[['value']],
               trend = rep(NA_real_, n)
  ))

  expect_equal(
    runchart(df, shift = FALSE, trend = FALSE, output = 'df'),
    data.frame(date = date,
               base = rep(0, n),
               value = df[['value']]
  ))

})

test_that("runchart() handles basic cases with output = 'df' and rephase = TRUE", {
  df <- data.frame(date  = date,
                   value = rep(0,n))

  expect_equal(
    runchart(df, rephase= TRUE, output = 'df'),
    data.frame(date = date,
               value = df[['value']],
               base = c(rep(0, 8), rep(NA, n - 8)),
               base_ext = rep(0, n),
               base_label = c(0, rep(NA, n - 1)),
               base1 = c(rep(0, 8), rep(NA, n - 8)),
               base_ext1 = rep(0, n),
               shift = rep(NA_real_, n)
    ))
})
