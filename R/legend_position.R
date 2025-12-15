# =============================================================================
# Legend Position Functions
# =============================================================================

#' Place Legend on the Left with Proper Alignment
#'
#' A one-liner to position the legend on the left side of the plot with correct
#' left alignment for both the key box and text labels. This goes beyond simple
#' \code{legend.position = "left"} by also setting justification and box alignment.
#'
#' @param by Optional aesthetic name (character) to position only a specific
#'   legend. When specified, uses per-guide positioning via
#'   \code{guide_legend(position = "left")}. Requires ggplot2 >= 3.5.0.
#'   Common values: \code{"colour"}, \code{"fill"}, \code{"size"}.
#'
#' @return A ggplot2 theme object (when \code{by} is NULL) or a guides
#'   specification (when \code{by} is specified).
#'
#' @details
#' When \code{by} is NULL (default), this function sets three theme elements:
#' \itemize{
#'   \item \code{legend.position = "left"} to place the legend on the left
#'   \item \code{legend.justification = "left"} to left-justify the legend box
#'   \item \code{legend.box.just = "left"} to left-align multiple legend boxes
#' }
#'
#' When \code{by} is specified, only the legend for that aesthetic is moved,
#' allowing different legends to be placed in different positions.
#'
#' @examples
#' library(ggplot2)
#'
#' # Basic usage
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_left()
#'
#' # Works with multiple legends
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), shape = factor(am))) +
#'   geom_point(size = 3) +
#'   legend_left()
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
legend_left <- function(by = NULL) {
  if (is.null(by)) {
    theme(
      legend.position = "left",
      legend.justification = "left",
      legend.box.just = "left"
    )
  } else {
    by <- normalize_aesthetic(by)
    guides_args <- stats::setNames(
      list(guide_legend(position = "left")),
      by
    )
    do.call(guides, guides_args)
  }
}

#' Place Legend on the Right with Proper Alignment
#'
#' A one-liner to position the legend on the right side of the plot with correct
#' right alignment for both the key box and text labels.
#'
#' @param by Optional aesthetic name (character) to position only a specific
#'   legend. When specified, uses per-guide positioning via
#'   \code{guide_legend(position = "right")}. Requires ggplot2 >= 3.5.0.
#'   Common values: \code{"colour"}, \code{"fill"}, \code{"size"}.
#'
#' @return A ggplot2 theme object (when \code{by} is NULL) or a guides
#'   specification (when \code{by} is specified).
#'
#' @details
#' When \code{by} is NULL (default), this function sets three theme elements:
#' \itemize{
#'   \item \code{legend.position = "right"} to place the legend on the right
#'   \item \code{legend.justification = "right"} to right-justify the legend box
#'   \item \code{legend.box.just = "right"} to right-align multiple legend boxes
#' }
#'
#' When \code{by} is specified, only the legend for that aesthetic is moved,
#' allowing different legends to be placed in different positions.
#'
#' @examples
#' library(ggplot2)
#'
#' # Basic usage
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_right()
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
legend_right <- function(by = NULL) {
  if (is.null(by)) {
    theme(
      legend.position = "right",
      legend.justification = "right",
      legend.box.just = "right"
    )
  } else {
    by <- normalize_aesthetic(by)
    guides_args <- stats::setNames(
      list(guide_legend(position = "right")),
      by
    )
    do.call(guides, guides_args)
  }
}

#' Place Legend on Top with Horizontal Layout
#'
#' A one-liner to position the legend above the plot with horizontal layout.
#' Optionally aligns to the full plot area (including title) rather than just
#' the panel.
#'
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
#' @examples
#' library(ggplot2)
#'
#' # Basic usage - aligned to panel
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_top()
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
legend_top <- function(align_to = c("panel", "plot"), by = NULL) {
  if (!is.null(by)) {
    by <- normalize_aesthetic(by)
    guides_args <- stats::setNames(
      list(guide_legend(position = "top", direction = "horizontal")),
      by
    )
    return(do.call(guides, guides_args))
  }

  align_to <- match.arg(align_to)

  theme_args <- list(
    legend.position = "top",
    legend.justification = "center",
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
#' @examples
#' library(ggplot2)
#'
#' # Basic usage
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_bottom()
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
legend_bottom <- function(align_to = c("panel", "plot"), by = NULL) {
  if (!is.null(by)) {
    by <- normalize_aesthetic(by)
    guides_args <- stats::setNames(
      list(guide_legend(position = "bottom", direction = "horizontal")),
      by
    )
    return(do.call(guides, guides_args))
  }

  align_to <- match.arg(align_to)

  theme_args <- list(
    legend.position = "bottom",
    legend.justification = "center",
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
#' @param just Justification of legend relative to the anchor point. Either a
#'   character vector of length 2 (horizontal, vertical) or a single value.
#'   Common values: \code{c("left", "top")}, \code{c("right", "bottom")},
#'   \code{"center"}. If \code{NULL}, automatically determined based on position.
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
#'   legend_inside(x = 0.95, y = 0.95, just = c("right", "top"))
#'
#' # Custom background and border
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_inside(position = "topright", background = "grey95", border = "grey50")
#'
#' @seealso \code{\link{legend_left}}, \code{\link{legend_right}},
#'   \code{\link{legend_top}}, \code{\link{legend_bottom}}
#' @export
legend_inside <- function(x = NULL, y = NULL, position = NULL, just = NULL,
                          background = "white", border = NA, padding = 0.2) {

  valid_positions <- c(
    "topleft", "top", "topright",
    "left", "center", "right",
    "bottomleft", "bottom", "bottomright"
  )

  if (!is.null(position)) {
    position <- match.arg(position, valid_positions)
    coords <- switch(position,
      "topleft"     = list(x = 0.02, y = 0.98, just = c("left", "top")),
      "top"         = list(x = 0.50, y = 0.98, just = c("center", "top")),
      "topright"    = list(x = 0.98, y = 0.98, just = c("right", "top")),
      "left"        = list(x = 0.02, y = 0.50, just = c("left", "center")),
      "center"      = list(x = 0.50, y = 0.50, just = c("center", "center")),
      "right"       = list(x = 0.98, y = 0.50, just = c("right", "center")),
      "bottomleft"  = list(x = 0.02, y = 0.02, just = c("left", "bottom")),
      "bottom"      = list(x = 0.50, y = 0.02, just = c("center", "bottom")),
      "bottomright" = list(x = 0.98, y = 0.02, just = c("right", "bottom"))
    )
    x <- coords$x
    y <- coords$y
    if (is.null(just)) {
      just <- coords$just
    }
  }

  if (is.null(x) || is.null(y)) {
    stop("Either provide `position` or both `x` and `y` coordinates.", call. = FALSE)
  }

  if (is.null(just)) {
    just <- c("left", "top")
  }

  # ggplot2 3.5.0+ uses legend.position = "inside" with legend.position.inside
  theme(
    legend.position = "inside",
    legend.position.inside = c(x, y),
    legend.justification = just,
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
