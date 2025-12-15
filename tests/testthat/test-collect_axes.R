library(testthat)
library(ggplot2)

test_that("collect_axes errors without patchwork installed", {
  skip_if(rlang::is_installed("patchwork"))
  expect_error(
    collect_axes(list()),
    "patchwork"
  )
})

test_that("collect_axes errors if x is not a patchwork object", {
  skip_if_not_installed("patchwork")
  expect_error(
    collect_axes(ggplot()),
    "`x` must be a patchwork object."
  )
})

test_that("collect_axes errors if x is a list", {
  skip_if_not_installed("patchwork")
  expect_error(
    collect_axes(list(a = 1)),
    "`x` must be a patchwork object."
  )
})

test_that("collect_axes works with valid patchwork object", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  result <- collect_axes(combined)
  expect_s3_class(result, "patchwork")
})

test_that("collect_axes accepts guides = 'keep'", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  result <- collect_axes(combined, guides = "keep")
  expect_s3_class(result, "patchwork")
})

test_that("collect_axes rejects invalid guides parameter", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  expect_error(
    collect_axes(combined, guides = "invalid"),
    "'arg' should be one of"
  )
})

test_that("align_guides_h is deprecated alias for collect_axes", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  expect_warning(
    result <- align_guides_h(combined),
    "deprecated"
  )
  expect_s3_class(result, "patchwork")
})
