#' Horizontally Align Guides Across Plots
#'
#' Ensures that guide (legend) areas align horizontally across multiple plots
#' in a composition. This is useful when you have side-by-side or stacked plots
#' and want their legends to be visually aligned.
#'
#' @param x A patchwork object created by combining ggplot2 plots.
#' @param guides How to handle guides. Either \code{"collect"} to combine into a
#'   single legend (default), or \code{"keep"} to maintain separate legends while
#'   ensuring they align.
#'
#' @return A patchwork object with aligned guide areas.
#'
#' @details
#' This function works by applying patchwork's axis alignment features which
#' indirectly ensure that legend areas have consistent positioning. When
#' \code{guides = "collect"}, legends are also merged.
#'
#' For cowplot: Horizontal alignment in cowplot requires manual use of
#' \code{\link[cowplot]{align_plots}} with \code{align = "h"}. This function
#' does not directly support cowplot objects.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(patchwork)
#'
#' # Two plots with different y-axis label widths
#' p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   labs(y = "Weight")
#' p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
#'   geom_point() +
#'   labs(y = "A very long y-axis label")
#'
#' # Align horizontally with collected legend
#' align_guides_h(p1 / p2)
#'
#' # Keep separate legends but aligned
#' align_guides_h(p1 / p2, guides = "keep")
#' }
#'
#' @seealso \code{\link{collect_legends}}, \code{\link{legend_left}}, \code{\link{legend_wrap}}
#' @export
align_guides_h <- function(x, guides = c("collect", "keep")) {
  check_installed("patchwork",
    reason = "to align guides across plot compositions."
  )

  guides <- match.arg(guides)

  if (!inherits(x, "patchwork")) {
    stop("`x` must be a patchwork object. Create one by combining ggplot objects with |, /, or +.",
         call. = FALSE)
  }

  # Determine guide collection setting
  guide_setting <- if (guides == "collect") "collect" else "keep"

  # Apply patchwork layout with axis alignment
  x + patchwork::plot_layout(
    guides = guide_setting,
    axes = "collect"
  )
}
