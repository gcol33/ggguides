# =============================================================================
# Legend Position Functions
# =============================================================================

#' Place Legend on the Left with Proper Alignment
#'
#' A one-liner to position the legend on the left side of the plot. Slides the
#' legend along the left rail via \code{justification}, and left-aligns multiple
#' legend boxes via \code{legend.box.just}.
#'
#' @param justification Where the legend sits along the left edge.
#'   One of \code{"top"}, \code{"center"}, \code{"bottom"}, or a numeric value
#'   in \code{[0, 1]} (0 = bottom, 1 = top). Default is \code{"center"}.
#'   Only used when \code{by} is NULL. For per-guide justification, use
#'   \code{\link{legend_style}(by = ..., justification = ...)}.
#' @param by Optional aesthetic name (character) to position only a specific
#'   legend. When specified, uses per-guide positioning via
#'   \code{guide_legend(position = "left")}. Requires ggplot2 >= 3.5.0.
#'   Common values: \code{"colour"}, \code{"fill"}, \code{"size"}.
#'
#' @return A ggplot2 theme object (when \code{by} is NULL) or a guides
#'   specification (when \code{by} is specified).
#'
#' @details
#' The left-positioned legend lives in a vertical rail along the panel's left
#' edge. \code{justification} slides it along that rail: \code{"top"} pins the
#' legend's top edge to the panel top; \code{"bottom"} pins its bottom edge to
#' the panel bottom; \code{"center"} centers it vertically.
#'
#' Note the naming asymmetry with \code{\link{legend_inside}}: for side legends
#' the justification keyword refers to where the legend sits along the panel
#' edge; for inside legends it refers to which corner of the legend anchors to
#' the \code{(x, y)} position.
#'
#' When \code{by} is NULL (default), this function sets:
#' \itemize{
#'   \item \code{legend.position = "left"}
#'   \item \code{legend.justification.left = justification}
#'   \item \code{legend.box.just = "left"} to left-align multiple legend boxes
#' }
#'
#' When \code{by} is specified, only the legend for that aesthetic is moved.
#'
#' @examples
#' library(ggplot2)
#'
#' # Basic usage — legend centered vertically on the left
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_left()
#'
#' # Pin legend to the top of the left rail
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_left(justification = "top")
#'
#' # Position only the colour legend on the left
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point() +
#'   legend_left(by = "colour") +
#'   legend_bottom(by = "size")
#'
#' @seealso \code{\link{legend_right}}, \code{\link{legend_top}},
#'   \code{\link{legend_bottom}}, \code{\link{legend_inside}},
#'   \code{\link{legend_none}}
#' @export
legend_left <- function(justification = "center", by = NULL) {
  if (is.null(by)) {
    theme(
      legend.position = "left",
      legend.justification.left = justification,
      legend.box.just = "left"
    )
  } else {
    ggguides_guide_update(
      by = normalize_aesthetic(by),
      guide_params = list(position = "left")
    )
  }
}

#' Place Legend on the Right with Proper Alignment
#'
#' A one-liner to position the legend on the right side of the plot. Slides the
#' legend along the right rail via \code{justification}, and right-aligns
#' multiple legend boxes via \code{legend.box.just}.
#'
#' @param justification Where the legend sits along the right edge.
#'   One of \code{"top"}, \code{"center"}, \code{"bottom"}, or a numeric value
#'   in \code{[0, 1]} (0 = bottom, 1 = top). Default is \code{"center"}.
#'   Only used when \code{by} is NULL.
#' @param by Optional aesthetic name (character) to position only a specific
#'   legend. When specified, uses per-guide positioning via
#'   \code{guide_legend(position = "right")}. Requires ggplot2 >= 3.5.0.
#'   Common values: \code{"colour"}, \code{"fill"}, \code{"size"}.
#'
#' @return A ggplot2 theme object (when \code{by} is NULL) or a guides
#'   specification (when \code{by} is specified).
#'
#' @details
#' \code{justification} slides the legend along the right rail:
#' \code{"top"} / \code{"center"} / \code{"bottom"} or a number in \code{[0, 1]}.
#' For per-guide justification, use
#' \code{\link{legend_style}(by = ..., justification = ...)}.
#'
#' @examples
#' library(ggplot2)
#'
#' # Basic usage
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_right()
#'
#' # Pin legend to the bottom of the right rail
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_right(justification = "bottom")
#'
#' # Position only the size legend on the right
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point() +
#'   legend_bottom(by = "colour") +
#'   legend_right(by = "size")
#'
#' @seealso \code{\link{legend_left}}, \code{\link{legend_top}},
#'   \code{\link{legend_bottom}}, \code{\link{legend_inside}}
#' @export
legend_right <- function(justification = "center", by = NULL) {
  if (is.null(by)) {
    theme(
      legend.position = "right",
      legend.justification.right = justification,
      legend.box.just = "right"
    )
  } else {
    ggguides_guide_update(
      by = normalize_aesthetic(by),
      guide_params = list(position = "right")
    )
  }
}

#' Place Legend on Top with Horizontal Layout
#'
#' A one-liner to position the legend above the plot with horizontal layout.
#' Optionally aligns to the full plot area (including title) rather than just
#' the panel.
#'
#' @param justification Where the legend sits along the top edge.
#'   One of \code{"left"}, \code{"center"}, \code{"right"}, or a numeric value
#'   in \code{[0, 1]} (0 = left, 1 = right). Default is \code{"center"}.
#'   Only used when \code{by} is NULL.
#' @param align_to Where to align the legend. Either \code{"panel"} (default,
#'   aligns to plot panel) or \code{"plot"} (aligns to full plot including title).
#'   Requires ggplot2 >= 3.5.0 for \code{"plot"} alignment. Ignored when
#'   \code{by} is specified.
#' @param by Optional aesthetic name (character) to position only a specific
#'   legend. When specified, uses per-guide positioning via
#'   \code{guide_legend(position = "top")}. Requires ggplot2 >= 3.5.0.
#'   Common values: \code{"colour"}, \code{"fill"}, \code{"size"}.
#'
#' @return A ggplot2 theme object (when \code{by} is NULL) or a guides
#'   specification (when \code{by} is specified).
#'
#' @details
#' \code{justification} slides the legend along the top rail:
#' \code{"left"} / \code{"center"} / \code{"right"} or a number in \code{[0, 1]}.
#' For per-guide justification, use
#' \code{\link{legend_style}(by = ..., justification = ...)}.
#'
#' @examples
#' library(ggplot2)
#'
#' # Basic usage - aligned to panel
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_top()
#'
#' # Slide legend to the left end of the top rail
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_top(justification = "left")
#'
#' # Aligned to full plot (useful with titles)
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   labs(title = "My Plot Title") +
#'   legend_top(align_to = "plot")
#'
#' # Position only the colour legend on top
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point() +
#'   legend_top(by = "colour") +
#'   legend_right(by = "size")
#'
#' @seealso \code{\link{legend_bottom}}, \code{\link{legend_left}},
#'   \code{\link{legend_right}}, \code{\link{legend_horizontal}}
#' @export
legend_top <- function(justification = "center",
                       align_to = c("panel", "plot"), by = NULL) {
  if (!is.null(by)) {
    return(ggguides_guide_update(
      by = normalize_aesthetic(by),
      guide_params = list(position = "top", direction = "horizontal")
    ))
  }

  align_to <- match.arg(align_to)

  theme_args <- list(
    legend.position = "top",
    legend.justification.top = justification,
    legend.box.just = "center",
    legend.direction = "horizontal"
  )

  # legend.location requires ggplot2 >= 3.5.0
  if (align_to == "plot") {
    theme_args$legend.location <- "plot"
  }

  do.call(theme, theme_args)
}

#' Place Legend on Bottom with Horizontal Layout
#'
#' A one-liner to position the legend below the plot with horizontal layout.
#' Optionally aligns to the full plot area rather than just the panel.
#'
#' @param justification Where the legend sits along the bottom edge.
#'   One of \code{"left"}, \code{"center"}, \code{"right"}, or a numeric value
#'   in \code{[0, 1]} (0 = left, 1 = right). Default is \code{"center"}.
#'   Only used when \code{by} is NULL.
#' @param align_to Where to align the legend. Either \code{"panel"} (default,
#'   aligns to plot panel) or \code{"plot"} (aligns to full plot including title).
#'   Requires ggplot2 >= 3.5.0 for \code{"plot"} alignment. Ignored when
#'   \code{by} is specified.
#' @param by Optional aesthetic name (character) to position only a specific
#'   legend. When specified, uses per-guide positioning via
#'   \code{guide_legend(position = "bottom")}. Requires ggplot2 >= 3.5.0.
#'   Common values: \code{"colour"}, \code{"fill"}, \code{"size"}.
#'
#' @return A ggplot2 theme object (when \code{by} is NULL) or a guides
#'   specification (when \code{by} is specified).
#'
#' @details
#' \code{justification} slides the legend along the bottom rail. For per-guide
#' justification, use \code{\link{legend_style}(by = ..., justification = ...)}.
#'
#' @examples
#' library(ggplot2)
#'
#' # Basic usage
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_bottom()
#'
#' # Slide legend to the right end of the bottom rail
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_bottom(justification = "right")
#'
#' # Aligned to full plot
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   labs(title = "My Plot Title") +
#'   legend_bottom(align_to = "plot")
#'
#' # Position only the colour legend at bottom
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point() +
#'   legend_bottom(by = "colour") +
#'   legend_right(by = "size")
#'
#' @seealso \code{\link{legend_top}}, \code{\link{legend_left}},
#'   \code{\link{legend_right}}, \code{\link{legend_horizontal}}
#' @export
legend_bottom <- function(justification = "center",
                          align_to = c("panel", "plot"), by = NULL) {
  if (!is.null(by)) {
    return(ggguides_guide_update(
      by = normalize_aesthetic(by),
      guide_params = list(position = "bottom", direction = "horizontal")
    ))
  }

  align_to <- match.arg(align_to)

  theme_args <- list(
    legend.position = "bottom",
    legend.justification.bottom = justification,
    legend.box.just = "center",
    legend.direction = "horizontal"
  )

  if (align_to == "plot") {
    theme_args$legend.location <- "plot"
  }

  do.call(theme, theme_args)
}

#' Remove Legend from Plot
#'
#' A one-liner to remove the legend from a plot. Cleaner alternative to
#' \code{theme(legend.position = "none")}.
#'
#' @return A ggplot2 theme object that can be added to a plot.
#'
#' @examples
#' library(ggplot2)
#'
#' # Remove legend
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_none()
#'
#' @seealso \code{\link{legend_left}}, \code{\link{legend_right}}
#' @export
legend_none <- function() {
  theme(legend.position = "none")
}

#' Place Legend Inside the Plot Area
#'
#' Position the legend inside the plot panel at specified coordinates or using
#' convenient position shortcuts like \code{"topright"} or \code{"bottomleft"}.
#'
#' @param x Numeric x-coordinate in normalized 0-1 space, where 0 is left
#'   and 1 is right. Ignored if \code{position} is specified.
#' @param y Numeric y-coordinate in normalized 0-1 space, where 0 is bottom
#'   and 1 is top. Ignored if \code{position} is specified.
#' @param position Character shortcut for common positions. One of
#'   \code{"topleft"}, \code{"top"}, \code{"topright"}, \code{"left"},
#'   \code{"center"}, \code{"right"}, \code{"bottomleft"}, \code{"bottom"},
#'   \code{"bottomright"}. If specified, overrides \code{x} and \code{y}.
#' @param justification Justification of legend relative to the anchor point.
#'   Either a character vector of length 2 (horizontal, vertical) or a single
#'   value. Common values: \code{c("left", "top")}, \code{c("right", "bottom")},
#'   \code{"center"}. If \code{NULL}, automatically determined based on position.
#' @param just Deprecated. Use \code{justification} instead.
#' @param background Background fill color for the legend. Default is
#'   \code{"white"}.
#' @param border Border color for the legend box. Default is \code{NA} (no border).
#' @param padding Padding around legend content in cm. Default is \code{0.2}.
#'
#' @return A ggplot2 theme object that can be added to a plot.
#'
#' @examples
#' library(ggplot2)
#'
#' # Using position shortcuts (recommended)
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_inside(position = "topright")
#'
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_inside(position = "bottomleft")
#'
#' # Using coordinates
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_inside(x = 0.95, y = 0.95, justification = c("right", "top"))
#'
#' # Custom background and border
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_inside(position = "topright", background = "grey95", border = "grey50")
#'
#' @seealso \code{\link{legend_left}}, \code{\link{legend_right}},
#'   \code{\link{legend_top}}, \code{\link{legend_bottom}}
#' @export
legend_inside <- function(x = NULL, y = NULL, position = NULL, justification = NULL,
                          background = "white", border = NA, padding = 0.2,
                          just = NULL) {

  if (!is.null(just)) {
    warning("`just` is deprecated; use `justification` instead.", call. = FALSE)
    if (is.null(justification)) justification <- just
  }

  valid_positions <- c(
    "topleft", "top", "topright",
    "left", "center", "right",
    "bottomleft", "bottom", "bottomright"
  )

  if (!is.null(position)) {
    position <- match.arg(position, valid_positions)
    coords <- switch(position,
      "topleft"     = list(x = 0.02, y = 0.98, justification = c("left", "top")),
      "top"         = list(x = 0.50, y = 0.98, justification = c("center", "top")),
      "topright"    = list(x = 0.98, y = 0.98, justification = c("right", "top")),
      "left"        = list(x = 0.02, y = 0.50, justification = c("left", "center")),
      "center"      = list(x = 0.50, y = 0.50, justification = c("center", "center")),
      "right"       = list(x = 0.98, y = 0.50, justification = c("right", "center")),
      "bottomleft"  = list(x = 0.02, y = 0.02, justification = c("left", "bottom")),
      "bottom"      = list(x = 0.50, y = 0.02, justification = c("center", "bottom")),
      "bottomright" = list(x = 0.98, y = 0.02, justification = c("right", "bottom"))
    )
    x <- coords$x
    y <- coords$y
    if (is.null(justification)) {
      justification <- coords$justification
    }
  }

  if (is.null(x) || is.null(y)) {
    stop("Either provide `position` or both `x` and `y` coordinates.", call. = FALSE)
  }

  if (is.null(justification)) {
    justification <- c("left", "top")
  }

  theme(
    legend.position = "inside",
    legend.position.inside = c(x, y),
    legend.justification.inside = justification,
    legend.background = element_rect(fill = background, color = border),
    legend.margin = margin(padding, padding, padding, padding, "cm")
  )
}

# =============================================================================
# Legend Direction Functions
# =============================================================================

#' Set Legend Direction to Horizontal
#'
#' A one-liner to arrange legend keys horizontally. Useful for legends placed
#' at the top or bottom of a plot.
#'
#' @return A ggplot2 theme object that can be added to a plot.
#'
#' @examples
#' library(ggplot2)
#'
#' # Horizontal legend at bottom
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_bottom() +
#'   legend_horizontal()
#'
#' @seealso \code{\link{legend_vertical}}, \code{\link{legend_top}},
#'   \code{\link{legend_bottom}}
#' @export
legend_horizontal <- function() {
  theme(legend.direction = "horizontal")
}

#' Set Legend Direction to Vertical
#'
#' A one-liner to arrange legend keys vertically. This is the default for
#' legends placed on the left or right of a plot.
#'
#' @return A ggplot2 theme object that can be added to a plot.
#'
#' @examples
#' library(ggplot2)
#'
#' # Explicitly set vertical direction
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_right() +
#'   legend_vertical()
#'
#' @seealso \code{\link{legend_horizontal}}, \code{\link{legend_left}},
#'   \code{\link{legend_right}}
#' @export
legend_vertical <- function() {
  theme(legend.direction = "vertical")
}
