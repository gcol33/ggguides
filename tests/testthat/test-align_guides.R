library(testthat)
library(ggplot2)

test_that("align_guides_h errors without patchwork installed", {
  skip_if(rlang::is_installed("patchwork"))
  expect_error(
    align_guides_h(list()),
    "patchwork"
  )
})

test_that("align_guides_h errors if x is not a patchwork object", {
  skip_if_not_installed("patchwork")
  expect_error(
    align_guides_h(ggplot()),
    "`x` must be a patchwork object."
  )
})

test_that("align_guides_h errors if x is a list", {
  skip_if_not_installed("patchwork")
  expect_error(
    align_guides_h(list(a = 1)),
    "`x` must be a patchwork object."
  )
})

test_that("align_guides_h works with valid patchwork object", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  result <- align_guides_h(combined)
  expect_s3_class(result, "patchwork")
})

test_that("align_guides_h accepts guides = 'keep'", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  result <- align_guides_h(combined, guides = "keep")
  expect_s3_class(result, "patchwork")
})

test_that("align_guides_h rejects invalid guides parameter", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  expect_error(
    align_guides_h(combined, guides = "invalid"),
    "'arg' should be one of"
  )
})
