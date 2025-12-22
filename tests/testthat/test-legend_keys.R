library(testthat)
library(ggplot2)

# =============================================================================
# legend_keys() tests
# =============================================================================

test_that("legend_keys returns a Guides object", {
  result <- legend_keys(size = 4)
  expect_s3_class(result, "Guides")
})

test_that("legend_keys with no args returns NULL with warning", {
  expect_warning(result <- legend_keys(), "No key modifications specified")
  expect_null(result)
})

test_that("legend_keys can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point(size = 1) +
    legend_keys(size = 4)
  expect_s3_class(p, "gg")
})

# =============================================================================
# Size parameter
# =============================================================================

test_that("legend_keys accepts size parameter", {
  result <- legend_keys(size = 5)
  expect_s3_class(result, "Guides")
})

# =============================================================================
# Alpha parameter
# =============================================================================

test_that("legend_keys accepts alpha parameter", {
  result <- legend_keys(alpha = 1)
  expect_s3_class(result, "Guides")

  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point(alpha = 0.3) +
    legend_keys(alpha = 1)
  expect_s3_class(p, "gg")
})

# =============================================================================
# Shape parameter - numeric codes
# =============================================================================

test_that("legend_keys accepts numeric shape codes", {
  # Outline shapes (0-14)
  result <- legend_keys(shape = 1)
  expect_s3_class(result, "Guides")

  # Solid shapes (15-20)
  result <- legend_keys(shape = 16)
  expect_s3_class(result, "Guides")

  # Filled shapes with outline (21-25)
  result <- legend_keys(shape = 21)
  expect_s3_class(result, "Guides")
})

# =============================================================================
# Shape parameter - character names
# =============================================================================

test_that("legend_keys accepts shape names", {
  shape_names <- c(
    "circle", "square", "diamond", "triangle", "triangle_down",
    "circle_open", "square_open", "diamond_open", "triangle_open",
    "circle_filled", "square_filled", "diamond_filled", "triangle_filled",
    "plus", "cross", "asterisk"
  )

  for (shape_name in shape_names) {
    result <- legend_keys(shape = shape_name)
    expect_s3_class(result, "Guides")
  }
})

test_that("legend_keys converts shape names to codes correctly", {
  # Test shape_name_to_code internal function
  expect_equal(ggguides:::shape_name_to_code("circle"), 16)
  expect_equal(ggguides:::shape_name_to_code("square"), 15)
  expect_equal(ggguides:::shape_name_to_code("diamond"), 18)
  expect_equal(ggguides:::shape_name_to_code("triangle"), 17)
  expect_equal(ggguides:::shape_name_to_code("circle_open"), 1)
  expect_equal(ggguides:::shape_name_to_code("square_open"), 0)
  expect_equal(ggguides:::shape_name_to_code("circle_filled"), 21)
  expect_equal(ggguides:::shape_name_to_code("plus"), 3)
  expect_equal(ggguides:::shape_name_to_code("cross"), 4)
  expect_equal(ggguides:::shape_name_to_code("asterisk"), 8)
})

test_that("shape_name_to_code returns unknown names as-is", {
  # Single character shapes like "a" should pass through
  expect_equal(ggguides:::shape_name_to_code("a"), "a")
  expect_equal(ggguides:::shape_name_to_code("X"), "X")
})

# =============================================================================
# Line parameters
# =============================================================================

test_that("legend_keys accepts linewidth parameter", {
  result <- legend_keys(linewidth = 2)
  expect_s3_class(result, "Guides")
})

test_that("legend_keys accepts linetype parameter", {
  result <- legend_keys(linetype = "dashed")
  expect_s3_class(result, "Guides")

  result <- legend_keys(linetype = 2)
  expect_s3_class(result, "Guides")
})

# =============================================================================
# Color parameters
# =============================================================================

test_that("legend_keys accepts fill parameter", {
  result <- legend_keys(fill = "white")
  expect_s3_class(result, "Guides")
})

test_that("legend_keys accepts colour parameter", {
  result <- legend_keys(colour = "black")
  expect_s3_class(result, "Guides")
})

test_that("legend_keys accepts color parameter (US spelling)", {
  result <- legend_keys(color = "black")
  expect_s3_class(result, "Guides")
})

test_that("legend_keys accepts stroke parameter", {
  result <- legend_keys(stroke = 1.5)
  expect_s3_class(result, "Guides")
})

# =============================================================================
# Filled shapes with both fill and colour
# =============================================================================

test_that("legend_keys works with filled shapes and fill parameter", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point(size = 3) +
    legend_keys(shape = "circle_filled", fill = "white", stroke = 1.5)
  expect_s3_class(p, "gg")
})

test_that("legend_keys shows message for filled shapes with colour but no fill", {
  expect_message(
    legend_keys(shape = 21, colour = "black"),
    "Using filled shapes"
  )

  expect_message(
    legend_keys(shape = "circle_filled", colour = "black"),
    "Using filled shapes"
  )
})

test_that("legend_keys does not show message when fill is specified", {
  expect_silent(legend_keys(shape = 21, colour = "black", fill = "white"))
})

# =============================================================================
# Aesthetic parameter
# =============================================================================

test_that("legend_keys default aesthetic is colour and fill", {
  result <- legend_keys(size = 4)
  expect_s3_class(result, "Guides")
})

test_that("legend_keys accepts single aesthetic", {
  result <- legend_keys(size = 4, aesthetic = "colour")
  expect_s3_class(result, "Guides")

  result <- legend_keys(size = 4, aesthetic = "fill")
  expect_s3_class(result, "Guides")
})

test_that("legend_keys accepts 'all' aesthetic", {
  result <- legend_keys(size = 4, aesthetic = "all")
  expect_s3_class(result, "Guides")
})

test_that("legend_keys normalizes 'color' to 'colour' in aesthetic", {
  result <- legend_keys(size = 4, aesthetic = "color")
  expect_s3_class(result, "Guides")
})

test_that("legend_keys works with fill aesthetic on boxplot", {
  p <- ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(cyl))) +
    geom_boxplot(alpha = 0.5) +
    legend_keys(alpha = 1, aesthetic = "fill")
  expect_s3_class(p, "gg")
})

# =============================================================================
# Multiple parameters combined
# =============================================================================

test_that("legend_keys accepts multiple parameters", {
  result <- legend_keys(
    size = 5,
    alpha = 1,
    shape = "square",
    colour = "black"
  )
  expect_s3_class(result, "Guides")
})
