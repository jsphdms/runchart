library(firstpackage)
context("sus()")

test_that("sus() meets basic requirements", {
  expect_equal(sus(1:9),   df(base = c(rep(4.5, 8), NA),
                              base_ext = rep(4.5, 9),
                              base_label = c(4.5, rep(NA, 8))))
  expect_equal(sus(-1:-9), df(base = c(rep(-4.5, 8), NA),
                              base_ext = rep(-4.5, 9),
                              base_label = c(-4.5, rep(NA, 8))))
})

test_that("sus() handles corner cases", {
  # base == val == constant
  expect_equal(sus(rep(0,9)), df(c(rep(0,8),NA), rep(0,9), c(0, rep(NA, 8))))
  expect_equal(sus(rep(1,9)), df(c(rep(1,8),NA), rep(1,9), c(1, rep(NA, 8))))

  # UpDown
  expect_equal(sus(c(1:9,8:1)), df(c(rep(4.5,8),rep(NA,9)), rep(4.5,17), c(4.5, rep(NA, 16))))
  expect_equal(sus(c(1:9,9:1)), df(c(rep(4.5,8),rep(NA,10)), rep(4.5,18), c(4.5, rep(NA, 17))))
  expect_equal(sus(c(0,1:9,8:1)), df(c(rep(3.5,8),rep(NA,10)), rep(3.5,18), c(3.5, rep(NA, 17))))

  # DownUp
  expect_equal(sus(c(-1:-9,-8:-1)), df(c(rep(-4.5,8),rep(NA,9)), rep(-4.5,17), c(-4.5, rep(NA, 16))))
  expect_equal(sus(c(-1:-9,-9:-1)), df(c(rep(-4.5,8),rep(NA,10)), rep(-4.5,18), c(-4.5, rep(NA, 17))))
  expect_equal(sus(c(0,-1:-9,-8:-1)), df(c(rep(-3.5,8),rep(NA,10)), rep(-3.5,18), c(-3.5, rep(NA, 17))))

  # Delayed sustained shift
  expect_equal(sus(c(rep(0,9),rep(1,8),rep(0,9))), df(c(rep(0,8),rep(NA,18)), rep(0,26), c(0, rep(NA, 25))))
  expect_equal(sus(c(rep(0,9),rep(1,8),rep(0,8),1)), df(c(rep(0,8),NA,rep(1,8),rep(NA,9)), c(rep(0,9), rep(1,17)), c(0, rep(NA, 8), 1, rep(NA, 16))))
  expect_equal(sus(c(rep(0,9),rep(1,8),rep(0,9),1)), df(c(rep(0,8),NA,rep(1,8),rep(0,8),c(NA,NA)), c(rep(0,9),rep(1,8),rep(0,10)), c(0, rep(NA, 8), 1, rep(NA, 7), 0, rep(NA, 9))))

  # ZigZag
  expect_equal(sus(rep(c(1,-1),10)), df(c(rep(0,8),rep(NA,12)),rep(0,20), c(0, rep(NA, 19))))
  expect_equal(sus(rep(c(0,1),10)), df(c(rep(0.5,8),rep(NA,12)),rep(0.5,20), c(0.5, rep(NA, 19))))
  expect_equal(sus(c(rep(c(0,1),8),rep(0,4))), df(c(rep(0.5,8),rep(NA,12)),rep(0.5,20), c(0.5, rep(NA, 19))))

  # Box
  expect_equal(sus(rep(c(1,1,-1,-1),5)), df(c(rep(0,8),rep(NA,12)),rep(0,20), c(0, rep(NA, 19))))
  expect_equal(sus(rep(c(1,1,0,0),5)), df(c(rep(0.5,8),rep(NA,12)),rep(0.5,20), c(0.5, rep(NA, 19))))

  # Missing <8 at begining
  expect_equal(sus(c(rep(NA,5), rep(1,15))), df(c(rep(NA,5), rep(1,8),rep(NA,7)),
                                                c(rep(NA,5), rep(1,15)),
                                                c(rep(NA,5), 1, rep(NA, 14))))

  # Missing 8 at begining
  expect_equal(sus(c(rep(NA,8), rep(1,12))), df(c(rep(NA,8), rep(1,8), rep(NA,4)),
                                                c(rep(NA,8), rep(1,12)),
                                                c(rep(NA,8), 1, rep(NA, 11))))

  # Missing >8 at begining
  expect_equal(sus(c(rep(NA,10), rep(1,10))), df(c(rep(NA,10), rep(1,8), rep(NA,2)),
                                                 c(rep(NA,10), rep(1,10)),
                                                 c(rep(NA,10), 1, rep(NA, 9))))
  expect_equal(sus(c(rep(NA,15), rep(1,5))), df(rep(NA_real_,20), rep(NA_real_,20), rep(NA_real_,20)))

  # Missing <8 within first 8
  expect_equal(sus(c(1,rep(NA,3), rep(1,16))), df(c(rep(1,11),rep(NA,9)),rep(1,20), c(1, rep(NA, 19))))

  # Missing from before 8th to after 8th
  expect_equal(sus(c(1:3,rep(NA,7), rep(0,10))), df(c(rep(0,15),rep(NA,5)),rep(0,20), c(0, rep(NA, 19))))

  # Missing after 8
  expect_equal(sus(c(rep(0,10), rep(NA,5), rep(0,5))), df(c(rep(0,8),rep(NA,12)),rep(0,20), c(0, rep(NA, 19))))

  # Missing at end
  expect_equal(sus(c(rep(0,10), rep(NA,10))), df(c(rep(0,8),rep(NA,12)),rep(0,20), c(0, rep(NA, 19))))
  expect_equal(sus(c(rep(1,10), rep(NA,10))), df(c(rep(1,8),rep(NA,12)),rep(1,20), c(1, rep(NA, 19))))
})
