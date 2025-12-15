# =============================================================================
# Legend Styling Functions
# =============================================================================

# =============================================================================
# Custom ggplot class for auto-centering legend titles
# =============================================================================

#' Add legend_style_centered to ggplot
#' @param object A legend_style_centered object
#' @param plot A ggplot object
#' @param ... Additional arguments (ignored)
#' @importFrom ggplot2 ggplot_add
#' @keywords internal
#' @export
ggplot_add.legend_style_centered <- function(object, plot, ...) {
  # Apply the theme to the plot
  plot <- plot + object$theme

  # Mark this plot for title centering at render time
  # For 90° rotation, also mark for auto-fit
  if (!is.null(object$angle) && abs(object$angle) == 90) {
    class(plot) <- c("gg_autofit_legend", class(plot))
  } else {
    class(plot) <- c("gg_centered_title", class(plot))
  }
  plot
}

#' Print method for centered title plots
#' @param x A gg_centered_title object
#' @param ... Additional arguments (ignored)
#' @keywords internal
#' @export
print.gg_centered_title <- function(x, ...) {
  # Apply title centering and render
  g <- center_legend_title(x)
  grid::grid.newpage()
  grid::grid.draw(g)
  invisible(x)
}

#' Plot method for centered title plots
#' @param x A gg_centered_title object
#' @param ... Additional arguments (ignored)
#' @keywords internal
#' @export
plot.gg_centered_title <- function(x, ...) {
  print.gg_centered_title(x, ...)
}

#' Convert centered title plot to gtable
#' @param x A gg_centered_title object
#' @method ggplotGrob gg_centered_title
#' @keywords internal
#' @export
ggplotGrob.gg_centered_title <- function(x) {
  # Remove our class temporarily to avoid recursion
  class(x) <- setdiff(class(x), "gg_centered_title")
  center_legend_title(x)
}

#' Print method for auto-fit legend plots (90° rotation)
#' @param x A gg_autofit_legend object
#' @param ... Additional arguments (ignored)
#' @method print gg_autofit_legend
#' @keywords internal
#' @export
print.gg_autofit_legend <- function(x, ...) {
  # Remove our class to avoid recursion
  class(x) <- setdiff(class(x), "gg_autofit_legend")
  # Apply auto-fit then center title
  x <- legend_auto_fit(x)
  g <- center_legend_title(x)
  grid::grid.newpage()
  grid::grid.draw(g)
  invisible(x)
}

#' Plot method for auto-fit legend plots
#' @param x A gg_autofit_legend object
#' @param ... Additional arguments (ignored)
#' @method plot gg_autofit_legend
#' @keywords internal
#' @export
plot.gg_autofit_legend <- function(x, ...) {
  print.gg_autofit_legend(x, ...)
}

#' Convert auto-fit legend plot to gtable
#' @param x A gg_autofit_legend object
#' @method ggplotGrob gg_autofit_legend
#' @keywords internal
#' @export
ggplotGrob.gg_autofit_legend <- function(x) {
  # Remove our class to avoid recursion
  class(x) <- setdiff(class(x), "gg_autofit_legend")
  # Apply auto-fit then center title
  x <- legend_auto_fit(x)
  center_legend_title(x)
}

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
      text_args$hjust <- 0.5
      text_args$vjust <- 0.5
    } else if (angle == -90) {
      text_args$hjust <- 0.5
      text_args$vjust <- 0.5
    }
  }

  if (length(text_args) > 0) {
    args$legend.text <- do.call(element_text, text_args)
  }

  # --- Title styling ---
  title_args <- list()
  if (!is.null(size)) title_args$size <- size
  if (!is.null(family)) title_args$family <- family
  if (!is.null(face)) title_args$face <- face
  if (!is.null(color)) title_args$colour <- color
  # For rotated labels: set hjust = 0.5 to prepare for center_legend_title()
  if (!is.null(angle)) {
    title_args$hjust <- 0.5
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
  # For 90° rotation, auto-set key_height so labels don't overlap vertically
  # Auto-fit will handle wrapping at render time
  if (!is.null(angle) && abs(angle) == 90 && is.null(key_height)) {
    text_size <- if (!is.null(size)) size else 11
    # Conservative estimate: enough for ~8 chars at given text size
    key_height <- text_size * 0.025 * 8
  }
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

  theme_obj <- do.call(theme, args)

  # When angle is set, return a custom object that will apply title centering
  # and auto-fit for 90° rotation
  if (!is.null(angle)) {
    result <- structure(
      list(theme = theme_obj, angle = angle),
      class = "legend_style_centered"
    )
    return(result)
  }

  theme_obj
}

#' Auto-fit Legend to Plot Height
#'
#' Measures the legend height relative to the plot panel and automatically
#' wraps the legend into multiple columns if it would overflow. This function
#' must be called on a complete ggplot object, not added with \code{+}.
#'
#' @param plot A ggplot object.
#' @param max_ratio Maximum ratio of legend height to panel height before
#'   wrapping is triggered. Default is 0.95 (95 percent of panel height).
#'
#' @return A modified ggplot object with adjusted legend layout.
#'
#' @details
#' This function builds the plot to measure actual dimensions, then rebuilds
#' with an appropriate number of legend rows if the legend is too tall.
#' It's particularly useful after applying \code{legend_style(angle = 90)}
#' which can cause legends to exceed the plot height.
#'
#' Because this requires building the plot twice, it has a small performance
#' cost. For static plots this is negligible.
#'
#' @examples
#' library(ggplot2)
#'
#' # Legend with rotated text that might overflow
#' p <- ggplot(mpg, aes(displ, hwy, color = class)) +
#'   geom_point() +
#'   legend_style(angle = 90)
#'
#' # Auto-fit will wrap if needed
#' legend_auto_fit(p)
#'
#' @seealso \code{\link{legend_style}}, \code{\link{legend_wrap}}
#' @export
legend_auto_fit <- function(plot, max_ratio = 0.95) {
  if (!inherits(plot, "ggplot")) {
    stop("plot must be a ggplot object.", call. = FALSE)
  }

  # Build to gtable to measure dimensions
  gt <- ggplot2::ggplotGrob(plot)

  # Find legend and panel
  guide_idx <- which(grepl("^guide-box", gt$layout$name))
  panel_idx <- which(gt$layout$name == "panel")

  if (length(guide_idx) == 0 || length(panel_idx) == 0) {
    return(plot)  # No legend or panel to measure
  }

  # Calculate panel height: device height minus fixed elements
  # Use a reference device size (typical plot)
  device_height_cm <- 12.7  # ~5 inches, typical plot height

  # Sum all non-null heights (fixed elements like titles, axes, margins)
  fixed_height <- 0
  for (i in seq_along(gt$heights)) {
    h <- gt$heights[[i]]
    h_cm <- tryCatch(
      grid::convertHeight(h, "cm", valueOnly = TRUE),
      error = function(e) 0
    )
    # null units return 0, which is what we want to exclude
    if (h_cm > 0) fixed_height <- fixed_height + h_cm
  }
  panel_height <- device_height_cm - fixed_height

  # Get legend height (legend grob heights are absolute)
  legend_grob <- gt$grobs[[guide_idx[1]]]
  legend_height <- 0
  for (i in seq_along(legend_grob$heights)) {
    h <- legend_grob$heights[[i]]
    h_cm <- tryCatch(
      grid::convertHeight(h, "cm", valueOnly = TRUE),
      error = function(e) 0
    )
    legend_height <- legend_height + h_cm
  }

  # Check if legend fits
  if (legend_height <= panel_height * max_ratio) {
    return(plot)  # Fits fine, no wrapping needed
  }

  # Calculate how many rows we can fit
  # Get number of legend items from the built plot
  built <- ggplot2::ggplot_build(plot)
  n_items <- 0

  # Try to get items from colour scale
  colour_scale <- built$plot$scales$get_scales("colour")
  if (!is.null(colour_scale) && !is.null(colour_scale$get_limits)) {
    limits <- colour_scale$get_limits()
    if (!is.null(limits)) n_items <- length(limits)
  }

  # Fallback to fill scale
 if (n_items == 0) {
    fill_scale <- built$plot$scales$get_scales("fill")
    if (!is.null(fill_scale) && !is.null(fill_scale$get_limits)) {
      limits <- fill_scale$get_limits()
      if (!is.null(limits)) n_items <- length(limits)
    }
  }

  if (n_items == 0) {
    return(plot)  # Can't determine legend items
  }

  item_height <- legend_height / n_items
  max_rows <- floor((panel_height * max_ratio) / item_height)
  max_rows <- max(1, max_rows)  # At least 1 row

  if (max_rows >= n_items) {
    return(plot)  # All items fit in calculated rows
  }

  # Wrap legend
  message(sprintf(
    "legend_auto_fit: Legend (%.1fcm) exceeds %.0f%% of panel (%.1fcm). Wrapping to %d rows.",
    legend_height, max_ratio * 100, panel_height, max_rows
  ))

  guide_spec <- guide_legend(nrow = max_rows)
  plot + guides(
    colour = guide_spec,
    fill = guide_spec,
    shape = guide_spec,
    size = guide_spec,
    linetype = guide_spec,
    alpha = guide_spec
  )
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
      text_args$hjust <- 0.5
      text_args$vjust <- 0.5
    } else if (angle == -90) {
      text_args$hjust <- 0.5
      text_args$vjust <- 0.5
    }
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
  # For rotated labels: set hjust = 0.5 to prepare for center_legend_title()
  if (!is.null(angle)) {
    title_args$hjust <- 0.5
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
  # For 90° rotation, auto-set key_height so labels don't overlap vertically
  if (!is.null(angle) && abs(angle) == 90 && is.null(key_height)) {
    text_size <- if (!is.null(size)) size else 11
    key_height <- text_size * 0.025 * 8
  }
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

#' Center Legend Title Over Keys
#'
#' Modifies a ggplot so that legend titles are centered over the key column
#' only, rather than over the full legend width (keys + labels). This is
#' particularly useful when legend labels are rotated, as the default centering
#' places the title too far to the right.
#'
#' @param plot A ggplot object.
#' @param position Legend position to modify. One of \code{"right"}, \code{"left"},
#'   \code{"top"}, \code{"bottom"}, or \code{"all"} (default).
#'
#' @return A modified gtable object that can be drawn with \code{grid::grid.draw()}
#'   or saved with \code{ggplot2::ggsave()}.
#'
#' @details
#' This function works by modifying the legend's internal gtable structure,
#' restricting the title's column span to only the keys column. Long titles
#' will automatically wrap to fit within the key column width, and proper
#' spacing is added to prevent overlap with rotated labels.
#'
#' The title should have \code{hjust = 0.5} set (done automatically by
#' \code{legend_style(angle = ...)}) for proper centering.
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mpg, aes(displ, hwy, color = class)) +
#'   geom_point() +
#'   legend_style(angle = 45) +
#'   labs(color = "Vehicle Class")
#'
#' # Center title over keys only (long titles wrap automatically)
#' # Returns a gtable - use grid::grid.draw() to render
#' \dontrun{
#' g <- center_legend_title(p)
#' grid::grid.draw(g)
#' }
#'
#' @seealso \code{\link{legend_style}}
#' @export
center_legend_title <- function(plot, position = "all") {
  if (!inherits(plot, "gg")) {
    stop("plot must be a ggplot object.", call. = FALSE)
  }

  # Convert to gtable
  g <- ggplot2::ggplotGrob(plot)

  # Determine which guide boxes to modify
  positions <- if (position == "all") {
    c("right", "left", "top", "bottom")
  } else {
    position
  }

  for (pos in positions) {
    box_name <- paste0("guide-box-", pos)
    legend_idx <- which(g$layout$name == box_name)

    if (length(legend_idx) == 0) next

    legend <- g$grobs[[legend_idx]]
    if (!inherits(legend, "gtable")) next

    # Find the guides grob within the legend box
    guides_idx <- which(legend$layout$name == "guides")
    if (length(guides_idx) == 0) next

    guides_grob <- legend$grobs[[guides_idx]]
    if (!inherits(guides_grob, "gtable")) next

    # Find the title
    title_idx <- which(guides_grob$layout$name == "title")
    if (length(title_idx) == 0) next

    # Get key column width and label start position
    key_col <- guides_grob$layout[title_idx, "l"]
    key_width <- guides_grob$widths[[key_col]]
    key_width_cm <- grid::convertWidth(key_width, "cm", valueOnly = TRUE)

    # Get the title grob and check if wrapping is needed
    title_grob <- guides_grob$grobs[[title_idx]]

    # Only wrap if title would overlap with rotated labels
    if (inherits(title_grob, "titleGrob")) {
      title_children <- title_grob$children
      text_grob_idx <- which(sapply(title_children, inherits, "text"))

      if (length(text_grob_idx) > 0) {
        text_grob <- title_children[[text_grob_idx[1]]]
        title_text <- text_grob$label

        # Get text properties
        gp <- text_grob$gp
        fontsize <- if (!is.null(gp$fontsize)) gp$fontsize else 11

        # Estimate title width
        char_width_cm <- fontsize * 0.035 * 0.6
        title_width_cm <- nchar(title_text) * char_width_cm

        # Find the first label to check for overlap
        # Labels at 45° start at the key edge and extend diagonally
        # The "safe zone" is approximately key_width + small buffer
        # Only wrap if title extends significantly beyond the key column
        safe_zone_cm <- key_width_cm + 0.3  # key width + small margin

        if (title_width_cm > safe_zone_cm) {
          # Wrap to fit within the safe zone
          max_chars <- floor(safe_zone_cm / char_width_cm)
          wrapped <- strwrap(title_text, width = max(max_chars, 1))
          new_label <- paste(wrapped, collapse = "\n")
          text_grob$label <- new_label

          # Update the grob
          title_grob$children[[text_grob_idx[1]]] <- text_grob
          guides_grob$grobs[[title_idx]] <- title_grob

          # Add extra row height for wrapped title
          title_row <- guides_grob$layout[title_idx, "t"]
          n_lines <- length(wrapped)
          if (n_lines > 1) {
            line_height_cm <- fontsize * 0.035 * 1.2
            new_height <- grid::unit(line_height_cm * n_lines, "cm")
            guides_grob$heights[[title_row]] <- new_height
          }
        }
      }
    }

    # Restrict title to only span the keys column
    guides_grob$layout[title_idx, "r"] <- guides_grob$layout[title_idx, "l"]

    # Put modified grobs back
    legend$grobs[[guides_idx]] <- guides_grob
    g$grobs[[legend_idx]] <- legend
  }

  g
}
