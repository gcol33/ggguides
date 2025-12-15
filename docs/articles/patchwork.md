# Patchwork Integration

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
[`align_guides_h()`](https://gcol33.github.io/ggguides/reference/align_guides_h.md)
to address these challenges.

## The Problem: Duplicate Legends

``` r

library(patchwork)

p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 1", color = "Cylinders")
p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 2", color = "Cylinders")

# Default patchwork: duplicate legends
p1 | p2
```

![](patchwork_files/figure-html/problem-1.svg)

## Basic Legend Collection

Use
[`collect_legends()`](https://gcol33.github.io/ggguides/reference/collect_legends.md)
to gather legends from all plots in a composition:

``` r

collect_legends(p1 | p2)
```

![](patchwork_files/figure-html/collect-basic-1.svg)

### Position Options

Control where the collected legend appears:

``` r

collect_legends(p1 | p2, position = "bottom")
```

![](patchwork_files/figure-html/collect-bottom-1.svg)

``` r

collect_legends(p1 | p2, position = "left")
```

![](patchwork_files/figure-html/collect-left-1.svg)

## Stacked Plots

For vertically stacked plots, legends can be centered or span the full
height. Using different plot heights makes the spanning behavior more
visible.

### Default: Centered

``` r

# Create plots with different heights using plot_layout
p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 3", color = "Cylinders")

# Stack with different heights: 1, 1/2, 1/4
stacked <- (p1 / p2 / p3) + plot_layout(heights = c(4, 2, 1))
collect_legends(stacked, position = "right")
```

![](patchwork_files/figure-html/stacked-default-1.svg)

### Spanning Full Height

Use `span = TRUE` to make the legend fill the full height:

``` r

gt <- collect_legends(stacked, position = "right", span = TRUE)
grid::grid.draw(gt)
```

![](patchwork_files/figure-html/stacked-span-1.svg)

### Attaching to Specific Rows

Attach the legend to specific row(s) instead of spanning all:

``` r

# Legend attached to row 1 only (the tallest plot)
gt <- collect_legends(stacked, position = "right", span = 1)
grid::grid.draw(gt)
```

![](patchwork_files/figure-html/span-row1-1.svg)

``` r

# Legend attached to rows 1 and 2
gt <- collect_legends(stacked, position = "right", span = 1:2)
grid::grid.draw(gt)
```

![](patchwork_files/figure-html/span-row12-1.svg)

## Horizontal Guide Alignment

When plots have different widths due to axis labels, use
[`align_guides_h()`](https://gcol33.github.io/ggguides/reference/align_guides_h.md)
to align them horizontally:

``` r

# Plots with different y-axis label widths
p_short <- ggplot(mtcars, aes(mpg, wt)) +
  geom_point() + labs(y = "wt")

p_long <- ggplot(mtcars, aes(mpg, disp)) +
  geom_point() + labs(y = "Displacement (cu.in.)")

# Without alignment
p_short / p_long
```

![](patchwork_files/figure-html/align-guides-1.svg)

``` r

# With horizontal alignment
align_guides_h(p_short / p_long)
```

![](patchwork_files/figure-html/align-guides-fixed-1.svg)

## Combining with Styling

ggguides functions work together:

``` r

p1_styled <- p1 + legend_style(size = 11, title_face = "bold")
p2_styled <- p2 + legend_style(size = 11, title_face = "bold")

collect_legends(p1_styled | p2_styled, position = "right")
```

![](patchwork_files/figure-html/combined-1.svg)

## Complex Layouts

Handle more complex patchwork layouts:

``` r

p4 <- ggplot(mtcars, aes(qsec, wt, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 4", color = "Cylinders")

# 2x2 grid
layout <- (p1 | p2) / (p3 | p4)
collect_legends(layout, position = "right")
```

![](patchwork_files/figure-html/complex-1.svg)

## cowplot Users

For cowplot workflows, consider the
[lemon](https://github.com/stefanedwards/lemon) package which provides:

- `g_legend()` - Extract legend as grob
- `grid_arrange_shared_legend()` - Combine plots with shared legend
- `reposition_legend()` - Place legend inside panels

ggguides functions like
[`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md),
[`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md),
and position helpers work on individual plots regardless of layout
package.

## Summary

| Function | Purpose | Key Parameters |
|----|----|----|
| [`collect_legends()`](https://gcol33.github.io/ggguides/reference/collect_legends.md) | Gather legends from patchwork | `position`, `span` |
| [`align_guides_h()`](https://gcol33.github.io/ggguides/reference/align_guides_h.md) | Align plots horizontally | None |

**Learn more:**

- [Legend
  Positioning](https://gcol33.github.io/ggguides/articles/positioning.md)
  for single-plot placement
- [Styling &
  Customization](https://gcol33.github.io/ggguides/articles/styling.md)
  for legend appearance
