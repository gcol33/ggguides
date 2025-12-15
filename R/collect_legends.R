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
#' @param span Logical or integer vector. If \code{TRUE}, the legend will span
#'   the full height (for left/right) or width (for top/bottom). If an integer
#'   vector (e.g., \code{c(1, 2)} or \code{1:2}), the legend spans only those
#'   rows/columns. Default is \code{FALSE}. When not \code{FALSE}, returns a
#'   gtable instead of a patchwork object.
#'
#' @return A patchwork object with legends collected, or a gtable if
#'   \code{span} is not \code{FALSE}.
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
#' When \code{span} is an integer vector (e.g., \code{c(1, 2)}), the legend
#' is centered between those specific rows (for right/left) or columns (for
#' top/bottom). This is useful for attaching a legend to specific plots in a
#' stacked layout. Row/column numbers refer to the panel positions in the
#' patchwork (1-indexed).
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
#'
#' # Attach legend to specific rows (e.g., align with row 1 only)
#' p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
#'   geom_point() + labs(title = "Plot 3")
#' gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1)
#' grid::grid.draw(gt)
#'
#' # Attach legend to rows 1 and 2
#' gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1:2)
#' grid::grid.draw(gt)
#' }
#'
#' @seealso \code{\link{collect_axes}}, \code{\link{legend_left}}, \code{\link{legend_wrap}}
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

  # Check if span is FALSE (return patchwork) or something else (return gtable)
  if (identical(span, FALSE)) {
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

  # Find panel positions to map row/column indices
  # We need both top (t) and bottom (b) positions for rows,

  # and left (l) and right (r) positions for columns
  panel_idx <- grep("^panel", gt$layout$name)
  panel_layout <- gt$layout[panel_idx, ]

  # Get unique panel row positions (top and bottom of each panel row)
  panel_rows_t <- sort(unique(panel_layout$t))
  panel_rows_b <- sort(unique(panel_layout$b))

  # Get unique panel column positions (left and right of each panel column)
  panel_cols_l <- sort(unique(panel_layout$l))
  panel_cols_r <- sort(unique(panel_layout$r))

  if (position %in% c("right", "left")) {
    if (isTRUE(span)) {
      # Span all rows
      gt$layout$t[guide_idx] <- 1
      gt$layout$b[guide_idx] <- nrow(gt)
    } else if (is.numeric(span)) {
      # Span specific rows - center legend between specified panels
      span <- as.integer(span)
      if (any(span < 1) || any(span > length(panel_rows_t))) {
        stop("span indices must be between 1 and ", length(panel_rows_t),
             " (number of panel rows).", call. = FALSE)
      }
      # Set the layout to span from top of first panel to bottom of last panel
      gt$layout$t[guide_idx] <- panel_rows_t[min(span)]
      gt$layout$b[guide_idx] <- panel_rows_b[max(span)]

      # Wrap the guide grob in a viewport that centers it vertically
      guide_grob <- gt$grobs[[guide_idx]]
      gt$grobs[[guide_idx]] <- grid::gTree(
        children = grid::gList(guide_grob),
        vp = grid::viewport(y = 0.5, just = "center")
      )
    }
  } else {
    if (isTRUE(span)) {
      # Span all columns
      gt$layout$l[guide_idx] <- 1
      gt$layout$r[guide_idx] <- ncol(gt)
    } else if (is.numeric(span)) {
      # Span specific columns - center legend between specified panels
      span <- as.integer(span)
      if (any(span < 1) || any(span > length(panel_cols_l))) {
        stop("span indices must be between 1 and ", length(panel_cols_l),
             " (number of panel columns).", call. = FALSE)
      }
      # Set the layout to span from left of first panel to right of last panel
      gt$layout$l[guide_idx] <- panel_cols_l[min(span)]
      gt$layout$r[guide_idx] <- panel_cols_r[max(span)]

      # Wrap the guide grob in a viewport that centers it horizontally
      guide_grob <- gt$grobs[[guide_idx]]
      gt$grobs[[guide_idx]] <- grid::gTree(
        children = grid::gList(guide_grob),
        vp = grid::viewport(x = 0.5, just = "center")
      )
    }
  }

  gt
}
