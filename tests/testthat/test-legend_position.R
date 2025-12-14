library(testthat)
library(ggplot2)

test_that("legend_left returns a theme object", {
  result <- legend_left()
  expect_s3_class(result, "theme")
})

test_that("legend_left sets correct theme elements", {
  result <- legend_left()
  expect_equal(result$legend.position, "left")
  expect_equal(result$legend.justification, "left")
  expect_equal(result$legend.box.just, "left")
})

test_that("legend_left can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_left()
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.position, "left")
})

test_that("legend_left works with multiple legends", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), shape = factor(am))) +
    geom_point() +
    legend_left()
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.box.just, "left")
})
