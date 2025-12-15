# Getting Started with ggguides

## Overview

**ggguides** simplifies common legend operations in ggplot2. Instead of
memorizing theme element names and their nested structure, you can use
intuitive one-liner functions to position, style, and manage legends.

**Key features:**

- Position legends with
  [`legend_left()`](https://gcol33.github.io/ggguides/reference/legend_left.md),
  [`legend_right()`](https://gcol33.github.io/ggguides/reference/legend_right.md),
  [`legend_top()`](https://gcol33.github.io/ggguides/reference/legend_top.md),
  [`legend_bottom()`](https://gcol33.github.io/ggguides/reference/legend_bottom.md),
  [`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md)
- Style legends with
  [`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md)
  for fonts, backgrounds, and borders
- Wrap legend entries with
  [`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)
  for multi-column layouts
- Collect legends from patchwork compositions with
  [`collect_legends()`](https://gcol33.github.io/ggguides/reference/collect_legends.md)

## Installation

``` r

# Install from GitHub
# install.packages("pak")
pak::pak("gcol33/ggguides")
```

## Basic Usage

Let’s create a simple plot to demonstrate the legend helpers:

``` r

p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(color = "Cylinders")

p
```

![](getting-started_files/figure-html/base-plot-1.png)

### Moving the Legend

Position the legend on any side with a single function call:

``` r

p + legend_left()
```

![](getting-started_files/figure-html/position-left-1.png)

``` r

p + legend_bottom()
```

![](getting-started_files/figure-html/position-bottom-1.png)

### Inside Positioning

Place the legend inside the plot area using coordinates or shortcuts:

``` r

p + legend_inside(position = "topright")
```

![](getting-started_files/figure-html/inside-topright-1.png)

``` r

p + legend_inside(x = 0.02, y = 0.98, just = c("left", "top"))
```

![](getting-started_files/figure-html/inside-coords-1.png)

### Removing the Legend

``` r

p + legend_none()
```

![](getting-started_files/figure-html/legend-none-1.png)

## Styling Legends

Use
[`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md)
to customize the legend appearance:

``` r

p + legend_style(size = 14)
```

![](getting-started_files/figure-html/style-size-1.png)

``` r

p + legend_style(
  size = 12,
  title_size = 14,
  title_face = "bold",
  background = "grey95",
  background_color = "grey70"
)
```

![](getting-started_files/figure-html/style-full-1.png)

## Wrapping Legend Entries

For legends with many entries, use
[`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)
to create multi-column layouts:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2)
```

![](getting-started_files/figure-html/wrap-example-1.png)

## Combining Functions

ggguides functions compose naturally with the `+` operator:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_left() +
  legend_style(size = 12, title_face = "bold", background = "grey95")
```

![](getting-started_files/figure-html/combined-1.png)

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2) +
  legend_bottom()
```

![](getting-started_files/figure-html/combined-wrap-1.png)

## What’s Next

- See the [Legend
  Positioning](https://gcol33.github.io/ggguides/articles/positioning.md)
  article for detailed position control
- See the [Styling &
  Customization](https://gcol33.github.io/ggguides/articles/styling.md)
  article for advanced styling options
- See the [Patchwork
  Integration](https://gcol33.github.io/ggguides/articles/patchwork.md)
  article for multi-panel workflows
