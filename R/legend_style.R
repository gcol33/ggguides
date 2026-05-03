# =============================================================================
# Legend Styling Functions
# =============================================================================

# Map a scalar justification onto the ggplot2 >= 3.5 side-specific theme
# elements. Character "left"/"right" only apply to horizontal rails
# (top/bottom); "top"/"bottom" only apply to vertical rails (left/right);
# "center", numerics, and length-2 values apply to all four sides.
# Writing to the generic `legend.justification` is avoided because
# ggplot2 coerces it per axis and inside guide_legend(theme = ...) it is
# not consulted at all.
#' @noRd
justification_elements <- function(j) {
  if (is.character(j) && length(j) == 1) {
    if (j %in% c("left", "right")) {
      list(legend.justification.top = j, legend.justification.bottom = j)
    } else if (j %in% c("top", "bottom")) {
      list(legend.justification.left = j, legend.justification.right = j)
    } else if (j == "center") {
      list(
        legend.justification.top = j, legend.justification.bottom = j,
        legend.justification.left = j, legend.justification.right = j
      )
    } else {
      stop(
        "justification must be one of \"left\", \"right\", \"top\", ",
        "\"bottom\", \"center\", or numeric in [0, 1].",
        call. = FALSE
      )
    }
  } else {
    list(
      legend.justification.top = j, legend.justification.bottom = j,
      legend.justification.left = j, legend.justification.right = j
    )
  }
}

# =============================================================================
# Custom ggplot class for auto-centering legend titles
# =============================================================================

#' Add legend_style_centered to ggplot
#' @param object A legend_style_centered object
#' @param plot A ggplot object
#' @param ... Additional arguments (ignored)
#' @return A modified ggplot object with additional class \code{gg_centered_title}
#'   or \code{gg_autofit_legend} (for 90-degree rotation), used to trigger
#'   custom rendering behavior.
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
#' @return Invisibly returns the input object. Called for the side effect of
#'   rendering the plot with centered legend titles.
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
#' @return Invisibly returns the input object. Called for the side effect of
#'   rendering the plot with centered legend titles.
#' @keywords internal
#' @export
plot.gg_centered_title <- function(x, ...) {
  print.gg_centered_title(x, ...)
}

#' Convert centered title plot to gtable
#' @param x A gg_centered_title object
#' @return A gtable object (grob table) with centered legend titles, suitable for
#'   rendering with \code{grid::grid.draw()} or saving with \code{ggplot2::ggsave()}.
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
#' @return Invisibly returns the input object. Called for the side effect of
#'   rendering the plot with auto-fitted and centered legend.
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
#' @return Invisibly returns the input object. Called for the side effect of
#'   rendering the plot with auto-fitted and centered legend.
#' @method plot gg_autofit_legend
#' @keywords internal
#' @export
plot.gg_autofit_legend <- function(x, ...) {
  print.gg_autofit_legend(x, ...)
}

#' Convert auto-fit legend plot to gtable
#' @param x A gg_autofit_legend object
#' @return A gtable object (grob table) with auto-fitted and centered legend,
#'   suitable for rendering with \code{grid::grid.draw()} or saving with
#'   \code{ggplot2::ggsave()}.
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
#' @param justification Justification of the legend along its side. For legends
#'   on the top or bottom: \code{"left"}, \code{"center"}, \code{"right"}, or a
#'   numeric value in \code{[0, 1]}. For legends on the left or right:
#'   \code{"top"}, \code{"center"}, \code{"bottom"}, or a numeric value in
#'   \code{[0, 1]}. When \code{by} is specified, applies a whole-plot
#'   \code{theme(legend.justification.<side> = ...)} keyed on the guide's
#'   resolved side (so any later \code{legend_<side>(by = ...)} call takes
#'   effect). When \code{by} is NULL, sets \code{legend.justification.<side>}
#'   for every axis on which the scalar is valid. Requires ggplot2 >= 3.5.0.
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
#' # Per-legend justification: slide each legend along its side
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point() +
#'   legend_top(by = "colour") +
#'   legend_right(by = "size") +
#'   legend_style(by = "colour", justification = "left") +
#'   legend_style(by = "size",   justification = "top")
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
    justification = NULL,
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
      background_color = background_color, direction = direction, byrow = byrow,
      justification = justification
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

  # --- Justification ---
  # ggplot2 >= 3.5 reads one of the side-specific elements
  # (legend.justification.{top,bottom,left,right}) depending on where the
  # legend sits. The generic legend.justification falls back per axis and
  # coerces incorrectly for mixed-axis values (e.g., "left" on a vertical
  # rail -> 0 -> "bottom"). Dispatch to the valid axes.
  if (!is.null(justification)) {
    args <- c(args, justification_elements(justification))
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
    direction = NULL, byrow = NULL, justification = NULL
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

  # Build embedded theme (justification is applied separately at
  # ggplot_add time — ggplot2's guide_legend(theme = ...) does not consult
  # legend.justification.{side} for the guide it wraps, so we must route
  # it to a whole-plot theme keyed on the guide's resolved position).
  embedded_theme <- if (length(theme_args) > 0) {
    do.call(theme, theme_args)
  } else {
    NULL
  }

  ggguides_guide_update(
    by = by,
    guide_params = list(),
    theme_delta = embedded_theme,
    justification = justification
  )
}

#' Build a ggguides per-aesthetic guide update object
#' @noRd
ggguides_guide_update <- function(by, guide_params = list(), theme_delta = NULL,
                                  justification = NULL) {
  structure(
    list(
      by = by,
      guide_params = guide_params,
      theme_delta = theme_delta,
      justification = justification
    ),
    class = c("ggguides_guide_update", "gg")
  )
}

#' @export
ggplot_add.ggguides_guide_update <- function(object, plot, ...) {
  by <- object$by

  existing <- tryCatch(plot$guides$guides[[by]], error = function(e) NULL)

  if (is.null(existing) || !inherits(existing, "Guide")) {
    new_params <- object$guide_params
    if (!is.null(object$theme_delta)) new_params$theme <- object$theme_delta
    new_guide <- do.call(ggplot2::guide_legend, new_params)
    guides_arg <- stats::setNames(list(new_guide), by)
    plot <- plot + do.call(ggplot2::guides, guides_arg)
    pos <- new_params$position
  } else {
    for (nm in names(object$guide_params)) {
      existing$params[[nm]] <- object$guide_params[[nm]]
    }
    if (!is.null(object$theme_delta)) {
      existing_theme <- existing$params$theme
      if (inherits(existing_theme, "theme")) {
        existing$params$theme <- existing_theme + object$theme_delta
      } else {
        existing$params$theme <- object$theme_delta
      }
    }
    pos <- existing$params$position
  }

  if (is.null(object$justification)) return(plot)

  # Per-guide justification needs two paths:
  #
  #  1. Theme write — sets legend.justification.<side> globally so single-
  #     legend-per-side cases work via ggplot2's native layout. This is the
  #     v1.1.9 behavior; kept as a fallback. Two legends on the same side
  #     overwrite each other here, which is why path 2 exists.
  #
  #  2. Plot-attribute stash + render-time gtable rewrite. The per-legend
  #     justifications are recorded on the plot, and ggplotGrob.gg_per_legend_just
  #     edits the guide-box-<side> internal gtable so each legend sits at
  #     its requested rail position even when it shares a side.
  plot <- apply_guide_justification_theme(plot, object$justification, pos)
  plot <- store_per_legend_justification(plot, by, object$justification)
  plot
}

# Set the side-specific theme element so single-legend cases keep working
# without any gtable surgery. For unresolved sides, write all four slots so
# whichever side the legend ends up on will pick up the value.
#' @noRd
apply_guide_justification_theme <- function(plot, j, position) {
  if (is.character(position) && length(position) == 1 &&
      position %in% c("top", "bottom", "left", "right")) {
    key <- paste0("legend.justification.", position)
    plot + do.call(ggplot2::theme, stats::setNames(list(j), key))
  } else {
    plot + do.call(ggplot2::theme, justification_elements(j))
  }
}

# Stash a {aesthetic -> justification} entry on the plot as an attribute,
# and tag the plot so the render-time post-processor runs.
#' @noRd
store_per_legend_justification <- function(plot, by, j) {
  j_map <- attr(plot, "ggguides_justifications")
  if (is.null(j_map)) j_map <- list()
  j_map[[by]] <- j
  attr(plot, "ggguides_justifications") <- j_map
  if (!inherits(plot, "gg_per_legend_just")) {
    class(plot) <- c("gg_per_legend_just", class(plot))
  }
  plot
}

# =============================================================================
# Render-time gtable post-processing for per-legend justification
# =============================================================================
#
# ggplot2's legend.justification.<side> is a single global theme element, so
# two legends on the same edge can only share one justification — the last
# write wins. To let users pin (e.g.) colour to the left of the top edge and
# fill to the right of the same edge, we tag the plot at add-time and rewrite
# the guide-box-<side> internal gtable here. Each guide-box is laid out as
#
#   [pad-null, 0pt, leg_1, gap, leg_2, gap, ..., leg_N, 0pt, pad-null]
#
# (cols for top/bottom, rows for left/right). Reshaping the pad/gap null
# units controls each legend's fractional position along the rail.

#' @export
ggplotGrob.gg_per_legend_just <- function(x) {
  # Make sure the gtable ordering matches the requested justification ordering
  # before ggplot2 builds — ggplot2's intrinsic guide order may not match what
  # the user wrote (e.g. they want colour on the left of the top edge but
  # ggplot2 places fill first), and the post-processor below only redistributes
  # slack, it does not swap legend cells.
  prepared <- assign_per_legend_order(x)
  class(prepared) <- setdiff(class(prepared), "gg_per_legend_just")
  g <- ggplot2::ggplotGrob(prepared)
  apply_per_legend_just_to_gtable(g, x)
}

# Set guide_legend(order = N) on each per-legend-justification guide so the
# gtable column/row order matches the user's requested justification order
# along the rail. Guides without an explicit per-legend justification are
# left alone (or get pushed after the explicitly-justified ones).
#' @noRd
assign_per_legend_order <- function(plot) {
  j_map <- attr(plot, "ggguides_justifications")
  if (length(j_map) == 0) return(plot)

  side_targets <- list()
  user_orders <- list()
  for (aes in names(j_map)) {
    guide <- tryCatch(plot$guides$guides[[aes]], error = function(e) NULL)
    pos <- if (!is.null(guide)) guide$params$position else NULL
    if (!is.character(pos) || length(pos) != 1 ||
        !pos %in% c("top", "bottom", "left", "right")) next
    user_order <- guide$params$order
    if (!is.null(user_order) && is.numeric(user_order) && user_order != 0) {
      # User explicitly set order via legend_order() or guides() — respect
      # it and skip rail-position-based reordering for this side. The
      # post-processor's slack distribution still runs.
      user_orders[[pos]] <- TRUE
      next
    }
    if (is.null(side_targets[[pos]])) side_targets[[pos]] <- list()
    side_targets[[pos]][[aes]] <- to_rail_position(
      j_map[[aes]], horizontal = pos %in% c("top", "bottom")
    )
  }

  for (side in names(side_targets)) {
    if (isTRUE(user_orders[[side]])) {
      warning(
        "ggguides: per-legend justification on side '", side, "' was ",
        "skipped because guide_legend(order = ...) is already set on a ",
        "guide on that side. Remove the explicit order or move the ",
        "justification to match.",
        call. = FALSE
      )
      next
    }
    aes_targets <- unlist(side_targets[[side]])
    sorted_aes <- names(aes_targets)[order(aes_targets)]
    for (i in seq_along(sorted_aes)) {
      plot$guides$guides[[sorted_aes[i]]]$params$order <- i
    }
  }
  plot
}

#' @export
print.gg_per_legend_just <- function(x, ...) {
  g <- ggplotGrob.gg_per_legend_just(x)
  grid::grid.newpage()
  grid::grid.draw(g)
  invisible(x)
}

#' @export
plot.gg_per_legend_just <- function(x, ...) {
  print.gg_per_legend_just(x, ...)
}

#' @noRd
apply_per_legend_just_to_gtable <- function(g, plot) {
  j_map <- attr(plot, "ggguides_justifications")
  if (length(j_map) == 0) return(g)

  side_groups <- list(top = list(), bottom = list(),
                      left = list(), right = list())
  for (aes in names(j_map)) {
    guide <- tryCatch(plot$guides$guides[[aes]], error = function(e) NULL)
    pos <- if (!is.null(guide)) guide$params$position else NULL
    if (is.character(pos) && length(pos) == 1 && pos %in% names(side_groups)) {
      side_groups[[pos]][[aes]] <- j_map[[aes]]
    }
  }

  for (side in names(side_groups)) {
    if (length(side_groups[[side]]) == 0) next
    g <- reposition_guide_box(g, side, side_groups[[side]], plot)
  }
  g
}

# Layout the guide-box-<side> internal gtable conforms to. ggplot2 has used
# this 2N+3 strip pattern since 3.5 — see ggplot2 R/guides-.R::Guides$assemble().
# A mismatch means ggplot2 changed its internal structure; we abort the
# reposition and warn (once per session) so the caller knows the global theme
# fallback is being used instead.
GUIDE_BOX_LAYOUT_VERSION_TESTED <- "4.0.3"

#' @noRd
warn_layout_mismatch <- function(side, observed, expected, what) {
  key <- "ggguides.layout_mismatch_warned"
  if (isTRUE(getOption(key))) return(invisible())
  options(stats::setNames(list(TRUE), key))
  warning(
    "ggguides per-legend justification: guide-box-", side, " ", what,
    " is ", observed, " (expected ", expected, ") under ggplot2 ",
    utils::packageVersion("ggplot2"),
    ". The internal layout is not what ggguides ",
    utils::packageVersion("ggguides"),
    " was built for (last verified against ggplot2 ",
    GUIDE_BOX_LAYOUT_VERSION_TESTED, "). ",
    "Falling back to single-side global justification — multiple legends ",
    "on the same edge may collide. Please file an issue at ",
    "https://github.com/gcol33/ggguides/issues with your ggplot2 version.",
    call. = FALSE
  )
}

#' @noRd
reposition_guide_box <- function(g, side, legends, plot) {
  box_name <- paste0("guide-box-", side)
  box_idx <- which(g$layout$name == box_name)
  if (length(box_idx) == 0) return(g)

  inner <- g$grobs[[box_idx]]
  if (!inherits(inner, "gtable")) return(g)

  guide_cells <- which(inner$layout$name == "guides")
  if (length(guide_cells) == 0) return(g)

  horizontal <- side %in% c("top", "bottom")
  n_legends <- length(guide_cells)

  # Only every-legend-justified groups are safe to reposition: with mixed
  # specs we cannot tell which gtable cell corresponds to which aesthetic.
  if (n_legends != length(legends)) return(g)

  expected <- 2 * n_legends + 3
  axis_units <- if (horizontal) inner$widths else inner$heights
  if (length(axis_units) != expected) {
    warn_layout_mismatch(side, length(axis_units), expected,
                         if (horizontal) "width count" else "height count")
    return(g)
  }

  # The outer pad cells (indices 1 and `expected`) are how ggplot2 honors
  # legend.justification.<side> — they are always null units. If they aren't,
  # ggplot2 has reshaped guide-box internals and we should not edit blindly.
  # Gap cells (indices 4, 6, ...) are normally fixed cm (legend.spacing.x);
  # we deliberately overwrite them with null to redistribute slack.
  for (idx in c(1, expected)) {
    u <- axis_units[[idx]]
    if (!inherits(u, "unit") ||
        !identical(grid::unitType(u)[1], "null")) {
      warn_layout_mismatch(side, "non-null pad cell", "null",
                           paste("pad at index", idx))
      return(g)
    }
  }

  # The gtable cells appear in the order set by assign_per_legend_order(),
  # which is ascending target rail position.
  raw_targets <- vapply(names(legends), function(a) {
    to_rail_position(legends[[a]], horizontal = horizontal)
  }, numeric(1))
  sorted_targets <- sort(raw_targets)

  start_pad <- sorted_targets[1]
  end_pad <- 1 - sorted_targets[n_legends]
  gaps <- if (n_legends >= 2) diff(sorted_targets) else numeric(0)

  if (start_pad + sum(gaps) + end_pad <= 0) {
    # All targets at 0 (everything at start edge): keep slack at the end so
    # the layout doesn't degenerate to all-zero null cols.
    end_pad <- 1
  }

  axis_units[[1]] <- grid::unit(start_pad, "null")
  axis_units[[expected]] <- grid::unit(end_pad, "null")
  for (i in seq_along(gaps)) {
    axis_units[[2 * i + 2]] <- grid::unit(gaps[i], "null")
  }

  if (horizontal) inner$widths <- axis_units else inner$heights <- axis_units

  # ggplot2 wraps the guide-box in a viewport whose width (or height for
  # vertical rails) is fixed to the natural total of the legends, which
  # collapses any null slack we just inserted. Stretch the viewport to the
  # full panel and re-anchor it so the null cols can spread the legends.
  inner$vp <- stretch_guide_box_vp(inner$vp, horizontal)

  g$grobs[[box_idx]] <- inner
  g
}

# Tolerantly stretch the guide-box viewport along its rail axis. Returns a
# viewport unchanged if it doesn't expose the fields we expect, rather than
# throwing — the visible symptom of a no-op is "legends end up at default
# position" which is recoverable; throwing would break rendering entirely.
#' @noRd
stretch_guide_box_vp <- function(vp, horizontal) {
  if (is.null(vp)) return(vp)
  if (horizontal) {
    if (!is.null(vp$width))         vp$width <- grid::unit(1, "npc")
    if (!is.null(vp$x))             vp$x <- grid::unit(0.5, "npc")
    if (is.numeric(vp$valid.just) && length(vp$valid.just) >= 1)
      vp$valid.just[1] <- 0.5
    if (is.numeric(vp$justification) && length(vp$justification) >= 1)
      vp$justification[1] <- 0.5
  } else {
    if (!is.null(vp$height))        vp$height <- grid::unit(1, "npc")
    if (!is.null(vp$y))             vp$y <- grid::unit(0.5, "npc")
    if (is.numeric(vp$valid.just) && length(vp$valid.just) >= 2)
      vp$valid.just[2] <- 0.5
    if (is.numeric(vp$justification) && length(vp$justification) >= 2)
      vp$justification[2] <- 0.5
  }
  vp
}

# Convert a justification spec to a fractional position along the rail.
# Horizontal rail: 0 = left, 1 = right. Vertical rail: 0 = top, 1 = bottom
# (gtable rows grow downward, so this matches the row indexing).
#' @noRd
to_rail_position <- function(j, horizontal) {
  if (is.numeric(j) && length(j) == 1) {
    j <- max(0, min(1, j))
    # ggplot2 numeric justification: 0 = bottom for vertical rails. Invert
    # so vertical positions match top-to-bottom row order.
    if (!horizontal) j <- 1 - j
    return(j)
  }
  if (is.character(j) && length(j) == 1) {
    if (horizontal) {
      switch(j,
        "left" = 0, "right" = 1, "center" = 0.5,
        stop("invalid horizontal justification: ", j, call. = FALSE))
    } else {
      switch(j,
        "top" = 0, "bottom" = 1, "center" = 0.5,
        stop("invalid vertical justification: ", j, call. = FALSE))
    }
  } else {
    stop("justification must be a single character or numeric value",
         call. = FALSE)
  }
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
#' g <- center_legend_title(p)
#' grid::grid.draw(g)
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
