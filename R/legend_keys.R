#' Customize Legend Key Appearance
#'
#' Modify the appearance of legend keys (the symbols/glyphs in the legend)
#' without affecting the plot itself. This is a simpler alternative to using
#' `guide_legend(override.aes = list(...))`.
#'
#' @param size Numeric. Size of point keys.
#' @param alpha Numeric. Alpha (transparency) of keys, between 0 and 1.
#' @param shape Numeric or character. Shape of point keys.
#' @param linewidth Numeric. Width of line keys.
#' @param linetype Character or numeric. Line type for line keys.
#' @param fill Character. Fill color for keys (e.g., bar charts).
#' @param colour,color Character. Outline/stroke color for keys.
#' @param stroke Numeric. Stroke width for point keys.
#' @param aesthetic Character vector specifying which aesthetic(s) to modify.
#'   Default is `c("colour", "fill")` which covers most common cases.
#'   Use `"all"` to apply to all legends.
#'
#' @return A list of ggplot2 guide specifications.
#'
#' @details
#' This function wraps `guide_legend(override.aes = ...)` to provide a cleaner
#' interface for common legend key modifications. It's particularly useful for:
#'
#' - Making small points more visible in the legend
#' - Removing transparency from legend keys
#' - Standardizing key appearance across different geoms
#'
#' Only non-NULL arguments are applied, so you can selectively modify specific
#' properties.
#'
#' @examples
#' library(ggplot2)
#'
#' # Points get lost in legend - make them bigger
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point(size = 1) +
#'   legend_keys(size = 4)
#'
#' # Remove transparency from legend
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point(alpha = 0.3, size = 3) +
#'   legend_keys(alpha = 1)
#'
#' # Combine modifications
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point(alpha = 0.3, size = 1) +
#'   legend_keys(size = 4, alpha = 1)
#'
#' # Apply to fill aesthetic (e.g., for boxplots)
#' ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(cyl))) +
#'   geom_boxplot(alpha = 0.5) +
#'   legend_keys(alpha = 1, aesthetic = "fill")
#'
#' @seealso
#' \code{\link{legend_style}} for styling legend text and background,
#' \code{\link{legend_order}} for reordering legend entries.
#'
#' @export
legend_keys <- function(size = NULL,
                        alpha = NULL,
                        shape = NULL,
                        linewidth = NULL,
                        linetype = NULL,
                        fill = NULL,
                        colour = NULL,
                        color = NULL,
                        stroke = NULL,
                        aesthetic = c("colour", "fill")) {

 # Handle color/colour
 if (!is.null(color) && is.null(colour)) {
   colour <- color
 }

 # Build override.aes list with only non-NULL values
 override_aes <- list()
 if (!is.null(size)) override_aes$size <- size
 if (!is.null(alpha)) override_aes$alpha <- alpha
 if (!is.null(shape)) override_aes$shape <- shape
 if (!is.null(linewidth)) override_aes$linewidth <- linewidth
 if (!is.null(linetype)) override_aes$linetype <- linetype
 if (!is.null(fill)) override_aes$fill <- fill
 if (!is.null(colour)) override_aes$colour <- colour
 if (!is.null(stroke)) override_aes$stroke <- stroke

 if (length(override_aes) == 0) {
   warning("No key modifications specified. Returning NULL.")
   return(NULL)
 }

 # Create guide specification
 guide_spec <- ggplot2::guide_legend(override.aes = override_aes)

 # Handle "all" aesthetic
 if (identical(aesthetic, "all")) {
   aesthetic <- c("colour", "fill", "shape", "size", "linetype", "alpha")
 }

 # Normalize aesthetic names
 aesthetic <- tolower(aesthetic)
 aesthetic[aesthetic == "color"] <- "colour"

 # Create guides() call
 guides_args <- stats::setNames(
   rep(list(guide_spec), length(aesthetic)),
   aesthetic
 )

 do.call(ggplot2::guides, guides_args)
}
