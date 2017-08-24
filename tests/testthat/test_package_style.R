if (requireNamespace("lintr", quietly = TRUE)) {
  context("lints")
  test_that("Package Style", {
    # skip() #nolint
    lintr::expect_lint_free()
  })
}
