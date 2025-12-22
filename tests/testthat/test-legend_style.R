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

# =============================================================================
# legend_style with by parameter - comprehensive tests
# =============================================================================

test_that("legend_style with by accepts all styling parameters", {
  result <- legend_style(
    size = 12,
    family = "serif",
    face = "bold",
    color = "red",
    title_size = 14,
    title_face = "bold",
    title_color = "blue",
    key_width = 1.5,
    key_height = 1,
    background = "grey90",
    by = "colour"
  )
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by and angle works", {
  result <- legend_style(angle = 45, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by and title_position works", {
  result <- legend_style(title_position = "top", by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by and spacing works", {
  result <- legend_style(spacing = 0.5, by = "colour")
  expect_s3_class(result, "Guides")

  result <- legend_style(spacing_x = 0.3, spacing_y = 0.5, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by and margin works", {
  result <- legend_style(margin = 0.5, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by and direction works", {
  result <- legend_style(direction = "horizontal", by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by and byrow works", {
  result <- legend_style(byrow = TRUE, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("legend_style with by can be added to ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_style(size = 12, by = "colour") +
    legend_style(size = 10, by = "size")
  expect_s3_class(p, "gg")
})

# =============================================================================
# legend_style additional parameters
# =============================================================================

test_that("legend_style sets title_angle", {
  result <- legend_style(title_angle = 45)
  expect_s3_class(result, "theme")
})

test_that("legend_style sets title_hjust and title_vjust", {
  result <- legend_style(title_hjust = 0.5, title_vjust = 0.5)
  expect_s3_class(result, "theme")
})

test_that("legend_style sets title_position", {
  for (pos in c("top", "bottom", "left", "right")) {
    result <- legend_style(title_position = pos)
    expect_s3_class(result, "theme")
  }
})

test_that("legend_style sets key_fill", {
  result <- legend_style(key_fill = "white")
  expect_s3_class(result, "theme")
})

test_that("legend_style sets spacing", {
  result <- legend_style(spacing = 0.5)
  expect_s3_class(result, "theme")
})

test_that("legend_style sets spacing_x and spacing_y separately", {
  result <- legend_style(spacing_x = 0.3, spacing_y = 0.5)
  expect_s3_class(result, "theme")
})

test_that("legend_style sets box_background and box_margin", {
  result <- legend_style(box_background = "grey95", box_margin = 0.2)
  expect_s3_class(result, "theme")
})

test_that("legend_style sets byrow", {
  result <- legend_style(byrow = TRUE)
  expect_s3_class(result, "theme")
})

# =============================================================================
# legend_auto_fit with large legends
# =============================================================================

test_that("legend_auto_fit triggers wrapping for many items", {
  # Create plot with many legend items that might overflow
  df <- data.frame(
    x = 1:20,
    y = 1:20,
    group = factor(paste0("Category_", sprintf("%02d", 1:20)))
  )

  p <- ggplot(df, aes(x, y, color = group)) +
    geom_point() +
    legend_style(angle = 90)

  # This should potentially trigger wrapping
  result <- suppressMessages(legend_auto_fit(p, max_ratio = 0.3))
  expect_s3_class(result, "ggplot")
})

# =============================================================================
# build_guide_with_style tests (via legend_style with by)
# =============================================================================

test_that("build_guide_with_style handles all text parameters", {
  # Test through legend_style with by parameter
  result <- legend_style(
    size = 14,
    family = "mono",
    face = "italic",
    color = "darkblue",
    by = "colour"
  )
  expect_s3_class(result, "Guides")
})

test_that("build_guide_with_style handles title parameters", {
  result <- legend_style(
    title_size = 16,
    title_face = "bold.italic",
    title_color = "darkred",
    title_angle = 0,
    title_hjust = 0,
    title_vjust = 1,
    title_position = "left",
    by = "colour"
  )
  expect_s3_class(result, "Guides")
})

test_that("build_guide_with_style handles key parameters", {
  result <- legend_style(
    key_width = 2,
    key_height = 0.5,
    key_fill = "lightgrey",
    by = "colour"
  )
  expect_s3_class(result, "Guides")
})

test_that("build_guide_with_style handles background parameters", {
  result <- legend_style(
    background = "white",
    background_color = "black",
    by = "colour"
  )
  expect_s3_class(result, "Guides")
})

# =============================================================================
# legend_style face and color without by parameter
# =============================================================================

test_that("legend_style sets face without by parameter", {
  result <- legend_style(face = "bold")
  expect_s3_class(result, "theme")
  expect_s3_class(result$legend.text, "element_text")
})

test_that("legend_style sets color without by parameter", {
  result <- legend_style(color = "red")
  expect_s3_class(result, "theme")
})

test_that("legend_style sets title_color without by parameter", {
  result <- legend_style(title_color = "blue")
  expect_s3_class(result, "theme")
})

test_that("legend_style errors on invalid angle", {
  expect_error(legend_style(angle = 30), "angle must be one of")
  expect_error(legend_style(angle = 180), "angle must be one of")
})

# =============================================================================
# legend_style with negative angles
# =============================================================================

test_that("legend_style with angle = -45 sets correct hjust/vjust", {
  result <- legend_style(angle = -45)
  expect_s3_class(result, "legend_style_centered")
})

test_that("legend_style with angle = -90 sets correct hjust/vjust", {
  result <- legend_style(angle = -90)
  expect_s3_class(result, "legend_style_centered")
})

# =============================================================================
# build_guide_with_style angle tests
# =============================================================================

test_that("build_guide_with_style handles angle = -45", {
  result <- legend_style(angle = -45, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("build_guide_with_style handles angle = -90", {
  result <- legend_style(angle = -90, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("build_guide_with_style handles angle = 90", {
  result <- legend_style(angle = 90, by = "colour")
  expect_s3_class(result, "Guides")
})

test_that("build_guide_with_style errors on invalid angle", {
  expect_error(legend_style(angle = 30, by = "colour"), "angle must be one of")
})

# =============================================================================
# legend_auto_fit with fill aesthetic
# =============================================================================

test_that("legend_auto_fit uses fill scale when colour scale not available", {
  df <- data.frame(
    x = 1:15,
    y = 1:15,
    group = factor(paste0("Cat_", sprintf("%02d", 1:15)))
  )

  p <- ggplot(df, aes(x, y, fill = group)) +
    geom_tile()

  result <- suppressMessages(legend_auto_fit(p, max_ratio = 0.3))
  expect_s3_class(result, "ggplot")
})

# =============================================================================
# as_margin with margin class input
# =============================================================================

test_that("as_margin passes through margin objects", {
  m <- ggplot2::margin(1, 2, 3, 4, "cm")
  result <- ggguides:::as_margin(m)
  expect_identical(result, m)
})

# =============================================================================
# center_legend_title with specific positions
# =============================================================================

test_that("center_legend_title with position = 'right' only", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    theme(legend.position = "right")

  result <- center_legend_title(p, position = "right")
  expect_s3_class(result, "gtable")
})

test_that("center_legend_title with position = 'left' only", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    theme(legend.position = "left")

  result <- center_legend_title(p, position = "left")
  expect_s3_class(result, "gtable")
})

test_that("center_legend_title with position = 'bottom' only", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    theme(legend.position = "bottom")

  result <- center_legend_title(p, position = "bottom")
  expect_s3_class(result, "gtable")
})

test_that("center_legend_title with position = 'top' only", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    theme(legend.position = "top")

  result <- center_legend_title(p, position = "top")
  expect_s3_class(result, "gtable")
})
