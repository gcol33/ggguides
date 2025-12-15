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
#' @param span Logical. If \code{TRUE}, the legend will span the full
#'   height (for left/right) or width (for top/bottom) of the composition.
#'   Default is \code{FALSE}. When \code{TRUE}, returns a gtable instead of
#'   a patchwork object.
#'
#' @return A patchwork object with legends collected, or a gtable if
#'   \code{span = TRUE}.
#'
#' @details
#' This function requires the patchwork package. If patchwork is not installed,
#' an informative error is raised.
#'
#' When \code{span = TRUE}, the function converts the patchwork to a gtable
#' and modifies the legend cell to span all rows (for right/left positions) or
#' all columns (for top/bottom positions). This addresses the common issue where
#' collected legends are centered rather than spanning the full composition.
#'
#' For cowplot users: cowplot does not have a built-in legend collection
#' mechanism. Consider using the lemon package for manual legend extraction
#' and positioning.
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
#'
#' # Legend spanning full height (returns gtable, draw with grid.draw)
#' gt <- collect_legends(p1 / p2, position = "right", span = TRUE)
#' grid::grid.draw(gt)
#' }
#'
#' @seealso \code{\link{align_guides_h}}, \code{\link{legend_left}}, \code{\link{legend_wrap}}
#' @export
collect_legends <- function(x, position = c("right", "left", "bottom", "top"),
                            span = FALSE) {
  check_installed("patchwork",
    reason = "to collect legends from plot compositions."
  )

  position <- match.arg(position)

  if (!inherits(x, "patchwork")) {
    stop("`x` must be a patchwork object. Create one by combining ggplot objects with |, /, or +.",
         call. = FALSE)
  }

  # Apply guide collection
  pw <- x + patchwork::plot_layout(guides = "collect") &
    theme(legend.position = position)

  if (!span) {
    return(pw)
  }

  # For spanning, convert to gtable and modify legend position
  gt <- patchwork::patchworkGrob(pw)

  # Find the guide-box in the layout
  guide_idx <- which(gt$layout$name == "guide-box")

  if (length(guide_idx) == 0) {
    warning("No legend found in the patchwork. Returning gtable without modification.",
            call. = FALSE)
    return(gt)
  }

  # Modify the legend cell to span full height/width
  if (position %in% c("right", "left")) {
    # Span all rows
    gt$layout$t[guide_idx] <- 1
    gt$layout$b[guide_idx] <- nrow(gt)
  } else {
    # Span all columns
    gt$layout$l[guide_idx] <- 1
    gt$layout$r[guide_idx] <- ncol(gt)
  }

  gt
}
