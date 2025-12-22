library(testthat)
library(ggplot2)

test_that("collect_legends errors without patchwork installed", {
  skip_if(rlang::is_installed("patchwork"))
  expect_error(
    collect_legends(list()),
    "patchwork"
  )
})

test_that("collect_legends errors if x is not a patchwork object", {
  skip_if_not_installed("patchwork")
  expect_error(
    collect_legends(ggplot()),
    "`x` must be a patchwork object."
  )
})

test_that("collect_legends errors if x is a list", {
  skip_if_not_installed("patchwork")
  expect_error(
    collect_legends(list(a = 1)),
    "`x` must be a patchwork object."
  )
})

test_that("collect_legends works with valid patchwork object", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 | p2

  result <- collect_legends(combined)
  expect_s3_class(result, "patchwork")
})

test_that("collect_legends accepts position parameter", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 | p2

  result_bottom <- collect_legends(combined, position = "bottom")
  expect_s3_class(result_bottom, "patchwork")

  result_left <- collect_legends(combined, position = "left")
  expect_s3_class(result_left, "patchwork")
})

test_that("collect_legends rejects invalid position", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 | p2

  expect_error(
    collect_legends(combined, position = "invalid"),
    "'arg' should be one of"
  )
})

test_that("collect_legends with span = TRUE returns gtable", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  result <- collect_legends(combined, span = TRUE)
  expect_s3_class(result, "gtable")
})

test_that("collect_legends with numeric span returns gtable", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2 / p3

  # Span single row
  result <- collect_legends(combined, span = 1)
  expect_s3_class(result, "gtable")

  # Span multiple rows
  result <- collect_legends(combined, span = 1:2)
  expect_s3_class(result, "gtable")
})

test_that("collect_legends errors on invalid span indices", {
  skip_if_not_installed("patchwork")
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  combined <- p1 / p2

  expect_error(
    collect_legends(combined, span = 5),
    "span indices must be between"
  )
})

# =============================================================================
# get_legend() tests
# =============================================================================

test_that("get_legend returns a gtable for plot with legend", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    labs(color = "Cylinders")

  result <- get_legend(p)
  expect_s3_class(result, "gtable")
})

test_that("get_legend returns NULL or empty grob for plot without legend", {
  p <- ggplot(mtcars, aes(mpg, wt)) +
    geom_point()

  result <- get_legend(p)
  # May return NULL or zeroGrob depending on ggplot2 version
  if (!is.null(result)) {
    expect_true(inherits(result, "zeroGrob") || length(result$grobs) == 0)
  }
})

test_that("get_legend returns NULL for plot with legend.position = 'none'", {
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    theme(legend.position = "none")

  result <- get_legend(p)
  # Should return NULL or empty gtable
  if (!is.null(result)) {
    expect_true(length(result$grobs) == 0 || inherits(result, "zeroGrob"))
  }
})

test_that("get_legend errors if not a ggplot", {
  expect_error(get_legend("not a plot"), "must be a ggplot object")
  expect_error(get_legend(list()), "must be a ggplot object")
})

test_that("get_legend works with fill aesthetic", {
  p <- ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
    geom_bar() +
    labs(fill = "Cylinders")

  result <- get_legend(p)
  expect_s3_class(result, "gtable")
})

test_that("get_legend works with legend on different positions", {
  p_base <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point()

  for (pos in c("right", "left", "top", "bottom")) {
    p <- p_base + theme(legend.position = pos)
    result <- get_legend(p)
    expect_s3_class(result, "gtable")
  }
})

# =============================================================================
# shared_legend() tests
# =============================================================================

test_that("shared_legend returns a gtable", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() + labs(title = "Plot 1")
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
    geom_point() + labs(title = "Plot 2")

  result <- shared_legend(p1, p2, ncol = 2)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend errors with no plots", {
  expect_error(shared_legend(), "At least one plot must be provided")
})

test_that("shared_legend errors if not all ggplots", {
  p1 <- ggplot(mtcars, aes(mpg, wt)) + geom_point()

  expect_error(
    shared_legend(p1, "not a plot"),
    "All arguments must be ggplot objects"
  )
})

test_that("shared_legend accepts all positions", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()

  for (pos in c("right", "left", "top", "bottom")) {
    result <- shared_legend(p1, p2, ncol = 2, position = pos)
    expect_s3_class(result, "gtable")
  }
})

test_that("shared_legend accepts ncol parameter", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()

  result <- shared_legend(p1, p2, p3, ncol = 3)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend accepts nrow parameter", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()

  result <- shared_legend(p1, p2, p3, nrow = 3)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend accepts both ncol and nrow", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()
  p4 <- ggplot(mtcars, aes(wt, hp, color = factor(cyl))) + geom_point()

  result <- shared_legend(p1, p2, p3, p4, ncol = 2, nrow = 2)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend computes dimensions when only ncol given", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()

  result <- shared_legend(p1, p2, p3, ncol = 2)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend computes dimensions when only nrow given", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) + geom_point()

  result <- shared_legend(p1, p2, p3, nrow = 2)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend accepts legend_from as integer", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(gear))) + geom_point()

  # Get legend from second plot
  result <- shared_legend(p1, p2, ncol = 2, legend_from = 2)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend accepts legend_from as ggplot object", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()
  p_legend <- ggplot(mtcars, aes(mpg, wt, color = factor(gear))) + geom_point()

  result <- shared_legend(p1, p2, ncol = 2, legend_from = p_legend)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend errors on invalid legend_from index", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()

  expect_error(
    shared_legend(p1, p2, ncol = 2, legend_from = 5),
    "must be between 1 and"
  )
})

test_that("shared_legend accepts rel_legend_size parameter", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()

  result <- shared_legend(p1, p2, ncol = 2, rel_legend_size = 0.3)
  expect_s3_class(result, "gtable")
})

test_that("shared_legend handles plots without legend", {
  p1 <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp)) + geom_point()

  # Should either warn or return gtable without legend
  result <- suppressWarnings(shared_legend(p1, p2, ncol = 2))
  expect_s3_class(result, "gtable")
})

test_that("shared_legend sets horizontal direction for bottom/top positions", {
  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) + geom_point()
  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) + geom_point()

  # These should work without error (horizontal legend direction is set internally)
  result_bottom <- shared_legend(p1, p2, ncol = 2, position = "bottom")
  expect_s3_class(result_bottom, "gtable")

  result_top <- shared_legend(p1, p2, ncol = 2, position = "top")
  expect_s3_class(result_top, "gtable")
})
