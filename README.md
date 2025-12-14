# ggguides

Simplified legend and guide alignment for ggplot2.

## Installation

```r
# Install from GitHub
# install.packages("pak")
pak::pak("gcol33/ggguides")
```

## Overview

ggguides provides one-liner functions for common legend and guide operations in ggplot2, with special focus on multi-panel plots created with patchwork or cowplot.

## Functions

| Function | Description |
|----------|-------------|
| `legend_left()` | Position legend on the left with proper alignment |
| `legend_wrap()` | Wrap legend entries into columns or rows |
| `collect_legends()` | Collect legends from patchwork compositions |
| `align_guides_h()` | Horizontally align guides across plots |

## Examples

### 1. Left Legend with True Left Alignment

**Before:** Using `theme(legend.position = "left")` alone doesn't properly align the legend content.

```r
library(ggplot2)

# Default left positioning - legend keys may not align
ggplot(mtcars, aes(mpg, wt, color = factor(cyl), shape = factor(am))) +
  geom_point(size = 3) +
  theme(legend.position = "left")
```

**After:** `legend_left()` sets position, justification, and box alignment together.

```r
library(ggplot2)
library(ggguides)

# True left alignment for both key boxes and text
ggplot(mtcars, aes(mpg, wt, color = factor(cyl), shape = factor(am))) +
  geom_point(size = 3) +
  legend_left()
```

### 2. Wrapped Legend Columns

**Before:** Long legends stretch vertically, wasting space.

```r
library(ggplot2)

# All 7 classes in a single column
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point()
```

**After:** `legend_wrap()` arranges entries in a grid.

```r
library(ggplot2)
library(ggguides)

# Compact 2-column layout
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2)
```

### 3. Collecting Legends in Patchwork

**Before:** Each plot in a patchwork composition has its own redundant legend.

```r
library(ggplot2)
library(patchwork)

p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  labs(title = "Weight vs MPG")

p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() +
  labs(title = "HP vs MPG")

# Duplicate legends
p1 | p2
```

**After:** `collect_legends()` merges them into one.
```r
library(ggplot2)
library(patchwork)
library(ggguides)

p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  labs(title = "Weight vs MPG")

p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() +
  labs(title = "HP vs MPG")

# Single shared legend
collect_legends(p1 | p2)

# Or place it at the bottom
collect_legends(p1 | p2, position = "bottom")
```

## Combining Functions

Functions can be combined for maximum control:

```r
library(ggplot2)
library(patchwork)
library(ggguides)

p1 <- ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point()

p2 <- ggplot(mpg, aes(displ, cty, color = class)) +
  geom_point()

# Combine plots, collect legends, wrap into 2 columns, position on left
(p1 / p2) |>
  collect_legends(position = "left") &
  legend_wrap(ncol = 2)
```

## cowplot Users

While ggguides focuses on patchwork integration, cowplot users can still use `legend_left()` and `legend_wrap()` on individual plots. For legend collection with cowplot, use:

```r
library(cowplot)

legend <- get_legend(p1)
plot_grid(
  plot_grid(p1 + theme(legend.position = "none"),
            p2 + theme(legend.position = "none")),
  legend,
  rel_widths = c(3, 1)
)
```

## License

MIT
