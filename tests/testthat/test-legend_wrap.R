library(testthat)
library(ggplot2)

test_that("legend_wrap returns a guides object", {
  result <- legend_wrap(ncol = 2)
  expect_s3_class(result, "guides")
})

test_that("legend_wrap can be added to a ggplot", {
  p <- ggplot(mpg, aes(displ, hwy, color = class)) +
    geom_point() +
    legend_wrap(ncol = 2)
  expect_s3_class(p, "gg")
})

test_that("legend_wrap accepts nrow parameter", {
  result <- legend_wrap(nrow = 3)
  expect_s3_class(result, "guides")
})

test_that("legend_wrap accepts byrow parameter", {
  result <- legend_wrap(ncol = 2, byrow = FALSE)
  expect_s3_class(result, "guides")
})

test_that("legend_wrap works with fill aesthetic", {
  p <- ggplot(mpg, aes(class, fill = class)) +
    geom_bar() +
    legend_wrap(ncol = 2)
  expect_s3_class(p, "gg")
})

test_that("legend_wrap combines with legend_left", {
  p <- ggplot(mpg, aes(displ, hwy, color = class)) +
    geom_point() +
    legend_wrap(ncol = 2) +
    legend_left()
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.position, "left")
})
