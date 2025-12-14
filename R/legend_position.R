#' Place Legend on the Left with Proper Alignment
#'
#' A one-liner to position the legend on the left side of the plot with correct
#' left alignment for both the key box and text labels. This goes beyond simple
#' \code{legend.position = "left"} by also setting justification and box alignment.
#'
#' @return A ggplot2 theme object that can be added to a plot.
#'
#' @details
#' This function sets three theme elements:
#' \itemize{
#'   \item \code{legend.position = "left"} to place the legend on the left
#'   \item \code{legend.justification = "left"} to left-justify the legend box
#'   \item \code{legend.box.just = "left"} to left-align multiple legend boxes
#' }
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
#' @seealso \code{\link{legend_wrap}}, \code{\link{collect_legends}}
#' @export
legend_left <- function() {
  theme(
    legend.position = "left",
    legend.justification = "left",
    legend.box.just = "left"
  )
}
