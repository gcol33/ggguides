# Getting Started with ggguides

## Installation

``` r

install.packages("ggguides")
```

Or the development version from GitHub:

``` r

# install.packages("pak")
pak::pak("gcol33/ggguides")
```

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

## Basic Usage

Let’s create a simple plot to demonstrate the legend helpers:

``` r

p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(color = "Cylinders")

p
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the cylinders legend on the
right.](getting-started_files/figure-html/base-plot-1.svg)

### Moving the Legend

Position the legend on any side with a single function call:

``` r

p + legend_left()
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend on the left of the
panel.](getting-started_files/figure-html/position-left-1.svg)

``` r

p + legend_bottom()
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend below the panel and its keys in a
row.](getting-started_files/figure-html/position-bottom-1.svg)

### Inside Positioning

Place the legend inside the plot area using coordinates or shortcuts:

``` r

p + legend_inside(position = "topright")
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend inside the panel in the top-right
corner.](getting-started_files/figure-html/inside-topright-1.svg)

``` r

p + legend_inside(x = 0.02, y = 0.98, justification = c("left", "top"))
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend inside the panel in the top-left
corner.](getting-started_files/figure-html/inside-coords-1.svg)

### Removing the Legend

``` r

p + legend_none()
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, without a
legend.](getting-started_files/figure-html/legend-none-1.svg)

## Styling Legends

Use
[`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md)
to customize the legend appearance:

``` r

p + legend_style(size = 18)
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend title and labels drawn
larger.](getting-started_files/figure-html/style-size-1.svg)

``` r

p + legend_style(
  size = 15,
  title_size = 20,
  title_face = "bold",
  background = "#FFF3E0",
  background_color = "#FF9800"
)
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with a bold legend title and the legend on a cream
box with an orange
border.](getting-started_files/figure-html/style-full-1.svg)

## Wrapping Legend Entries

For legends with many entries, use
[`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)
to create multi-column layouts:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2)
```

![Scatter plot of highway mileage against engine displacement, points
coloured by the seven car classes, with the legend keys in two columns
on the right.](getting-started_files/figure-html/wrap-example-1.svg)

## Combining Functions

ggguides functions compose naturally with the `+` operator:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_left() +
  legend_style(size = 15, title_face = "bold", background = "#FFF3E0")
```

![Scatter plot of highway mileage against engine displacement, points
coloured by the seven car classes, with the legend on the left on a
cream box, its title in
bold.](getting-started_files/figure-html/combined-1.svg)

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2) +
  legend_bottom()
```

![Scatter plot of highway mileage against engine displacement, points
coloured by the seven car classes, with the legend below the panel and
its keys in two
columns.](getting-started_files/figure-html/combined-wrap-1.svg)

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
