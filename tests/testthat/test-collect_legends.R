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

test_that("collect_legends with span = TRUE returns gtable", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  result <- collect_legends(combined, span = TRUE)
  expect_s3_class(result, "gtable")
})

test_that("collect_legends with numeric span returns gtable", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2 / p3

  # Span single row
  result <- collect_legends(combined, span = 1)
  expect_s3_class(result, "gtable")

  # Span multiple rows
  result <- collect_legends(combined, span = 1:2)
  expect_s3_class(result, "gtable")
})

test_that("collect_legends errors on invalid span indices", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  expect_error(
    collect_legends(combined, span = 5),
    "span indices must be between"
  )
})
