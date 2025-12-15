#' Style Continuous Color Bar Legends
#'
#' Customize the appearance of color bar legends for continuous scales.
#' This provides a simpler interface to `guide_colourbar()`.
#'
#' @param width Numeric. Width of the color bar in lines. Default is 1.
#' @param height Numeric. Height of the color bar in lines. Default is 5.
#' @param ticks Logical. Whether to show tick marks. Default is TRUE.
#' @param ticks_length Numeric. Length of tick marks in lines. Default is 0.2.
#' @param frame Logical or character. If TRUE, draws a black frame. If a color
#'   string, draws a frame in that color. If FALSE or NULL, no frame. Default is FALSE.
#' @param frame_linewidth Numeric. Line width of the frame. Default is 0.5.
#' @param label Logical. Whether to show labels. Default is TRUE.
#' @param label_position Character. Position of labels: "right", "left", "top",
#'   or "bottom". Default depends on bar orientation.
#' @param title_position Character. Position of title: "top", "bottom", "left",
#'   or "right". Default is "top".
#' @param direction Character. Direction of the bar: "vertical" or "horizontal".
#'   Default is "vertical".
#' @param reverse Logical. Whether to reverse the color bar. Default is FALSE.
#' @param nbin Integer. Number of bins used to draw the color bar. Higher values
#'   give smoother gradients. Default is 300.
#' @param aesthetic Character. Which aesthetic to apply to. Default is "colour".
#'   Common values: "colour", "color", "fill".
#'
#' @return A ggplot2 guides specification.
#'
#' @details
#' This function simplifies common color bar customizations:
#'
#' - **Size**: Use `width` and `height` to make thin/wide bars
#' - **Ticks**: Toggle with `ticks`, adjust length with `ticks_length`
#' - **Frame**: Add a border with `frame = TRUE` or `frame = "grey50"`
#' - **Orientation**: Use `direction = "horizontal"` for horizontal bars
#'
#' The function uses the theme system internally, which is the recommended
#' approach in ggplot2 3.5.0+.
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_tile()
#'
#' # Default appearance
#' p
#'
#' # Taller, thinner bar
#' p + colorbar_style(width = 0.5, height = 10)
#'
#' # Wide horizontal bar
#' p + colorbar_style(width = 10, height = 0.5, direction = "horizontal")
#'
#' # With frame and no ticks
#' p + colorbar_style(frame = "grey50", ticks = FALSE)
#'
#' # Thin bar with frame
#' p + colorbar_style(width = 0.5, height = 8, frame = TRUE)
#'
#' @seealso
#' \code{\link{legend_style}} for styling discrete legends,
#' \code{\link{legend_left}}, \code{\link{legend_bottom}} for positioning.
#'
#' @export
colorbar_style <- function(width = NULL,
                           height = NULL,
                           ticks = NULL,
                           ticks_length = NULL,
                           frame = NULL,
                           frame_linewidth = NULL,
                           label = NULL,
                           label_position = NULL,
                           title_position = NULL,
                           direction = NULL,
                           reverse = NULL,
                           nbin = NULL,
                           aesthetic = "colour") {

 # Normalize aesthetic
 aesthetic <- tolower(aesthetic)
 if (aesthetic == "color") aesthetic <- "colour"

 # Build theme for guide
 theme_args <- list()

 if (!is.null(width)) {
   theme_args$legend.key.width <- ggplot2::unit(width, "lines")
 }
 if (!is.null(height)) {
   theme_args$legend.key.height <- ggplot2::unit(height, "lines")
 }
 if (!is.null(ticks) && !ticks) {
   theme_args$legend.ticks <- ggplot2::element_blank()
 }
 if (!is.null(ticks_length)) {
   theme_args$legend.ticks.length <- ggplot2::unit(ticks_length, "lines")
 }
 if (!is.null(label) && !label) {
   theme_args$legend.text <- ggplot2::element_blank()
 }

 # Build guide arguments
 guide_args <- list()

 if (!is.null(title_position)) {
   guide_args$title.position <- title_position
 }
 if (!is.null(label_position)) {
   guide_args$label.position <- label_position
 }
 if (!is.null(direction)) {
   guide_args$direction <- direction
 }
 if (!is.null(reverse)) {
   guide_args$reverse <- reverse
 }
 if (!is.null(nbin)) {
   guide_args$nbin <- nbin
 }

 # Handle frame - must be set via theme in ggplot2 3.5.0+
 if (!is.null(frame)) {
   if (isTRUE(frame)) {
     frame_colour <- "black"
   } else if (is.character(frame)) {
     frame_colour <- frame
   } else {
     frame_colour <- NA
   }
   theme_args$legend.frame <- ggplot2::element_rect(
     colour = frame_colour,
     linewidth = frame_linewidth %||% 0.5
   )
 }

 # Add theme if we have any theme arguments
 if (length(theme_args) > 0) {
   guide_args$theme <- do.call(ggplot2::theme, theme_args)
 }

 # Create the guide
 guide_spec <- do.call(ggplot2::guide_colourbar, guide_args)

 # Return guides() call
 guides_args <- stats::setNames(list(guide_spec), aesthetic)
 do.call(ggplot2::guides, guides_args)
}

#' @rdname colorbar_style
#' @export
colourbar_style <- colorbar_style
