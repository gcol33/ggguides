# =============================================================================
# Legend Styling Functions
# =============================================================================

#' Reverse Legend Order
#'
#' Reverses the order of entries in all legends. Useful when the natural data
#' order doesn't match the desired visual order (e.g., when stacking bars).
#'
#' @return A guides specification that can be added to a plot.
#'
#' @details
#' This function applies \code{guide_legend(reverse = TRUE)} to all common
#' discrete aesthetics: colour, fill, shape, size, linetype, and alpha.
#'
#' @examples
#' library(ggplot2)
#'
#' # Default order
#' p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point()
#'
#' # Reversed order
#' p2 <- p1 + legend_reverse()
#'
#' @seealso \code{\link{legend_wrap}}, \code{\link{legend_style}}
#' @export
legend_reverse <- function() {
  guide_spec <- guide_legend(reverse = TRUE)

  guides(
    colour = guide_spec,
    fill = guide_spec,
    shape = guide_spec,
    size = guide_spec,
    linetype = guide_spec,
    alpha = guide_spec
  )
}

#' Style Legend Appearance
#'
#' A comprehensive one-liner to style all legend elements consistently. Instead
#' of setting multiple theme elements separately, use this function to control
#' text, title, keys, spacing, background, and direction in one call.
#'
#' @param size Text size for legend labels (in points).
#' @param family Font family for legend text.
#' @param face Font face for legend text (\code{"plain"}, \code{"bold"},
#'   \code{"italic"}, \code{"bold.italic"}).
#' @param color Text color for legend labels.
#' @param angle Rotation angle for legend labels (in degrees). Supported values:
#'   45, -45, 90, -90. Text justification is set automatically for optimal
#'   alignment with legend keys.
#' @param title_size Text size for legend title (in points). If \code{NULL},
#'   inherits from \code{size}.
#' @param title_face Font face for legend title. If \code{NULL}, inherits from
#'   \code{face}.
#' @param title_color Text color for legend title. If \code{NULL}, inherits from
#'   \code{color}.
#' @param title_angle Rotation angle for legend title (in degrees).
#' @param title_hjust Horizontal justification for rotated title.
#' @param title_vjust Vertical justification for rotated title.
#' @param title_position Position of legend title relative to keys. One of
#'   \code{"top"}, \code{"bottom"}, \code{"left"}, \code{"right"}.
#' @param key_width Width of legend keys. Numeric (in cm) or a \code{unit} object.
#' @param key_height Height of legend keys. Numeric (in cm) or a \code{unit} object.
#' @param key_fill Background fill color for legend keys.
#' @param spacing Spacing between legend entries. Numeric (in cm) or a \code{unit}
#'   object.
#' @param spacing_x Horizontal spacing between legend entries.
#' @param spacing_y Vertical spacing between legend entries.
#' @param margin Margin around entire legend. Single value (all sides) or vector
#'   of 4 values (top, right, bottom, left) in cm.
#' @param background Legend background fill color. Use \code{NA} for transparent.
#' @param background_color Legend background border color. Use \code{NA} for no
#'   border.
#' @param box_background Background fill for the box containing multiple legends.
#'   Ignored when \code{by} is specified.
#' @param box_margin Margin around the legend box. Single value or 4-vector in cm.
#'   Ignored when \code{by} is specified.
#' @param direction Legend direction: \code{"horizontal"} or \code{"vertical"}.
#' @param byrow For multi-column legends, fill by row (\code{TRUE}) or by column
#'   (\code{FALSE}).
#' @param by Optional aesthetic name (character) to style only a specific legend.
#'   When specified, uses per-guide theming via \code{guide_legend(theme = ...)}.
#'   Requires ggplot2 >= 3.5.0. Common values: \code{"colour"}, \code{"fill"},
#'   \code{"size"}.
#'
#' @return A ggplot2 theme object (when \code{by} is NULL) or a guides
#'   specification (when \code{by} is specified).
#'
#' @examples
#' library(ggplot2)
#'
#' # Simple: consistent font
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_style(size = 12, family = "serif")
#'
#' # Styled title and keys
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_style(
#'     size = 10,
#'     title_size = 14,
#'     title_face = "bold",
#'     key_width = 1.5
#'   )
#'
#' # Full styling with background
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point() +
#'   legend_style(
#'     size = 11,
#'     title_size = 13,
#'     title_face = "bold",
#'     key_fill = "grey95",
#'     background = "white",
#'     background_color = "grey80",
#'     margin = 0.3
#'   )
#'
#' # Rotated labels for long category names
#' ggplot(mpg, aes(displ, hwy, color = class)) +
#'   geom_point() +
#'   legend_style(angle = 45)
#'
#' # Style only the colour legend
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point() +
#'   legend_style(title_face = "bold", background = "grey95", by = "colour") +
#'   legend_style(size = 10, by = "size")
#'
#' @seealso \code{\link{legend_left}}, \code{\link{legend_wrap}},
#'   \code{\link{legend_reverse}}
#' @export
legend_style <- function(
    size = NULL,
    family = NULL,
    face = NULL,
    color = NULL,
    angle = NULL,
    title_size = NULL,
    title_face = NULL,
    title_color = NULL,
    title_angle = NULL,
    title_hjust = NULL,
    title_vjust = NULL,
    title_position = NULL,
    key_width = NULL,
    key_height = NULL,
    key_fill = NULL,
    spacing = NULL,
    spacing_x = NULL,
    spacing_y = NULL,
    margin = NULL,
    background = NULL,
    background_color = NULL,
    box_background = NULL,
    box_margin = NULL,
    direction = NULL,
    byrow = NULL,
    by = NULL
) {
  # --- Per-guide styling when `by` is specified ---
  if (!is.null(by)) {
    by <- normalize_aesthetic(by)
    return(build_guide_with_style(
      by = by,
      size = size, family = family, face = face, color = color, angle = angle,
      title_size = title_size, title_face = title_face, title_color = title_color,
      title_angle = title_angle, title_hjust = title_hjust, title_vjust = title_vjust,
      title_position = title_position, key_width = key_width, key_height = key_height,
      key_fill = key_fill, spacing = spacing, spacing_x = spacing_x,
      spacing_y = spacing_y, margin = margin, background = background,
      background_color = background_color, direction = direction, byrow = byrow
    ))
  }

  args <- list()

  # --- Text styling ---
  text_args <- list()
  if (!is.null(size)) text_args$size <- size
  if (!is.null(family)) text_args$family <- family
  if (!is.null(face)) text_args$face <- face
  if (!is.null(color)) text_args$colour <- color

  # Handle angle with automatic justification
  if (!is.null(angle)) {
    if (!angle %in% c(45, -45, 90, -90)) {
      stop("angle must be one of: 45, -45, 90, -90.", call. = FALSE)
    }
    text_args$angle <- angle
    # Set optimal hjust/vjust for each angle
    if (angle == 45) {
      text_args$hjust <- 0
      text_args$vjust <- 0.5
    } else if (angle == -45) {
      text_args$hjust <- 1
      text_args$vjust <- 0.5
    } else if (angle == 90) {
      text_args$hjust <- 0
      text_args$vjust <- 0.5
    } else if (angle == -90) {
      text_args$hjust <- 1
      text_args$vjust <- 0.5
    }
  }

  # For 90/-90 rotation, auto-set key_height based on text size if not specified
  # At 90°, text width becomes height, so key_height needs to accommodate longest label
  if (!is.null(angle) && abs(angle) == 90 && is.null(key_height)) {
    # Scale by text size if specified (default ~11pt)
    text_size <- if (!is.null(size)) size else 11
    # Base: 1.5cm accommodates typical labels (~10 chars), scale with text size
    key_height <- 1.5 * (text_size / 11)
  }

  if (length(text_args) > 0) {
    args$legend.text <- do.call(element_text, text_args)
  }

  # --- Title styling (inherits from text by default, but not angle/hjust/vjust) ---
  title_args <- list()
  if (!is.null(size)) title_args$size <- size
  if (!is.null(family)) title_args$family <- family
  if (!is.null(face)) title_args$face <- face
  if (!is.null(color)) title_args$colour <- color
  # For rotated labels: center title and add bottom margin to clear angled text
  if (!is.null(angle)) {
    title_args$hjust <- 0.5
    # Add bottom margin to push title above the tallest rotated label
    title_args$margin <- margin(b = 0.3, unit = "cm")
  }
  if (!is.null(title_size)) title_args$size <- title_size
  if (!is.null(title_face)) title_args$face <- title_face
  if (!is.null(title_color)) title_args$colour <- title_color
  if (!is.null(title_angle)) title_args$angle <- title_angle
  if (!is.null(title_hjust)) title_args$hjust <- title_hjust
  if (!is.null(title_vjust)) title_args$vjust <- title_vjust

  if (length(title_args) > 0) {
    args$legend.title <- do.call(element_text, title_args)
  }
  if (!is.null(title_position)) {
    args$legend.title.position <- title_position
  }

  # --- Key styling ---
  if (!is.null(key_width)) {
    args$legend.key.width <- as_unit(key_width, "cm")
  }
  if (!is.null(key_height)) {
    args$legend.key.height <- as_unit(key_height, "cm")
  }
  if (!is.null(key_fill)) {
    args$legend.key <- element_rect(fill = key_fill, color = NA)
  }

  # --- Spacing ---
  if (!is.null(spacing)) {
    args$legend.spacing <- as_unit(spacing, "cm")
  }
  if (!is.null(spacing_x)) {
    args$legend.spacing.x <- as_unit(spacing_x, "cm")
  }
  if (!is.null(spacing_y)) {
    args$legend.spacing.y <- as_unit(spacing_y, "cm")
  }

  # --- Margin ---
  if (!is.null(margin)) {
    args$legend.margin <- as_margin(margin)
  }

  # --- Background ---
  if (!is.null(background) || !is.null(background_color)) {
    bg_fill <- if (!is.null(background)) background else NA
    bg_color <- if (!is.null(background_color)) background_color else NA
    args$legend.background <- element_rect(fill = bg_fill, color = bg_color)
  }
  if (!is.null(box_background)) {
    args$legend.box.background <- element_rect(fill = box_background, color = NA)
  }
  if (!is.null(box_margin)) {
    args$legend.box.margin <- as_margin(box_margin)
  }

  # --- Direction ---
  if (!is.null(direction)) {
    args$legend.direction <- match.arg(direction, c("horizontal", "vertical"))
  }
  if (!is.null(byrow)) {
    args$legend.byrow <- byrow
  }

  do.call(theme, args)
}

# =============================================================================
# Internal Helpers
# =============================================================================

#' Convert numeric to unit
#' @noRd
as_unit <- function(x, default_unit = "cm") {
  if (inherits(x, "unit")) {
    x
  } else {
    unit(x, default_unit)
  }
}

#' Convert numeric to margin
#' @noRd
as_margin <- function(x, default_unit = "cm") {
  if (inherits(x, "margin")) {
    x
  } else if (length(x) == 1) {
    margin(x, x, x, x, default_unit)
  } else if (length(x) == 4) {
    margin(x[1], x[2], x[3], x[4], default_unit)
  } else {
    stop("margin must be a single value or a vector of 4 values.", call. = FALSE)
  }
}

#' Build guide_legend with embedded theme for per-legend styling
#' @noRd
build_guide_with_style <- function(
    by,
    size = NULL, family = NULL, face = NULL, color = NULL, angle = NULL,
    title_size = NULL, title_face = NULL, title_color = NULL,
    title_angle = NULL, title_hjust = NULL, title_vjust = NULL,
    title_position = NULL, key_width = NULL, key_height = NULL,
    key_fill = NULL, spacing = NULL, spacing_x = NULL, spacing_y = NULL,
    margin = NULL, background = NULL, background_color = NULL,
    direction = NULL, byrow = NULL
) {
  theme_args <- list()

  # --- Text styling ---
  text_args <- list()
  if (!is.null(size)) text_args$size <- size
  if (!is.null(family)) text_args$family <- family
  if (!is.null(face)) text_args$face <- face
  if (!is.null(color)) text_args$colour <- color

  if (!is.null(angle)) {
    if (!angle %in% c(45, -45, 90, -90)) {
      stop("angle must be one of: 45, -45, 90, -90.", call. = FALSE)
    }
    text_args$angle <- angle
    if (angle == 45) {
      text_args$hjust <- 0
      text_args$vjust <- 0.5
    } else if (angle == -45) {
      text_args$hjust <- 1
      text_args$vjust <- 0.5
    } else if (angle == 90) {
      text_args$hjust <- 0
      text_args$vjust <- 0.5
    } else if (angle == -90) {
      text_args$hjust <- 1
      text_args$vjust <- 0.5
    }
  }

  # For 90/-90 rotation, auto-set key_height based on text size if not specified
  if (!is.null(angle) && abs(angle) == 90 && is.null(key_height)) {
    text_size <- if (!is.null(size)) size else 11
    key_height <- 1.5 * (text_size / 11)
  }

  if (length(text_args) > 0) {
    theme_args$legend.text <- do.call(element_text, text_args)
  }

  # --- Title styling ---
  title_args <- list()
  if (!is.null(size)) title_args$size <- size
  if (!is.null(family)) title_args$family <- family
  if (!is.null(face)) title_args$face <- face
  if (!is.null(color)) title_args$colour <- color
  if (!is.null(angle)) {
    title_args$hjust <- 0.5
    title_args$margin <- margin(b = 0.3, unit = "cm")
  }
  if (!is.null(title_size)) title_args$size <- title_size
  if (!is.null(title_face)) title_args$face <- title_face
  if (!is.null(title_color)) title_args$colour <- title_color
  if (!is.null(title_angle)) title_args$angle <- title_angle
  if (!is.null(title_hjust)) title_args$hjust <- title_hjust
  if (!is.null(title_vjust)) title_args$vjust <- title_vjust

  if (length(title_args) > 0) {
    theme_args$legend.title <- do.call(element_text, title_args)
  }
  if (!is.null(title_position)) {
    theme_args$legend.title.position <- title_position
  }

  # --- Key styling ---
  if (!is.null(key_width)) {
    theme_args$legend.key.width <- as_unit(key_width, "cm")
  }
  if (!is.null(key_height)) {
    theme_args$legend.key.height <- as_unit(key_height, "cm")
  }
  if (!is.null(key_fill)) {
    theme_args$legend.key <- element_rect(fill = key_fill, color = NA)
  }

  # --- Spacing ---
  if (!is.null(spacing)) {
    theme_args$legend.spacing <- as_unit(spacing, "cm")
  }
  if (!is.null(spacing_x)) {
    theme_args$legend.spacing.x <- as_unit(spacing_x, "cm")
  }
  if (!is.null(spacing_y)) {
    theme_args$legend.spacing.y <- as_unit(spacing_y, "cm")
  }

  # --- Margin ---
  if (!is.null(margin)) {
    theme_args$legend.margin <- as_margin(margin)
  }

  # --- Background ---
  if (!is.null(background) || !is.null(background_color)) {
    bg_fill <- if (!is.null(background)) background else NA
    bg_color <- if (!is.null(background_color)) background_color else NA
    theme_args$legend.background <- element_rect(fill = bg_fill, color = bg_color)
  }

  # --- Direction ---
  if (!is.null(direction)) {
    theme_args$legend.direction <- match.arg(direction, c("horizontal", "vertical"))
  }
  if (!is.null(byrow)) {
    theme_args$legend.byrow <- byrow
  }

  # Build embedded theme
  embedded_theme <- if (length(theme_args) > 0) {
    do.call(theme, theme_args)
  } else {
    NULL
  }

  # Create guide with embedded theme
  guide <- guide_legend(theme = embedded_theme)

  guides_args <- stats::setNames(list(guide), by)
  do.call(guides, guides_args)
}
