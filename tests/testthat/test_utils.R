context("utils")

test_that("index1() works as expected", {
  expect_equal(index1(1:9), 1)
  expect_equal(index1(c(NA, NA, 1)), 3)
})

test_that("index8() works as expected", {
  expect_equal(index8(1:9), 8)
  expect_equal(index8(c(NA, 1:9)), 9)
  expect_equal(index8(c(NA, 1:9), 4), 5)
  expect_equal(index8(c(NA, 1)), NA_integer_)
})

test_that("elems8() works as expected", {
  expect_equal(elems8(1:9), 1:8)
  expect_error(elems8(1:2))
  expect_error(elems8(c(NA, NA, 1:2), 3))
  expect_error(elems8(rep("NA", 9)))
  expect_error(elems8(1:9, "6"))
})

test_that("rebase() works as expected", {
  expect_equal(rebase(1:9, start = 5, new_vals = 1),
               c(1, 2, 3, 4, 1, 1, 1, 1, 1))
})
