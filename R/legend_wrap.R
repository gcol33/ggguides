#' Wrap Legend Entries into Columns or Rows
#'
#' A one-liner to arrange legend entries in a grid layout. Works with discrete
#' legends by applying the specified layout to all color, fill, shape, size,
#' linetype, and alpha aesthetics.
#'
#' @param ncol Number of columns for the legend layout. If \code{NULL}, determined
#'   automatically based on \code{nrow}.
#' @param nrow Number of rows for the legend layout. If \code{NULL}, determined
#'   automatically based on \code{ncol}.
#' @param byrow Logical. If \code{TRUE} (default), fills by row first. If \code{FALSE},
#'   fills by column first.
#'
#' @return A list of guide specifications that can be added to a plot.
#'
#' @details
#' This function creates a \code{guides()} specification that applies the same
#' column/row layout to all common discrete aesthetics. At least one of \code{ncol}
#' or \code{nrow} should be specified.
#'
#' @examples
#' library(ggplot2)
#'
#' # Wrap a long legend into 2 columns
#' ggplot(mpg, aes(displ, hwy, color = class)) +
#'   geom_point() +
#'   legend_wrap(ncol = 2)
#'
#' # Wrap into 3 rows, filling by column
#' ggplot(mpg, aes(displ, hwy, color = class)) +
#'   geom_point() +
#'   legend_wrap(nrow = 3, byrow = FALSE)
#'
#' # Combine with legend_left for left-aligned wrapped legends
#' ggplot(mpg, aes(displ, hwy, color = class)) +
#'   geom_point() +
#'   legend_wrap(ncol = 2) +
#'   legend_left()
#'
#' @seealso \code{\link{legend_left}}, \code{\link{collect_legends}}
#' @export
legend_wrap <- function(ncol = NULL, nrow = NULL, byrow = TRUE) {
  guide_spec <- guide_legend(ncol = ncol, nrow = nrow, byrow = byrow)

  guides(
    colour = guide_spec,
    fill = guide_spec,
    shape = guide_spec,
    size = guide_spec,
    linetype = guide_spec,
    alpha = guide_spec
  )
}
