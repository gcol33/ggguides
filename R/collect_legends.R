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
      # Span specific rows - center legend at visual boundary between plots
      span <- as.integer(span)
      if (any(span < 1) || any(span > length(panel_rows_t))) {
        stop("span indices must be between 1 and ", length(panel_rows_t),
             " (number of panel rows).", call. = FALSE)
      }
      # Set the layout to span from top of first panel to bottom of last panel
      first_panel_t <- panel_rows_t[min(span)]
      last_panel_b <- panel_rows_b[max(span)]
      gt$layout$t[guide_idx] <- first_panel_t
      gt$layout$b[guide_idx] <- last_panel_b

      # Find background elements to determine visual boundary between plots
      # The boundary is where background-N ends and background-(N+1) begins
      bg_idx <- grep("^background-[0-9]+$", gt$layout$name)

      if (length(bg_idx) >= 2 && length(span) > 1) {
        # Sort backgrounds by their top position
        bg_layout <- gt$layout[bg_idx, ]
        bg_layout <- bg_layout[order(bg_layout$t), ]

        # Find the boundary between the last plot in span and any plots after it
        # or between middle plots in the span
        # For span = 1:2, find boundary between background-1 and background-2
        min_span <- min(span)
        max_span <- max(span)

        # Get heights of all rows to calculate positions
        all_heights_abs <- grid::convertHeight(gt$heights, "mm", valueOnly = TRUE)
        cum_heights <- c(0, cumsum(all_heights_abs))

        # Find boundary: bottom of background for plot min_span, top of background for plot max_span
        # (when span covers multiple plots, center between first and last)
        if (min_span <= nrow(bg_layout) && max_span <= nrow(bg_layout)) {
          bg_first_b <- bg_layout$b[min_span]
          bg_last_t <- bg_layout$t[max_span]

          # Boundary is midpoint between bottom of first plot's background
          # and top of last plot's background
          pos_first_bg_bottom <- cum_heights[bg_first_b + 1]
          pos_last_bg_top <- cum_heights[bg_last_t]

          # Center at the visual boundary
          boundary_from_top <- (pos_first_bg_bottom + pos_last_bg_top) / 2

          # Calculate relative to spanned region
          spanned_top <- cum_heights[first_panel_t]
          spanned_bottom <- cum_heights[last_panel_b + 1]
          spanned_height <- spanned_bottom - spanned_top

          boundary_in_span <- boundary_from_top - spanned_top
          center_y_npc <- 1 - (boundary_in_span / spanned_height)

          # Wrap the guide grob in a viewport centered at the boundary
          guide_grob <- gt$grobs[[guide_idx]]
          gt$grobs[[guide_idx]] <- grid::gTree(
            children = grid::gList(guide_grob),
            vp = grid::viewport(y = center_y_npc, just = "center")
          )
        }
      } else {
        # Single plot or no background elements found - center at 0.5
        guide_grob <- gt$grobs[[guide_idx]]
        gt$grobs[[guide_idx]] <- grid::gTree(
          children = grid::gList(guide_grob),
          vp = grid::viewport(y = 0.5, just = "center")
        )
      }
    }
  } else {
    if (isTRUE(span)) {
      # Span all columns
      gt$layout$l[guide_idx] <- 1
      gt$layout$r[guide_idx] <- ncol(gt)
    } else if (is.numeric(span)) {
      # Span specific columns - center legend at visual boundary between plots
      span <- as.integer(span)
      if (any(span < 1) || any(span > length(panel_cols_l))) {
        stop("span indices must be between 1 and ", length(panel_cols_l),
             " (number of panel columns).", call. = FALSE)
      }
      # Set the layout to span from left of first panel to right of last panel
      first_panel_l <- panel_cols_l[min(span)]
      last_panel_r <- panel_cols_r[max(span)]
      gt$layout$l[guide_idx] <- first_panel_l
      gt$layout$r[guide_idx] <- last_panel_r

      # Find background elements to determine visual boundary between plots
      bg_idx <- grep("^background-[0-9]+$", gt$layout$name)

      if (length(bg_idx) >= 2 && length(span) > 1) {
        # Sort backgrounds by their left position
        bg_layout <- gt$layout[bg_idx, ]
        bg_layout <- bg_layout[order(bg_layout$l), ]

        min_span <- min(span)
        max_span <- max(span)

        # Get widths of all columns to calculate positions
        all_widths_abs <- grid::convertWidth(gt$widths, "mm", valueOnly = TRUE)
        cum_widths <- c(0, cumsum(all_widths_abs))

        # Find boundary between backgrounds
        if (min_span <= nrow(bg_layout) && max_span <= nrow(bg_layout)) {
          bg_first_r <- bg_layout$r[min_span]
          bg_last_l <- bg_layout$l[max_span]

          # Boundary is midpoint between right of first plot's background
          # and left of last plot's background
          pos_first_bg_right <- cum_widths[bg_first_r + 1]
          pos_last_bg_left <- cum_widths[bg_last_l]

          # Center at the visual boundary
          boundary_from_left <- (pos_first_bg_right + pos_last_bg_left) / 2

          # Calculate relative to spanned region
          spanned_left <- cum_widths[first_panel_l]
          spanned_right <- cum_widths[last_panel_r + 1]
          spanned_width <- spanned_right - spanned_left

          boundary_in_span <- boundary_from_left - spanned_left
          center_x_npc <- boundary_in_span / spanned_width

          # Wrap the guide grob in a viewport centered at the boundary
          guide_grob <- gt$grobs[[guide_idx]]
          gt$grobs[[guide_idx]] <- grid::gTree(
            children = grid::gList(guide_grob),
            vp = grid::viewport(x = center_x_npc, just = "center")
          )
        }
      } else {
        # Single plot or no background elements found - center at 0.5
        guide_grob <- gt$grobs[[guide_idx]]
        gt$grobs[[guide_idx]] <- grid::gTree(
          children = grid::gList(guide_grob),
          vp = grid::viewport(x = 0.5, just = "center")
        )
      }
    }
  }

  gt
}
