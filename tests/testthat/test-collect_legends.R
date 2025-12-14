library(testthat)
library(ggplot2)

test_that("collect_legends errors without patchwork installed", {
  skip_if(rlang::is_installed("patchwork"))
  expect_error(
    collect_legends(list()),
    "patchwork"
  )
})

test_that("collect_legends errors if x is not a patchwork object", {
  skip_if_not_installed("patchwork")
  expect_error(
    collect_legends(ggplot()),
    "`x` must be a patchwork object."
  )
})

test_that("collect_legends errors if x is a list", {
  skip_if_not_installed("patchwork")
  expect_error(
    collect_legends(list(a = 1)),
    "`x` must be a patchwork object."
  )
})

test_that("collect_legends works with valid patchwork object", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 | p2

  result <- collect_legends(combined)
  expect_s3_class(result, "patchwork")
})

test_that("collect_legends accepts position parameter", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 | p2

  result_bottom <- collect_legends(combined, position = "bottom")
  expect_s3_class(result_bottom, "patchwork")

  result_left <- collect_legends(combined, position = "left")
  expect_s3_class(result_left, "patchwork")
})

test_that("collect_legends rejects invalid position", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 | p2

  expect_error(
    collect_legends(combined, position = "invalid"),
    "'arg' should be one of"
  )
})
