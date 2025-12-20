#' Extract Legend from a ggplot
#'
#' Extracts the legend (guide-box) from a ggplot object as a grob that can be
#' used independently with grid or cowplot.
#'
#' @param plot A ggplot object.
#'
#' @return A grob containing the legend, or \code{NULL} if the plot has no
#'   legend.
#'
#' @details
#' This function is useful for cowplot workflows where you want to manually
#' position a shared legend. The extracted legend can be combined with plots
#' using \code{cowplot::plot_grid()} or drawn directly with
#' \code{grid::grid.draw()}.
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   labs(color = "Cylinders")
#'
#' # Extract the legend
#' leg <- get_legend(p)
#'
#' # Draw just the legend
#' grid::grid.newpage()
#' grid::grid.draw(leg)
#'
#' @seealso \code{\link{shared_legend}}, \code{\link{collect_legends}}
#' @export
get_legend <- function(plot) {
  if (!inherits(plot, "ggplot"))
    stop("`plot` must be a ggplot object.", call. = FALSE)

  gt <- ggplot2::ggplotGrob(plot)


  # ggplot2 3.5.0+ uses position-specific names like "guide-box-right"
  guide_idx <- which(grepl("^guide-box", gt$layout$name))

  if (length(guide_idx) == 0) {
    return(NULL)
  }

  # Return the first non-empty guide-box
  for (idx in guide_idx) {
    grob <- gt$grobs[[idx]]
    # Check if it's a non-empty gtable (has actual content)
    if (inherits(grob, "gtable") && length(grob$grobs) > 0) {
      return(grob)
    }
  }

  # Fallback: return first guide-box even if potentially empty
gt$grobs[[guide_idx[1]]]
}


#' Combine Plots with a Shared Legend
#'
#' Combines multiple ggplot objects into a grid layout with a single shared
#' legend. Works with base ggplot and cowplot workflows (no patchwork required).
#'
#' @param ... ggplot objects to combine.
#' @param ncol Number of columns in the plot grid.
#' @param nrow Number of rows in the plot grid. If NULL (default), computed
#'   from ncol and number of plots.
#' @param position Where to place the shared legend. One of \code{"right"}
#'   (default), \code{"left"}, \code{"bottom"}, or \code{"top"}.
#' @param legend_from Which plot to extract the legend from. Default is 1
#'   (first plot). Can be an integer index or a ggplot object.
#' @param rel_legend_size Relative size of the legend compared to the plot
#'   area. Default is 0.2 (20 percent).
#'
#' @return A gtable that can be drawn with \code{grid::grid.draw()} or used
#'   with \code{cowplot::ggdraw()}.
#'
#' @details
#' This function provides a simple way to create multi-panel plots with a
#' shared legend without requiring patchwork. It:
#' \enumerate{
#'   \item Removes legends from all plots
#'   \item Extracts the legend from the specified plot
#'   \item Arranges plots in a grid
#'   \item Attaches the legend to the specified position
#' }
#'
#' For more complex layouts or patchwork users, see \code{\link{collect_legends}}.
#'
#' @examples
#' library(ggplot2)
#'
#' p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() + labs(title = "Plot 1", color = "Cylinders")
#' p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
#'   geom_point() + labs(title = "Plot 2", color = "Cylinders")
#' p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
#'   geom_point() + labs(title = "Plot 3", color = "Cylinders")
#'
#' \donttest{
#' # Side-by-side with shared legend on right
#' gt <- shared_legend(p1, p2, ncol = 2, position = "right")
#' grid::grid.newpage()
#' grid::grid.draw(gt)
#'
#' # 2x2 grid with legend at bottom
#' gt <- shared_legend(p1, p2, p3, p1, ncol = 2, nrow = 2, position = "bottom")
#' grid::grid.newpage()
#' grid::grid.draw(gt)
#'
#' # Stacked with legend on left
#' gt <- shared_legend(p1, p2, p3, ncol = 1, position = "left")
#' grid::grid.newpage()
#' grid::grid.draw(gt)
#' }
#'
#' @seealso \code{\link{get_legend}}, \code{\link{collect_legends}}
#' @export
shared_legend <- function(..., ncol = NULL, nrow = NULL,
                          position = c("right", "left", "bottom", "top"),
                          legend_from = 1,
                          rel_legend_size = 0.2) {
  plots <- list(...)
  position <- match.arg(position)

  if (length(plots) == 0)
    stop("At least one plot must be provided.", call. = FALSE)

  # Validate all are ggplots

  for (i in seq_along(plots)) {
    if (!inherits(plots[[i]], "ggplot"))
      stop("All arguments must be ggplot objects. Argument ", i,
           " is not a ggplot.", call. = FALSE)
  }

  # Determine grid dimensions
  n <- length(plots)
  if (is.null(ncol) && is.null(nrow)) {
    ncol <- n
    nrow <- 1
  } else if (is.null(ncol)) {
    ncol <- ceiling(n / nrow)
  } else if (is.null(nrow)) {
    nrow <- ceiling(n / ncol)
  }

  # Get the legend source plot
  if (inherits(legend_from, "ggplot")) {
    legend_plot <- legend_from
  } else {
    legend_from <- as.integer(legend_from)
    if (legend_from < 1 || legend_from > n)
      stop("`legend_from` must be between 1 and ", n, ".", call. = FALSE)
    legend_plot <- plots[[legend_from]]
  }

  # Adjust legend orientation based on position
  if (position %in% c("bottom", "top")) {
    legend_plot <- legend_plot +
      ggplot2::theme(legend.direction = "horizontal")
  }

  # Extract legend
  legend <- get_legend(legend_plot)

  if (is.null(legend)) {
    warning("No legend found in the source plot. Returning plots without shared legend.",
            call. = FALSE)
    # Still arrange plots without legend
    plots_no_legend <- lapply(plots, function(p) {
      p + ggplot2::theme(legend.position = "none")
    })
    return(do.call(gridExtra::arrangeGrob,
                   c(plots_no_legend, list(ncol = ncol, nrow = nrow))))
  }

  # Remove legends from all plots
  plots_no_legend <- lapply(plots, function(p) {
    p + ggplot2::theme(legend.position = "none")
  })

  # Arrange plots
  plot_grid <- do.call(gridExtra::arrangeGrob,
                       c(plots_no_legend, list(ncol = ncol, nrow = nrow)))

  # Calculate sizes
  legend_size <- rel_legend_size
  plot_size <- 1 - legend_size

  # Combine plot grid with legend
  if (position == "right") {
    combined <- gridExtra::arrangeGrob(
      plot_grid, legend,
      ncol = 2,
      widths = grid::unit(c(plot_size, legend_size), "npc")
    )
  } else if (position == "left") {
    combined <- gridExtra::arrangeGrob(
      legend, plot_grid,
      ncol = 2,
      widths = grid::unit(c(legend_size, plot_size), "npc")
    )
  } else if (position == "bottom") {
    combined <- gridExtra::arrangeGrob(
      plot_grid, legend,
      nrow = 2,
      heights = grid::unit(c(plot_size, legend_size), "npc")
    )
  } else { # top
    combined <- gridExtra::arrangeGrob(
      legend, plot_grid,
      nrow = 2,
      heights = grid::unit(c(legend_size, plot_size), "npc")
    )
  }

  combined
}
