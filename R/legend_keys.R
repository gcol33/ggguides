#' Customize Legend Key Appearance
#'
#' Modify the appearance of legend keys (the symbols/glyphs in the legend)
#' without affecting the plot itself. This is a simpler alternative to using
#' `guide_legend(override.aes = list(...))`.
#'
#' @param size Numeric. Size of point keys.
#' @param alpha Numeric. Alpha (transparency) of keys, between 0 and 1.
#' @param shape Shape of point keys. Can be:
#'   \itemize{
#'     \item Numeric (0-25): Standard ggplot2 shape codes
#'     \item Character name: \code{"circle"}, \code{"square"}, \code{"diamond"},
#'       \code{"triangle"}, \code{"triangle_down"}, \code{"plus"}, \code{"cross"},
#'       \code{"asterisk"}, \code{"circle_open"}, \code{"square_open"},
#'       \code{"diamond_open"}, \code{"triangle_open"}, \code{"circle_filled"},
#'       \code{"square_filled"}, \code{"diamond_filled"}, \code{"triangle_filled"}
#'   }
#'   Shapes 21-25 (or names ending in \code{"_filled"}) support both outline
#'   (\code{colour}) and fill (\code{fill}) colors.
#' @param linewidth Numeric. Width of line keys.
#' @param linetype Character or numeric. Line type for line keys.
#' @param fill Character. Fill color for filled shapes (shapes 21-25). For
#'   shapes 0-20, use \code{colour} instead.
#' @param colour,color Character. Outline/stroke color for keys. For shapes
#'   21-25, this controls the outline; for shapes 0-20, this is the main color.
#' @param stroke Numeric. Stroke width for point outlines (shapes 21-25).
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
#' \itemize{
#'   \item Making small points more visible in the legend
#'   \item Removing transparency from legend keys
#'   \item Changing symbol shapes to improve clarity
#'   \item Adding outlines to filled shapes for better visibility
#' }
#'
#' \strong{Shape types:}
#' \itemize{
#'   \item Shapes 0-14: Outline only (color from \code{colour})
#'   \item Shapes 15-20: Filled solid (color from \code{colour})
#'   \item Shapes 21-25: Outline + fill (outline from \code{colour}, interior
#'     from \code{fill})
#' }
#'
#' \strong{Important note for filled shapes (21-25):}
#'
#' When using filled shapes with both outline and fill colors, the behavior
#' depends on which aesthetics are mapped in your original plot:
#'
#' \itemize{
#'   \item \strong{White fill, colored outline}: Works with \code{aes(color = var)}.
#'     Use \code{legend_keys(shape = "circle_filled", fill = "white")}.
#'   \item \strong{Colored fill, black outline}: Requires \code{aes(color = var, fill = var)}
#'     in your plot. Then use \code{legend_keys(colour = "black")}.
#' }
#'
#' This is because \code{override.aes} can only set static values; it cannot
#' inherit from mapped aesthetics. If you only map \code{color} and try to
#' override the outline to black, the fill will not have a color mapping to use.
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
#' # Change shape using name
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point(size = 3) +
#'   legend_keys(shape = "square")
#'
#' # Filled shape with white fill and colored outline (shapes 21-25)
#' # Works because we set fill to a static color (white)
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point(size = 3) +
#'   legend_keys(shape = "circle_filled", fill = "white", stroke = 1.5)
#'
#' # Colored fill with black outline - MUST map both color AND fill in the plot
#' # This is a ggplot2 limitation: override.aes can only set static values,
#' # it cannot make fill "inherit" from color
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
#'   geom_point(size = 3, shape = 21, stroke = 1) +
#'   legend_keys(colour = "black", stroke = 1)
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

 # Convert shape names to numeric codes
 if (!is.null(shape) && is.character(shape)) {
   shape <- shape_name_to_code(shape)
 }

 # Warn if user likely wants colored fill with black outline but hasn't mapped fill
 # This pattern (filled shape + colour override but no fill override) often indicates
 # the user expects fill to inherit from the color mapping, which doesn't work
 is_filled_shape <- !is.null(shape) && (
   (is.numeric(shape) && shape %in% 21:25) ||
   (is.character(shape) && grepl("_filled$", tolower(shape)))
 )
 if (is_filled_shape && !is.null(colour) && is.null(fill)) {
   message(
     "Note: Using filled shapes (21-25) with a colour override but no fill.\n",
     "For colored fills with a black/custom outline, you must map both color AND fill\n",
     "in your plot: aes(color = var, fill = var), then use legend_keys(colour = \"black\")."
   )
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

# =============================================================================
# Internal Helpers
# =============================================================================

#' Convert shape name to numeric code
#' @noRd
shape_name_to_code <- function(name) {
  # Shape name mapping
  # Outline only (0-14)
  # Filled solid (15-20) - color from colour

  # Outline + fill (21-25) - outline from colour, interior from fill
  shape_map <- c(
    # Basic shapes (solid, color from colour aesthetic)
    "circle" = 16,
    "square" = 15,
    "diamond" = 18,
    "triangle" = 17,
    "triangle_down" = 25,

    # Open/outline shapes (stroke only)
    "circle_open" = 1,
    "square_open" = 0,
    "diamond_open" = 5,
    "triangle_open" = 2,

    # Filled shapes with outline (21-25: stroke from colour, fill from fill)
    "circle_filled" = 21,
    "square_filled" = 22,
    "diamond_filled" = 23,
    "triangle_filled" = 24,
    "triangle_down_filled" = 25,

    # Symbols
    "plus" = 3,
    "cross" = 4,
    "asterisk" = 8
  )

  name_lower <- tolower(name)

  if (name_lower %in% names(shape_map)) {
    return(shape_map[[name_lower]])
  }

  # If not found, return as-is (might be a single character like "a")
  name
}
