# Collect Axes from Patchwork Compositions

Collects duplicate axes from multiple plots in a patchwork composition,
removing redundant axis labels and ticks. This is a convenience wrapper
around patchwork's axis collection functionality.

## Usage

``` r
collect_axes(x, guides = c("collect", "keep"))

align_guides_h(x, guides = c("collect", "keep"))
```

## Arguments

- x:

  A patchwork object created by combining ggplot2 plots.

- guides:

  How to handle guides. Either `"collect"` to combine into a single
  legend (default), or `"keep"` to maintain separate legends.

## Value

A patchwork object with collected axes.

## Details

This function applies patchwork's `axes = "collect"` layout option,
which removes duplicate axes when plots are stacked or placed
side-by-side. For example, in a 2x1 vertical layout, the x-axis labels
on the top plot will be removed since they are redundant with the bottom
plot's x-axis.

When `guides = "collect"`, legends are also merged into a single shared
legend.

For cowplot: Axis alignment in cowplot requires manual use of
[`align_plots`](https://wilkelab.org/cowplot/reference/align_plots.html)
with `align = "h"` or `"v"`. This function does not directly support
cowplot objects.

## See also

[`collect_legends`](https://gcol33.github.io/ggguides/reference/collect_legends.md),
[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_wrap`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)

## Examples

``` r
# \donttest{
library(ggplot2)
library(patchwork)

# Two plots stacked vertically - x-axis is duplicated
p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  labs(y = "Weight")
p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() +
  labs(y = "Horsepower")

# Without collect_axes: both plots show x-axis
p1 / p2

# With collect_axes: removes redundant x-axis from top plot
collect_axes(p1 / p2)

# Keep separate legends
collect_axes(p1 / p2, guides = "keep")
# }
```
