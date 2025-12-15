library(testthat)
library(ggplot2)

# =============================================================================
# legend_hide() tests
# =============================================================================

test_that("legend_hide returns a Guides object", {
  result <- legend_hide(colour)
  expect_s3_class(result, "Guides")
})

test_that("legend_hide errors with no arguments", {
  expect_error(legend_hide(), "At least one aesthetic")
})

test_that("legend_hide hides single legend", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_hide(size)
  expect_s3_class(p, "gg")
})

test_that("legend_hide hides multiple legends", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_hide(size, colour)
  expect_s3_class(p, "gg")
})

test_that("legend_hide normalizes color to colour", {
  # Should work without error
  result <- legend_hide(color)
  expect_s3_class(result, "Guides")
})

# =============================================================================
# legend_select() tests
# =============================================================================

test_that("legend_select returns a Guides object", {
  result <- legend_select(colour)
  expect_s3_class(result, "Guides")
})

test_that("legend_select errors with no arguments", {
  expect_error(legend_select(), "At least one aesthetic")
})

test_that("legend_select keeps single legend", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_select(colour)
  expect_s3_class(p, "gg")
})

test_that("legend_select keeps multiple legends", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp,
                          shape = factor(am))) +
    geom_point() +
    legend_select(colour, shape)
  expect_s3_class(p, "gg")
})

test_that("legend_select returns NULL when all aesthetics kept", {
  result <- legend_select(colour, fill, size, shape, linetype, alpha)
  expect_null(result)
})

# =============================================================================
# legend_order_guides() tests
# =============================================================================

test_that("legend_order_guides returns a Guides object", {
  result <- legend_order_guides(colour = 1, size = 2)
  expect_s3_class(result, "Guides")
})

test_that("legend_order_guides errors with no arguments", {
  expect_error(legend_order_guides(), "At least one aesthetic-order pair")
})

test_that("legend_order_guides errors with unnamed arguments", {
  expect_error(legend_order_guides(1, 2), "must be named")
})

test_that("legend_order_guides sets legend order", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_order_guides(size = 1, colour = 2)
  expect_s3_class(p, "gg")
})

# =============================================================================
# legend_merge() tests
# =============================================================================

test_that("legend_merge returns a Guides object", {
  result <- legend_merge(colour, fill)
  expect_s3_class(result, "Guides")
})

test_that("legend_merge errors with single aesthetic", {
  expect_error(legend_merge(colour), "At least two aesthetics")
})

test_that("legend_merge can be added to a plot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
    geom_point(shape = 21, size = 3) +
    labs(color = "Cylinders", fill = "Cylinders") +
    legend_merge(colour, fill)
  expect_s3_class(p, "gg")
})

# =============================================================================
# legend_split() tests
# =============================================================================

test_that("legend_split returns a Guides object", {
  result <- legend_split(colour, fill)
  expect_s3_class(result, "Guides")
})

test_that("legend_split errors with single aesthetic", {
  expect_error(legend_split(colour), "At least two aesthetics")
})

test_that("legend_split can be added to a plot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
    geom_point(shape = 21, size = 3) +
    labs(color = "Cylinders", fill = "Cylinders") +
    legend_split(colour, fill)
  expect_s3_class(p, "gg")
})

# =============================================================================
# normalize_aesthetic() helper tests
# =============================================================================

test_that("normalize_aesthetic converts color to colour", {
  expect_equal(ggguides:::normalize_aesthetic("color"), "colour")
  expect_equal(ggguides:::normalize_aesthetic("COLOR"), "colour")
})

test_that("normalize_aesthetic passes through other aesthetics", {
  expect_equal(ggguides:::normalize_aesthetic("fill"), "fill")
  expect_equal(ggguides:::normalize_aesthetic("size"), "size")
})

# =============================================================================
# Position functions with by parameter
# =============================================================================

test_that("legend_left with by returns a Guides object", {
  result <- legend_left(by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_right with by returns a Guides object", {
  result <- legend_right(by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_top with by returns a Guides object", {
  result <- legend_top(by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_bottom with by returns a Guides object", {
  result <- legend_bottom(by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("position functions can position legends separately", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_left(by = "colour") +
    legend_bottom(by = "size")
  expect_s3_class(p, "gg")
})

# =============================================================================
# legend_style with by parameter
# =============================================================================

test_that("legend_style with by returns a Guides object", {
  result <- legend_style(size = 14, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style can style legends separately", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_style(title_face = "bold", by = "colour") +
    legend_style(size = 10, by = "size")
  expect_s3_class(p, "gg")
})

test_that("legend_style with by normalizes color to colour", {
  result <- legend_style(size = 14, by = "color")
  expect_s3_class(result, "Guides")
})
