library(testthat)
library(ggplot2)

# =============================================================================
# legend_order() basic tests
# =============================================================================

test_that("legend_order returns a ggguides_legend_order object", {
  result <- legend_order(c("8", "6", "4"))
  expect_s3_class(result, "ggguides_legend_order")
  expect_s3_class(result, "gg")
})

test_that("legend_order stores order specification correctly", {
  result <- legend_order(c("8", "6", "4"))
  expect_equal(result$order, c("8", "6", "4"))
  expect_equal(result$aesthetic, "colour")
})

test_that("legend_order can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point(size = 3) +
    legend_order(c("8", "6", "4"))
  expect_s3_class(p, "gg")
})

# =============================================================================
# Order specification types
# =============================================================================

test_that("legend_order accepts character vector order", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_order(c("8", "6", "4"))
  expect_s3_class(p, "gg")
})

test_that("legend_order accepts function order (rev)", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_order(rev)
  expect_s3_class(p, "gg")
})

test_that("legend_order accepts function order (sort)", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_order(sort)
  expect_s3_class(p, "gg")
})

# =============================================================================
# Aesthetic parameter
# =============================================================================

test_that("legend_order default aesthetic is colour", {
  result <- legend_order(c("a", "b"))
  expect_equal(result$aesthetic, "colour")
})

test_that("legend_order normalizes 'color' to 'colour'", {
  result <- legend_order(c("a", "b"), aesthetic = "color")
  expect_equal(result$aesthetic, "colour")
})

test_that("legend_order accepts fill aesthetic", {
  p <- ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
    geom_bar() +
    legend_order(c("8", "4", "6"), aesthetic = "fill")
  expect_s3_class(p, "gg")
})

test_that("legend_order accepts shape aesthetic", {
  p <- ggplot(mtcars, aes(mpg, wt, shape = factor(cyl))) +
    geom_point(size = 3) +
    legend_order(c("8", "6", "4"), aesthetic = "shape")
  expect_s3_class(p, "gg")
})

test_that("legend_order accepts linetype aesthetic", {
  p <- ggplot(mtcars, aes(mpg, wt, linetype = factor(cyl))) +
    geom_line() +
    legend_order(c("8", "6", "4"), aesthetic = "linetype")
  expect_s3_class(p, "gg")
})

# =============================================================================
# Error handling
# =============================================================================

test_that("legend_order errors on invalid order type", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point()

  expect_error(
    p + legend_order(123),
    "'order' must be a character vector or a function"
  )
})

test_that("legend_order warns on missing levels", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point()

  expect_warning(
    p + legend_order(c("8", "6", "4", "nonexistent")),
    "not in the data"
  )
})

test_that("legend_order warns when aesthetic not found", {
  p <- ggplot(mtcars, aes(mpg, wt)) +
    geom_point()

  expect_warning(
    p + legend_order(c("a", "b")),
    "No 'colour' aesthetic found"
  )
})

# =============================================================================
# Partial order specification
# =============================================================================

test_that("legend_order adds unspecified levels at the end", {
  # When only some levels are specified, unspecified should appear at end
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_order(c("8"))
  expect_s3_class(p, "gg")
})

# =============================================================================
# Layer mappings
# =============================================================================

test_that("legend_order finds aesthetic in layer mappings", {
  # When aesthetic is in layer, not in ggplot()
  p <- ggplot(mtcars, aes(mpg, wt)) +
    geom_point(aes(color = factor(cyl))) +
    legend_order(c("8", "6", "4"))
  expect_s3_class(p, "gg")
})

test_that("legend_order handles unsupported aesthetic", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point()

  # Unsupported aesthetics should error when added to a plot
  # The error occurs in the switch statement when trying to create the scale
  result <- legend_order(c("8", "6", "4"), aesthetic = "unsupported")
  expect_s3_class(result, "ggguides_legend_order")
})
