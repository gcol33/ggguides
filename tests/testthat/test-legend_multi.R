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

test_that("legend_left with by returns a per-aesthetic guide update", {
  result <- legend_left(by = "colour")
  expect_s3_class(result, "ggguides_guide_update")
})

test_that("legend_right with by returns a per-aesthetic guide update", {
  result <- legend_right(by = "colour")
  expect_s3_class(result, "ggguides_guide_update")
})

test_that("legend_top with by returns a per-aesthetic guide update", {
  result <- legend_top(by = "colour")
  expect_s3_class(result, "ggguides_guide_update")
})

test_that("legend_bottom with by returns a per-aesthetic guide update", {
  result <- legend_bottom(by = "colour")
  expect_s3_class(result, "ggguides_guide_update")
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

test_that("legend_style with by returns a per-aesthetic guide update", {
  result <- legend_style(size = 14, by = "colour")
  expect_s3_class(result, "ggguides_guide_update")
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
  expect_s3_class(result, "ggguides_guide_update")
})

test_that("legend_style(by=, justification=) writes to side-specific theme slot", {
  # ggplot2 >= 3.5 does NOT consult legend.justification.{side} inside
  # guide_legend(theme = ...). The update must route justification to a
  # whole-plot theme keyed on the guide's resolved position.
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_top(by = "colour") +
    legend_style(by = "colour", justification = "left")
  expect_equal(p$theme$legend.justification.top, "left")

  p2 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_left(by = "colour") +
    legend_style(by = "colour", justification = "top")
  expect_equal(p2$theme$legend.justification.left, "top")
})

test_that("legend_style(by=, justification=) without prior position sets all four slots", {
  # Fallback when the guide's side is not yet known — any later
  # position-setter will pick the slot matching its side.
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    legend_style(by = "colour", justification = "center")
  expect_equal(p$theme$legend.justification.top, "center")
  expect_equal(p$theme$legend.justification.bottom, "center")
  expect_equal(p$theme$legend.justification.left, "center")
  expect_equal(p$theme$legend.justification.right, "center")
})

test_that("legend_style(justification=) without by sets axis-appropriate slots", {
  # "left" is only meaningful on horizontal rails (top/bottom).
  t <- legend_style(justification = "left")
  expect_equal(t$legend.justification.top, "left")
  expect_equal(t$legend.justification.bottom, "left")
  expect_null(t$legend.justification.left)
  expect_null(t$legend.justification.right)
})

test_that("per-legend justification stashes metadata and tags the plot", {
  # The render-time gtable post-processor reads `ggguides_justifications`
  # and dispatches via the gg_per_legend_just S3 class. Without the stash,
  # two legends sharing a side would collide on the global theme write.
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
    geom_point() +
    legend_top(by = "colour") + legend_top(by = "size") +
    legend_style(by = "colour", justification = "left") +
    legend_style(by = "size",   justification = "right")
  j <- attr(p, "ggguides_justifications")
  expect_equal(j$colour, "left")
  expect_equal(j$size,   "right")
  expect_true(inherits(p, "gg_per_legend_just"))
})

test_that("explicit guide_legend(order=) is respected and warns about justification", {
  # If the user already pinned an order on a guide that also has a per-legend
  # justification, we must not silently overwrite their order. Skip rail-
  # position reordering on that side and warn so they can resolve the conflict.
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(gear))) +
    geom_point(shape = 21) +
    legend_top(by = "colour") + legend_top(by = "fill") +
    legend_style(by = "colour", justification = "left") +
    legend_style(by = "fill",   justification = "right")
  # Simulate user setting order directly on a guide that retained position
  # (the cleanest way to construct this state without ggplot2's guides()
  # call wiping the position).
  p$guides$guides[["colour"]]$params$order <- 2L
  expect_warning(
    prepared <- ggguides:::assign_per_legend_order(p),
    "guide_legend\\(order"
  )
  expect_equal(prepared$guides$guides[["colour"]]$params$order, 2L)
})

test_that("layout-shape mismatch falls back to global theme with a warning", {
  options(ggguides.layout_mismatch_warned = NULL)
  on.exit(options(ggguides.layout_mismatch_warned = NULL))
  # Construct a minimal gtable shaped like guide-box-top but with the wrong
  # number of width columns. The post-processor must refuse to edit and warn.
  fake <- gtable::gtable(widths = grid::unit(rep(1, 4), "null"),
                         heights = grid::unit(1, "cm"),
                         name = "fake")
  fake <- gtable::gtable_add_grob(fake, grid::nullGrob(), t = 1, l = 2,
                                  name = "guides")
  fake <- gtable::gtable_add_grob(fake, grid::nullGrob(), t = 1, l = 3,
                                  name = "guides")
  parent <- gtable::gtable(widths = grid::unit(1, "null"),
                           heights = grid::unit(1, "null"))
  parent <- gtable::gtable_add_grob(parent, fake, t = 1, l = 1,
                                    name = "guide-box-top")
  expect_warning(
    out <- ggguides:::reposition_guide_box(parent, "top",
      list(colour = "left", fill = "right"), NULL),
    "guide-box-top"
  )
  # No edit happened — same widths back.
  inner_out <- out$grobs[[1]]
  expect_equal(length(inner_out$widths), 4)
})

test_that("stretch_guide_box_vp tolerates viewports without our fields", {
  # A viewport that only exposes name (no width/x/just): stretch should leave
  # it intact rather than crash.
  vp <- grid::viewport(name = "guides")
  vp$width <- NULL; vp$x <- NULL
  vp$valid.just <- NULL; vp$justification <- NULL
  out <- ggguides:::stretch_guide_box_vp(vp, horizontal = TRUE)
  expect_identical(out$name, "guides")
})

test_that("two legends on the same edge get independent rail positions", {
  # The pre-fix bug: legend_style(by = 'fill', justification = 'right')
  # overwrote legend_style(by = 'colour', justification = 'left') because
  # both wrote to theme(legend.justification.top = ...). After the fix,
  # the gtable post-processor places each legend at its requested fraction
  # of the rail, so they no longer collide.
  p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(gear))) +
    geom_point(shape = 21) +
    legend_top(by = "colour") + legend_top(by = "fill") +
    legend_style(by = "colour", justification = "left") +
    legend_style(by = "fill",   justification = "right")
  g <- ggguides:::ggplotGrob.gg_per_legend_just(p)
  box_idx <- which(g$layout$name == "guide-box-top")
  expect_length(box_idx, 1)
  inner <- g$grobs[[box_idx]]
  # 7-column layout: pad, 0pt, leg, gap, leg, 0pt, pad — slack distribution
  # should put 0null on each end and 1null in the middle gap.
  expect_length(inner$widths, 7)
  expect_equal(as.numeric(inner$widths[[1]]), 0)
  expect_equal(as.numeric(inner$widths[[7]]), 0)
  expect_equal(as.numeric(inner$widths[[4]]), 1)
  # Viewport must be stretched to full panel width or the null cols get
  # collapsed by ggplot2's natural-width viewport on the guide-box.
  expect_equal(as.numeric(inner$vp$width), 1)
})
