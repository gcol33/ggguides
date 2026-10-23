# Patchwork Integration

Installation is covered in [Getting Started with
ggguides](https://gcol33.github.io/ggguides/articles/getting-started.md).
The examples also need
[patchwork](https://patchwork.data-imaginist.com).

## Overview

When combining multiple plots with patchwork, legends often need special
handling:

- **Duplicate legends** - Same aesthetic mapped in multiple plots
  creates redundancy

- **Alignment issues** - Legends may not align properly across panels

- **Spanning** - Legends should sometimes span multiple rows

ggguides provides
[`collect_legends()`](https://gcol33.github.io/ggguides/reference/collect_legends.md)
and
[`collect_axes()`](https://gcol33.github.io/ggguides/reference/collect_axes.md)
to address these challenges.

## The Problem: Duplicate Legends

Plots placed side by side get narrow panels, so the examples use three
x-axis breaks (`x_breaks`) to keep the tick labels apart.

``` r

library(patchwork)

x_breaks <- scale_x_continuous(breaks = c(10, 20, 30))

p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() + x_breaks + labs(title = "Plot 1", color = "Cylinders")
p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() + x_breaks + labs(title = "Plot 2", color = "Cylinders")

# Default patchwork: duplicate legends
p1 | p2
```

![Two scatter plots side by side, Plot 1 of weight and Plot 2 of
horsepower against fuel economy, coloured by cylinders, each plot with
its own cylinders legend.](patchwork_files/figure-html/problem-1.svg)

## Basic Legend Collection

Use
[`collect_legends()`](https://gcol33.github.io/ggguides/reference/collect_legends.md)
to gather legends from all plots in a composition:

``` r

collect_legends(p1 | p2)
```

![Two scatter plots side by side, Plot 1 of weight and Plot 2 of
horsepower against fuel economy, coloured by cylinders, with one shared
cylinders legend on the
right.](patchwork_files/figure-html/collect-basic-1.svg)

### Position Options

Control where the collected legend appears:

``` r

collect_legends(p1 | p2, position = "bottom")
```

![Two scatter plots side by side, Plot 1 of weight and Plot 2 of
horsepower against fuel economy, coloured by cylinders, with one shared
cylinders legend below both
plots.](patchwork_files/figure-html/collect-bottom-1.svg)

``` r

collect_legends(p1 | p2, position = "left")
```

![Two scatter plots side by side, Plot 1 of weight and Plot 2 of
horsepower against fuel economy, coloured by cylinders, with one shared
cylinders legend on the
left.](patchwork_files/figure-html/collect-left-1.svg)

## Stacked Plots

For vertically stacked plots, legends can be centered or span the full
height. Using different plot heights makes the spanning behavior more
visible.

### Default: Centered

``` r

# Create plots with different heights using plot_layout
p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
  geom_point() + x_breaks + labs(title = "Plot 3", color = "Cylinders")

# Stack with different heights: 1, 3/4, 1/2
stacked <- (p1 / p2 / p3) + plot_layout(heights = c(2, 1.5, 1))
collect_legends(stacked, position = "right")
```

![Three scatter plots stacked with decreasing heights, of weight,
horsepower and displacement against fuel economy, with one cylinders
legend on the right centred on the full
height.](patchwork_files/figure-html/stacked-default-1.svg)

### Spanning Full Height

Use `span = TRUE` to make the legend fill the full height:

``` r

gt <- collect_legends(stacked, position = "right", span = TRUE)
grid::grid.draw(gt)
```

![Three scatter plots stacked with decreasing heights, of weight,
horsepower and displacement against fuel economy, with one cylinders
legend on the right spanning the full
height.](patchwork_files/figure-html/stacked-span-1.svg)

### Attaching to Specific Rows

Attach the legend to specific row(s) instead of spanning all:

``` r

# Legend attached to row 1 only (the tallest plot)
gt <- collect_legends(stacked, position = "right", span = 1)
grid::grid.draw(gt)
```

![Three scatter plots stacked with decreasing heights, of weight,
horsepower and displacement against fuel economy, with the cylinders
legend beside the top plot
only.](patchwork_files/figure-html/span-row1-1.svg)

``` r

# Legend attached to rows 1 and 2
gt <- collect_legends(stacked, position = "right", span = 1:2)
grid::grid.draw(gt)
```

![Three scatter plots stacked with decreasing heights, of weight,
horsepower and displacement against fuel economy, with the cylinders
legend beside the top two
plots.](patchwork_files/figure-html/span-row12-1.svg)

## Collecting Duplicate Axes

When stacking plots vertically, the x-axis may be duplicated. Use
[`collect_axes()`](https://gcol33.github.io/ggguides/reference/collect_axes.md)
to remove redundant axes:

``` r

# Plots stacked vertically - x-axis is duplicated
p_top <- ggplot(mtcars, aes(mpg, wt)) +
  geom_point() + labs(y = "Weight")

p_bottom <- ggplot(mtcars, aes(mpg, disp)) +
  geom_point() + labs(y = "Displacement")

# Without axis collection (both have x-axis)
p_top / p_bottom
```

![Two scatter plots stacked, of weight and displacement against fuel
economy, each with its own fuel economy
axis.](patchwork_files/figure-html/collect-axes-1.svg)

``` r

# With axis collection (removes redundant x-axis from top)
collect_axes(p_top / p_bottom)
```

![The same two stacked scatter plots with the top plot's fuel economy
axis removed, leaving one shared axis at the
bottom.](patchwork_files/figure-html/collect-axes-fixed-1.svg)

## Combining with Styling

ggguides functions work together:

``` r

p1_styled <- p1 + legend_style(size = 15, title_face = "bold")
p2_styled <- p2 + legend_style(size = 15, title_face = "bold")

collect_legends(p1_styled | p2_styled, position = "right")
```

![Two scatter plots side by side, Plot 1 of weight and Plot 2 of
horsepower against fuel economy, coloured by cylinders, with one shared
cylinders legend on the right, its title in
bold.](patchwork_files/figure-html/combined-1.svg)

## Complex Layouts

Handle more complex patchwork layouts:

``` r

p4 <- ggplot(mtcars, aes(qsec, wt, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 4", color = "Cylinders")

# 2x2 grid
layout <- (p1 | p2) / (p3 | p4)
collect_legends(layout, position = "right")
```

![Four scatter plots in a two by two grid, coloured by cylinders, with
one shared cylinders legend on the
right.](patchwork_files/figure-html/complex-1.svg)

## cowplot / Grid Users

ggguides provides cowplot-compatible functions that work without
patchwork:

### `get_legend()` - Extract Legend

``` r

# Extract legend from a plot
leg <- get_legend(cp1)

# Use with cowplot::plot_grid() or grid::grid.draw()
grid::grid.newpage()
grid::grid.draw(leg)
```

![A cylinders legend drawn on its own, without a
plot.](patchwork_files/figure-html/get-legend-1.svg)

### `shared_legend()` - Combine Plots with Shared Legend

``` r

# Side-by-side with shared legend on right
gt <- shared_legend(cp1, cp2, ncol = 2, position = "right")
grid::grid.newpage()
grid::grid.draw(gt)
```

![Two scatter plots side by side, Plot 1 of weight and Plot 2 of
horsepower against fuel economy, coloured by cylinders, arranged without
patchwork, with one shared cylinders legend on the
right.](patchwork_files/figure-html/shared-legend-side-1.svg)

``` r

# Stacked with legend at bottom
gt <- shared_legend(cp1, cp2, cp3, ncol = 1, position = "bottom")
grid::grid.newpage()
grid::grid.draw(gt)
```

![Three scatter plots stacked, of weight, horsepower and displacement
against fuel economy, with one shared cylinders legend below
them.](patchwork_files/figure-html/shared-legend-stacked-1.svg)

``` r

# 2x2 grid
gt <- shared_legend(cp1, cp2, cp3, cp4, ncol = 2, nrow = 2, position = "right")
grid::grid.newpage()
grid::grid.draw(gt)
```

![Four scatter plots in a two by two grid, arranged without patchwork,
with one shared cylinders legend on the
right.](patchwork_files/figure-html/shared-legend-grid-1.svg)

All ggguides styling functions
([`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md),
[`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md),
etc.) work on individual plots regardless of layout package.

## Summary

| Function | Purpose | Key Parameters |
|----|----|----|
| [`collect_legends()`](https://gcol33.github.io/ggguides/reference/collect_legends.md) | Gather legends from patchwork | `position`, `span` |
| [`collect_axes()`](https://gcol33.github.io/ggguides/reference/collect_axes.md) | Remove duplicate axes | `guides` |
| [`get_legend()`](https://gcol33.github.io/ggguides/reference/get_legend.md) | Extract legend as grob | \- |
| [`shared_legend()`](https://gcol33.github.io/ggguides/reference/shared_legend.md) | Combine plots with shared legend | `ncol`, `nrow`, `position` |

**Learn more:**

- [Legend
  Positioning](https://gcol33.github.io/ggguides/articles/positioning.md)
  for single-plot placement

- [Styling &
  Customization](https://gcol33.github.io/ggguides/articles/styling.md)
  for legend appearance
