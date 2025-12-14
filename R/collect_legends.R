#' Collect Legends from Patchwork Compositions
#'
#' Collects legends from multiple plots in a patchwork composition into a single
#' legend area. This is a convenience wrapper around patchwork's guide
#' collection functionality.
#'
#' @param x A patchwork object created by combining ggplot2 plots with
#'   operators like \code{|}, \code{/}, or \code{+}.
#' @param position Where to place the collected legends. One of \code{"right"}
#'   (default), \code{"left"}, \code{"bottom"}, or \code{"top"}.
#'
#' @return A patchwork object with legends collected.
#'
#' @details
#' This function requires the patchwork package. If patchwork is not installed,
#' an informative error is raised.
#'
#' For cowplot users: cowplot does not have a built-in legend collection
#' mechanism. Consider using \code{\link[cowplot]{get_legend}} to extract legends
#' manually and \code{\link[cowplot]{plot_grid}} to arrange them. Alternatively,
#' use patchwork for automatic legend collection.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(patchwork)
#'
#' p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point()
#' p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
#'   geom_point()
#'
#' # Without collection: each plot has its own legend
#' p1 | p2
#'
#' # With collection: single shared legend
#' collect_legends(p1 | p2)
#'
#' # Place collected legend on the bottom
#' collect_legends(p1 | p2, position = "bottom")
#' }
#'
#' @seealso \code{\link{align_guides_h}}, \code{\link{legend_left}}, \code{\link{legend_wrap}}
#' @export
collect_legends <- function(x, position = c("right", "left", "bottom", "top")) {
  check_installed("patchwork",
    reason = "to collect legends from plot compositions."
  )

  position <- match.arg(position)

  if (!inherits(x, "patchwork")) {
    stop("`x` must be a patchwork object. Create one by combining ggplot objects with |, /, or +.",
         call. = FALSE)
  }

  # Use patchwork's guide collection
  x + patchwork::plot_layout(guides = "collect") &
    theme(legend.position = position)
}
