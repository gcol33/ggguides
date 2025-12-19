#' Collect Axes from Patchwork Compositions
#'
#' Collects duplicate axes from multiple plots in a patchwork composition,
#' removing redundant axis labels and ticks. This is a convenience wrapper
#' around patchwork's axis collection functionality.
#'
#' @param x A patchwork object created by combining ggplot2 plots.
#' @param guides How to handle guides. Either \code{"collect"} to combine into a
#'   single legend (default), or \code{"keep"} to maintain separate legends.
#'
#' @return A patchwork object with collected axes.
#'
#' @details
#' This function applies patchwork's \code{axes = "collect"} layout option,
#' which removes duplicate axes when plots are stacked or placed side-by-side.
#' For example, in a 2x1 vertical layout, the x-axis labels on the top plot
#' will be removed since they are redundant with the bottom plot's x-axis.
#'
#' When \code{guides = "collect"}, legends are also merged into a single
#' shared legend.
#'
#' For cowplot: Axis alignment in cowplot requires manual use of
#' \code{\link[cowplot]{align_plots}} with \code{align = "h"} or \code{"v"}.
#' This function does not directly support cowplot objects.
#'
#' @examples
#' \donttest{
#' library(ggplot2)
#' library(patchwork)
#'
#' # Two plots stacked vertically - x-axis is duplicated
#' p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   labs(y = "Weight")
#' p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
#'   geom_point() +
#'   labs(y = "Horsepower")
#'
#' # Without collect_axes: both plots show x-axis
#' p1 / p2
#'
#' # With collect_axes: removes redundant x-axis from top plot
#' collect_axes(p1 / p2)
#'
#' # Keep separate legends
#' collect_axes(p1 / p2, guides = "keep")
#' }
#'
#' @seealso \code{\link{collect_legends}}, \code{\link{legend_left}}, \code{\link{legend_wrap}}
#' @export
collect_axes <- function(x, guides = c("collect", "keep")) {
  check_installed("patchwork",
    reason = "to collect axes from plot compositions."
  )

  guides <- match.arg(guides)

  if (!inherits(x, "patchwork")) {
    stop("`x` must be a patchwork object. Create one by combining ggplot objects with |, /, or +.",
         call. = FALSE)
  }

  # Determine guide collection setting
  guide_setting <- if (guides == "collect") "collect" else "keep"

  # Apply patchwork layout with axis collection
  x + patchwork::plot_layout(
    guides = guide_setting,
    axes = "collect"
  )
}

#' @rdname collect_axes
#' @export
align_guides_h <- function(x, guides = c("collect", "keep")) {
  .Deprecated("collect_axes")
  collect_axes(x, guides)
}
