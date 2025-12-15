# =============================================================================
# Generate Example Images for ggguides Documentation
# Run this script from the package root directory
# =============================================================================

library(ggplot2)
library(ggguides)

# Output directory
out_dir <- "man/figures"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

# Base plot for examples
base_plot <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
geom_point(size = 3) +
labs(color = "Cylinders", title = "Example Plot")

# Helper to save plots
save_example <- function(p, name, width = 6, height = 4) {
  ggsave(
    filename = file.path(out_dir, paste0(name, ".png")),
    plot = p,
    width = width,
    height = height,
    dpi = 150,
    bg = "white"
  )
  message("Saved: ", name, ".png")
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

  # Stacked plots - spanning legend
  gt <- collect_legends(p1 / p2 / p3, position = "right", span = TRUE)
  png(file.path(out_dir, "patchwork_stacked_span.png"),
      width = 6, height = 8, units = "in", res = 150, bg = "white")
  grid::grid.draw(gt)
  dev.off()
  message("Saved: patchwork_stacked_span.png")

  # Stacked plots - span row 1 only
  gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1)
  png(file.path(out_dir, "patchwork_span_row1.png"),
      width = 6, height = 8, units = "in", res = 150, bg = "white")
  grid::grid.draw(gt)
  dev.off()
  message("Saved: patchwork_span_row1.png")

  # Stacked plots - span rows 1:2
  gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1:2)
  png(file.path(out_dir, "patchwork_span_row12.png"),
      width = 6, height = 8, units = "in", res = 150, bg = "white")
  grid::grid.draw(gt)
  dev.off()
  message("Saved: patchwork_span_row12.png")
}

message("\nAll examples generated in: ", out_dir)
