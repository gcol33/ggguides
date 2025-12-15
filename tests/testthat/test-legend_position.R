library(testthat)
library(ggplot2)

# =============================================================================
# legend_left() tests
# =============================================================================

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

# =============================================================================
# legend_right() tests
# =============================================================================

test_that("legend_right returns a theme object", {
  result <- legend_right()
  expect_s3_class(result, "theme")
})

test_that("legend_right sets correct position", {
  result <- legend_right()
  expect_equal(result$legend.position, "right")
  expect_equal(result$legend.justification, "right")
  expect_equal(result$legend.box.just, "right")
})

test_that("legend_right can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_right()
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.position, "right")
})

# =============================================================================
# legend_top() tests
# =============================================================================

test_that("legend_top returns a theme object", {
  result <- legend_top()
  expect_s3_class(result, "theme")
})

test_that("legend_top sets correct position and direction", {
  result <- legend_top()
  expect_equal(result$legend.position, "top")
  expect_equal(result$legend.direction, "horizontal")
})

test_that("legend_top align_to='plot' sets legend.location", {
  result <- legend_top(align_to = "plot")
  expect_equal(result$legend.location, "plot")
})

test_that("legend_top can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_top()
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.position, "top")
})

# =============================================================================
# legend_bottom() tests
# =============================================================================

test_that("legend_bottom returns a theme object", {
  result <- legend_bottom()
  expect_s3_class(result, "theme")
})

test_that("legend_bottom sets correct position and direction", {
  result <- legend_bottom()
  expect_equal(result$legend.position, "bottom")
  expect_equal(result$legend.direction, "horizontal")
})

test_that("legend_bottom align_to='plot' sets legend.location", {
  result <- legend_bottom(align_to = "plot")
  expect_equal(result$legend.location, "plot")
})

test_that("legend_bottom can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_bottom()
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.position, "bottom")
})

# =============================================================================
# legend_none() tests
# =============================================================================

test_that("legend_none returns a theme object", {
  result <- legend_none()
  expect_s3_class(result, "theme")
})

test_that("legend_none sets position to 'none'", {
  result <- legend_none()
  expect_equal(result$legend.position, "none")
})

test_that("legend_none can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_none()
  expect_s3_class(p, "gg")
  expect_equal(p$theme$legend.position, "none")
})

# =============================================================================
# legend_inside() tests
# =============================================================================

test_that("legend_inside returns a theme object", {
  result <- legend_inside(position = "topright")
  expect_s3_class(result, "theme")
})

test_that("legend_inside works with position shortcuts", {
  positions <- c("topleft", "top", "topright", "left", "center", "right",
                 "bottomleft", "bottom", "bottomright")
  for (pos in positions) {
    result <- legend_inside(position = pos)
    expect_s3_class(result, "theme")
    # ggplot2 3.5.0+ uses legend.position = "inside" with legend.position.inside
    expect_equal(result$legend.position, "inside")
    expect_true(is.numeric(result$legend.position.inside))
    expect_length(result$legend.position.inside, 2)
  }
})

test_that("legend_inside works with coordinates", {
  result <- legend_inside(x = 0.5, y = 0.5)
  expect_equal(result$legend.position, "inside")
  expect_equal(result$legend.position.inside, c(0.5, 0.5))
})

test_that("legend_inside errors without position or coordinates", {
  expect_error(legend_inside(), "Either provide")
})

test_that("legend_inside accepts custom background and border", {
  result <- legend_inside(position = "topright", background = "grey95", border = "black")
  expect_s3_class(result$legend.background, "element_rect")
})

test_that("legend_inside can be added to a ggplot", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_inside(position = "topright")
  expect_s3_class(p, "gg")
})

# =============================================================================
# legend_horizontal() tests
# =============================================================================

test_that("legend_horizontal returns a theme object", {
  result <- legend_horizontal()
  expect_s3_class(result, "theme")
})

test_that("legend_horizontal sets direction to horizontal", {
  result <- legend_horizontal()
  expect_equal(result$legend.direction, "horizontal")
})

# =============================================================================
# legend_vertical() tests
# =============================================================================

test_that("legend_vertical returns a theme object", {
  result <- legend_vertical()
  expect_s3_class(result, "theme")
})

test_that("legend_vertical sets direction to vertical", {
  result <- legend_vertical()
  expect_equal(result$legend.direction, "vertical")
})
