library(testthat)
library(ggplot2)

# =============================================================================
# legend_reverse() tests
# =============================================================================

test_that("legend_reverse returns a Guides object", {
  result <- legend_reverse()
  expect_s3_class(result, "Guides")
})

test_that("legend_reverse can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_reverse()
  expect_s3_class(p, "gg")
})

test_that("legend_reverse works with fill aesthetic", {
  p <- ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
    geom_bar() +
    legend_reverse()
  expect_s3_class(p, "gg")
})

# =============================================================================
# legend_style() tests
# =============================================================================

test_that("legend_style returns a theme object", {
  result <- legend_style(size = 12)
  expect_s3_class(result, "theme")
})

test_that("legend_style with no args returns empty theme", {
  result <- legend_style()
  expect_s3_class(result, "theme")
})

test_that("legend_style sets text size", {
  result <- legend_style(size = 14)
  expect_s3_class(result$legend.text, "element_text")
})

test_that("legend_style sets font family", {
  result <- legend_style(family = "serif")
  expect_s3_class(result$legend.text, "element_text")
})

test_that("legend_style sets title properties", {
  result <- legend_style(title_size = 16, title_face = "bold")
  expect_s3_class(result$legend.title, "element_text")
})

test_that("legend_style sets key dimensions", {
  result <- legend_style(key_width = 2, key_height = 1)
  expect_s3_class(result$legend.key.width, "unit")
  expect_s3_class(result$legend.key.height, "unit")
})

test_that("legend_style sets background", {
  result <- legend_style(background = "grey90", background_color = "black")
  expect_s3_class(result$legend.background, "element_rect")
})

test_that("legend_style sets direction", {
  result <- legend_style(direction = "horizontal")
  expect_equal(result$legend.direction, "horizontal")
})

test_that("legend_style sets margin as single value", {
  result <- legend_style(margin = 0.5)
  # ggplot2 3.5.0+ uses "ggplot2::margin" class
  expect_true(inherits(result$legend.margin, "unit"))
})

test_that("legend_style sets margin as 4-vector", {
  result <- legend_style(margin = c(0.1, 0.2, 0.3, 0.4))
  expect_true(inherits(result$legend.margin, "unit"))
})

test_that("legend_style can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_style(size = 12, family = "serif", title_face = "bold")
  expect_s3_class(p, "gg")
})

test_that("legend_style combines with position functions", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_left() +
    legend_style(size = 14)
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.position, "left")
})

# =============================================================================
# as_unit() helper tests
# =============================================================================

test_that("as_unit converts numeric to unit", {
  result <- ggguides:::as_unit(2, "cm")
  expect_s3_class(result, "unit")
})

test_that("as_unit passes through unit objects", {
  input <- unit(3, "mm")
  result <- ggguides:::as_unit(input, "cm")
  expect_identical(result, input)
})

# =============================================================================
# as_margin() helper tests
# =============================================================================

test_that("as_margin converts single value", {
  result <- ggguides:::as_margin(0.5)
  # ggplot2 3.5.0+ uses "ggplot2::margin" class
  expect_true(inherits(result, "unit"))
})

test_that("as_margin converts 4-vector", {
  result <- ggguides:::as_margin(c(1, 2, 3, 4))
  expect_true(inherits(result, "unit"))
})

test_that("as_margin errors on invalid length", {
  expect_error(ggguides:::as_margin(c(1, 2)), "single value or a vector of 4")
})
