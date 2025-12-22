library(testthat)
library(ggplot2)

# =============================================================================
# colorbar_style() tests
# =============================================================================

test_that("colorbar_style returns a Guides object", {
  result <- colorbar_style()
  expect_s3_class(result, "Guides")
})

test_that("colorbar_style can be added to a ggplot", {
  p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
    geom_tile() +
    colorbar_style(aesthetic = "fill")
  expect_s3_class(p, "gg")
})

test_that("colorbar_style accepts width and height", {
  result <- colorbar_style(width = 0.5, height = 10)
  expect_s3_class(result, "Guides")

  p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
    geom_tile() +
    colorbar_style(width = 0.5, height = 10, aesthetic = "fill")
  expect_s3_class(p, "gg")
})

test_that("colorbar_style accepts ticks parameter", {
  # Ticks enabled (default)
  result_ticks <- colorbar_style(ticks = TRUE)
  expect_s3_class(result_ticks, "Guides")

  # Ticks disabled
  result_no_ticks <- colorbar_style(ticks = FALSE)
  expect_s3_class(result_no_ticks, "Guides")
})

test_that("colorbar_style accepts ticks_length parameter", {
  result <- colorbar_style(ticks_length = 0.5)
  expect_s3_class(result, "Guides")
})

test_that("colorbar_style accepts frame parameter", {
  # Frame as TRUE (black frame)
  result_true <- colorbar_style(frame = TRUE)
  expect_s3_class(result_true, "Guides")

  # Frame as color string
  result_color <- colorbar_style(frame = "grey50")
  expect_s3_class(result_color, "Guides")

  # Frame as FALSE (no frame)
  result_false <- colorbar_style(frame = FALSE)
  expect_s3_class(result_false, "Guides")
})

test_that("colorbar_style accepts frame_linewidth parameter", {
  result <- colorbar_style(frame = TRUE, frame_linewidth = 1)
  expect_s3_class(result, "Guides")
})

test_that("colorbar_style accepts label parameter", {
  # Labels enabled
  result_labels <- colorbar_style(label = TRUE)
  expect_s3_class(result_labels, "Guides")

  # Labels disabled
  result_no_labels <- colorbar_style(label = FALSE)
  expect_s3_class(result_no_labels, "Guides")
})

test_that("colorbar_style accepts label_position parameter", {
  for (pos in c("right", "left", "top", "bottom")) {
    result <- colorbar_style(label_position = pos)
    expect_s3_class(result, "Guides")
  }
})

test_that("colorbar_style accepts title_position parameter", {
  for (pos in c("top", "bottom", "left", "right")) {
    result <- colorbar_style(title_position = pos)
    expect_s3_class(result, "Guides")
  }
})

test_that("colorbar_style accepts direction parameter", {
  result_v <- colorbar_style(direction = "vertical")
  expect_s3_class(result_v, "Guides")

  result_h <- colorbar_style(direction = "horizontal")
  expect_s3_class(result_h, "Guides")
})

test_that("colorbar_style accepts reverse parameter", {
  result <- colorbar_style(reverse = TRUE)
  expect_s3_class(result, "Guides")
})
test_that("colorbar_style accepts nbin parameter", {
  result <- colorbar_style(nbin = 100)
  expect_s3_class(result, "Guides")
})

test_that("colorbar_style normalizes 'color' to 'colour'", {
  # Using "color" should work the same as "colour"
  p <- ggplot(mtcars, aes(mpg, wt, color = hp)) +
    geom_point() +
    colorbar_style(aesthetic = "color")
  expect_s3_class(p, "gg")
})

test_that("colorbar_style works with fill aesthetic", {
  p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
    geom_tile() +
    colorbar_style(
      width = 0.5,
      height = 8,
      frame = TRUE,
      ticks = FALSE,
      aesthetic = "fill"
    )
  expect_s3_class(p, "gg")
})

test_that("colorbar_style works with horizontal direction", {
  p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
    geom_tile() +
    colorbar_style(
      width = 10,
      height = 0.5,
      direction = "horizontal",
      aesthetic = "fill"
    )
  expect_s3_class(p, "gg")
})

# =============================================================================
# colourbar_style() alias tests
# =============================================================================

test_that("colourbar_style is an alias for colorbar_style", {
  expect_identical(colourbar_style, colorbar_style)
})

test_that("colourbar_style works the same as colorbar_style", {
  result <- colourbar_style(width = 1, height = 5)
  expect_s3_class(result, "Guides")
})
