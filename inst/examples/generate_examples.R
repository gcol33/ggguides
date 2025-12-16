# =============================================================================
# Generate Example Images for ggguides Documentation
# Run this script from the package root directory
# =============================================================================

library(ggplot2)
library(ggguides)
library(svglite)

# Theme colors matching pkgdown Sandstone theme (Bootstrap 5)
LIGHT_BG <- "#F5F6F8"
LIGHT_BORDER <- "#DFD7CA"
LIGHT_TEXT <- "#3E3F3A"
DARK_BG <- "#343739"
DARK_TEXT <- "#DFD7CA"
FONT_FAMILY <- '"Roboto", -apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif'

# Output directory
out_dir <- "man/figures"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

# Set transparent theme for ggplot2
theme_set(
  theme_grey() +
    theme(
      plot.background = element_rect(fill = "transparent", color = NA),
      panel.background = element_rect(fill = "transparent", color = NA),
      legend.background = element_rect(fill = "transparent", color = NA),
      legend.key = element_rect(fill = "transparent", color = NA),
      legend.box.background = element_rect(fill = "transparent", color = NA)
    )
)

# Base plot for examples
base_plot <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(color = "Cylinders", title = "Example Plot")

#' Make an SVG file theme-aware (simplified version of build_pkgdown.R)
#'
#' @param svg_path Path to SVG file
make_svg_theme_aware <- function(svg_path) {
  svg_content <- paste(readLines(svg_path, warn = FALSE), collapse = "\n")

  # Add svg-bg class to main background rect and set light bg color
  svg_content <- sub(
    "<rect width='100%' height='100%' style='stroke: none; fill: none;'/>",
    sprintf("<rect class='svg-bg' width='100%%' height='100%%' style='stroke: none; fill: %s;'/>", LIGHT_BG),
    svg_content, fixed = TRUE
  )

  # Replace gridline colors
  svg_content <- gsub("stroke: #EBEBEB;", sprintf("stroke: %s;", LIGHT_TEXT), svg_content, fixed = TRUE)

  # Modify CSS rules - remove rect from combined rule, add separate rect rule

  line_rule_pat <- paste0(
    "    .svglite line, .svglite polyline, .svglite polygon, ",
    ".svglite path, .svglite rect, .svglite circle {\n",
    "      fill: none;\n",
    "      stroke: #000000;\n",
    "      stroke-linecap: round;\n",
    "      stroke-linejoin: round;\n",
    "      stroke-miterlimit: 10.00;\n",
    "    }"
  )
  new_line_rule <- sprintf(
    paste0(
      "    /* theme-aware-processed */\n",
      "    .svglite line, .svglite polyline, .svglite polygon, ",
      ".svglite path, .svglite circle {\n",
      "      fill: none;\n",
      "      stroke: %s;\n",
      "      stroke-linecap: round;\n",
      "      stroke-linejoin: round;\n",
      "      stroke-miterlimit: 10.00;\n",
      "    }\n",
      "    .svglite > g > rect {\n",
      "      fill: none;\n",
      "      stroke: %s;\n",
      "      stroke-linecap: round;\n",
      "      stroke-linejoin: round;\n",
      "      stroke-miterlimit: 10.00;\n",
      "    }"
    ),
    LIGHT_TEXT, LIGHT_TEXT
  )
  svg_content <- sub(line_rule_pat, new_line_rule, svg_content, fixed = TRUE)

  # Update text rule with fill color
  text_rule_pat <- paste0(
    "    .svglite text {\n",
    "      white-space: pre;\n",
    "    }"
  )
  new_text_rule <- sprintf(
    paste0(
      "    .svglite text {\n",
      "      white-space: pre;\n",
      "      fill: %s;\n",
      "    }"
    ),
    LIGHT_TEXT
  )
  svg_content <- sub(text_rule_pat, new_text_rule, svg_content, fixed = TRUE)

  # Update font family
  svg_content <- gsub(
    'font-family: "Arial";',
    sprintf("font-family: %s;", FONT_FAMILY),
    svg_content, fixed = TRUE
  )

  writeLines(svg_content, svg_path)
}

# Helper to save plots with theme-aware SVG processing
save_example <- function(p, name, width = 6, height = 4) {
  filepath <- file.path(out_dir, paste0(name, ".svg"))
  ggsave(
    filename = filepath,
    plot = p,
    width = width,
    height = height,
    device = svglite,
    bg = "transparent"
  )
  make_svg_theme_aware(filepath)
  message("Saved: ", name, ".svg")
}

# =============================================================================
# Position Examples
# =============================================================================

# legend_left
save_example(
  base_plot + legend_left(),
  "legend_left"
)

# legend_right
save_example(
  base_plot + legend_right(),
  "legend_right"
)

# legend_top
save_example(
  base_plot + legend_top(),
  "legend_top"
)

# legend_bottom
save_example(
  base_plot + legend_bottom(),
  "legend_bottom"
)

# legend_none
save_example(
  base_plot + legend_none(),
  "legend_none"
)

# legend_inside - topright
save_example(
  base_plot + legend_inside(position = "topright"),
  "legend_inside_topright"
)

# legend_inside - bottomleft
save_example(
  base_plot + legend_inside(position = "bottomleft"),
  "legend_inside_bottomleft"
)

# legend_inside - center with styling
save_example(
  base_plot + legend_inside(position = "center", background = "grey95", border = "grey50"),
  "legend_inside_styled"
)

# =============================================================================
# Direction Examples
# =============================================================================

# legend_horizontal
save_example(
  base_plot + legend_bottom() + legend_horizontal(),
  "legend_horizontal"
)

# legend_vertical (default, but explicit)
save_example(
  base_plot + legend_right() + legend_vertical(),
  "legend_vertical"
)

# =============================================================================
# Style Examples
# =============================================================================

# legend_style - size only
save_example(
  base_plot + legend_style(size = 14),
  "legend_style_size"
)

# legend_style - font family
save_example(
  base_plot + legend_style(family = "serif"),
  "legend_style_font"
)

# legend_style - basic (size + family)
save_example(
  base_plot + legend_style(size = 14, family = "serif"),
  "legend_style_basic"
)

# legend_style - comprehensive
save_example(
  base_plot + legend_style(
    size = 12,
    title_size = 14,
    title_face = "bold",
    key_width = 1.5,
    background = "grey95",
    background_color = "grey70",
    margin = 0.3
  ),
  "legend_style_full"
)

# legend_wrap - use mpg for more levels
wrap_plot <- ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  labs(color = "Class")

save_example(
  wrap_plot + legend_wrap(ncol = 2),
  "legend_wrap_ncol2"
)

save_example(
  wrap_plot + legend_wrap(nrow = 2),
  "legend_wrap_nrow2"
)

# legend_reverse
save_example(
  base_plot + legend_reverse(),
  "legend_reverse"
)

# =============================================================================
# Combined Examples
# =============================================================================

# Position + Style
save_example(
  base_plot +
    legend_left() +
    legend_style(size = 12, title_face = "bold", background = "grey95"),
  "combined_left_styled"
)

# Inside + Style
save_example(
  base_plot +
    legend_inside(position = "topright", background = "white", border = "grey50") +
    legend_style(size = 11, title_face = "bold"),
  "combined_inside_styled"
)

# Wrap + Position
save_example(
  wrap_plot +
    legend_wrap(ncol = 2) +
    legend_bottom(),
  "combined_wrap_bottom",
  width = 7, height = 5
)

# =============================================================================
# Patchwork Examples (if available)
# =============================================================================

if (requireNamespace("patchwork", quietly = TRUE)) {
  library(patchwork)

  p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
    geom_point() +
    labs(title = "Plot 1", color = "Cyl")

  p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
    geom_point() +
    labs(title = "Plot 2", color = "Cyl")

  p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
    geom_point() +
    labs(title = "Plot 3", color = "Cyl")

  # Without collection
  save_example(
    p1 | p2,
    "patchwork_no_collect",
    width = 8, height = 4
  )

  # With collection
  save_example(
    collect_legends(p1 | p2),
    "patchwork_collect",
    width = 8, height = 4
  )

  # Collection at bottom
  save_example(
    collect_legends(p1 | p2, position = "bottom"),
    "patchwork_collect_bottom",
    width = 8, height = 4
  )

  # Stacked plots - default (centered legend)
  save_example(
    collect_legends(p1 / p2 / p3, position = "right"),
    "patchwork_stacked_default",
    width = 6, height = 8
  )

  # Helper for grob-based saves (gtable objects)
  save_grob_example <- function(gt, name, width = 6, height = 8) {
    filepath <- file.path(out_dir, paste0(name, ".svg"))
    svglite(filepath, width = width, height = height, bg = "transparent")
    grid::grid.draw(gt)
    dev.off()
    make_svg_theme_aware(filepath)
    message("Saved: ", name, ".svg")
  }

  # Stacked plots - spanning legend
  gt <- collect_legends(p1 / p2 / p3, position = "right", span = TRUE)
  save_grob_example(gt, "patchwork_stacked_span", width = 6, height = 8)

  # Stacked plots - span row 1 only
  gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1)
  save_grob_example(gt, "patchwork_span_row1", width = 6, height = 8)

  # Stacked plots - span rows 1:2
  gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1:2)
  save_grob_example(gt, "patchwork_span_row12", width = 6, height = 8)
}

message("\nAll examples generated in: ", out_dir)
