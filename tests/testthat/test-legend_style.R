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

# =============================================================================
# legend_style with angle tests
# =============================================================================

test_that("legend_style with angle returns legend_style_centered object", {
  result <- legend_style(angle = 45)
  expect_s3_class(result, "legend_style_centered")
})

test_that("legend_style accepts valid angles", {
  for (angle in c(45, -45, 90, -90)) {
    result <- legend_style(angle = angle)
    expect_s3_class(result, "legend_style_centered")
  }
})

test_that("legend_style with angle can be added to ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_style(angle = 45)
  expect_s3_class(p, "gg")
})

# =============================================================================
# legend_auto_fit() tests
# =============================================================================

test_that("legend_auto_fit returns a ggplot object", {
  p <- ggplot(mpg, aes(displ, hwy, color = class)) +
    geom_point()

  result <- legend_auto_fit(p)
  expect_s3_class(result, "ggplot")
})

test_that("legend_auto_fit errors if not a ggplot", {
  expect_error(legend_auto_fit("not a plot"), "must be a ggplot object")
  expect_error(legend_auto_fit(list()), "must be a ggplot object")
})

test_that("legend_auto_fit returns unchanged plot when legend fits", {
  # Small legend should not trigger wrapping
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point()

  result <- legend_auto_fit(p)
  expect_s3_class(result, "ggplot")
})

test_that("legend_auto_fit accepts max_ratio parameter", {
  p <- ggplot(mpg, aes(displ, hwy, color = class)) +
    geom_point()

  result <- legend_auto_fit(p, max_ratio = 0.5)
  expect_s3_class(result, "ggplot")
})

test_that("legend_auto_fit returns unchanged plot when no legend", {
  p <- ggplot(mtcars, aes(mpg, wt)) +
    geom_point()

  result <- legend_auto_fit(p)
  expect_s3_class(result, "ggplot")
})

test_that("legend_auto_fit works with fill aesthetic", {
  p <- ggplot(mpg, aes(class, fill = class)) +
    geom_bar()

  result <- legend_auto_fit(p)
  expect_s3_class(result, "ggplot")
})

# =============================================================================
# center_legend_title() tests
# =============================================================================

test_that("center_legend_title returns a gtable", {
  p <- ggplot(mpg, aes(displ, hwy, color = class)) +
    geom_point() +
    legend_style(angle = 45)

  result <- center_legend_title(p)
  expect_s3_class(result, "gtable")
})

test_that("center_legend_title errors if not a ggplot", {
  expect_error(center_legend_title("not a plot"), "must be a ggplot object")
})

test_that("center_legend_title accepts position parameter", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point()

  # Test specific positions
  for (pos in c("right", "left", "top", "bottom")) {
    result <- center_legend_title(p, position = pos)
    expect_s3_class(result, "gtable")
  }
})

test_that("center_legend_title accepts position = 'all'", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point()

  result <- center_legend_title(p, position = "all")
  expect_s3_class(result, "gtable")
})

test_that("center_legend_title works with rotated labels", {
  p <- ggplot(mpg, aes(displ, hwy, color = class)) +
    geom_point() +
    legend_style(angle = 45) +
    labs(color = "Vehicle Class")

  result <- center_legend_title(p)
  expect_s3_class(result, "gtable")
})

test_that("center_legend_title works with long titles", {
  p <- ggplot(mpg, aes(displ, hwy, color = class)) +
    geom_point() +
    legend_style(angle = 45) +
    labs(color = "This is a Very Long Legend Title That Should Wrap")

  result <- center_legend_title(p)
  expect_s3_class(result, "gtable")
})

# =============================================================================
# S3 method tests for gg_centered_title
# =============================================================================

test_that("gg_centered_title class is applied with angle", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_style(angle = 45)

  expect_true("gg_centered_title" %in% class(p))
})

test_that("gg_autofit_legend class is applied with 90-degree angle", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_style(angle = 90)

  expect_true("gg_autofit_legend" %in% class(p))
})

test_that("ggplotGrob.gg_centered_title returns gtable", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_style(angle = 45)

  result <- ggplot2::ggplotGrob(p)
  expect_s3_class(result, "gtable")
})

test_that("ggplotGrob.gg_autofit_legend returns gtable", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_style(angle = 90)

  result <- ggplot2::ggplotGrob(p)
  expect_s3_class(result, "gtable")
})

# =============================================================================
# legend_style with by parameter
# =============================================================================

test_that("legend_style with by parameter returns Guides", {
  result <- legend_style(size = 12, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by normalizes color to colour", {
  result <- legend_style(size = 12, by = "color")
  expect_s3_class(result, "Guides")
})
