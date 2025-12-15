# Horizontally Align Guides Across Plots

Ensures that guide (legend) areas align horizontally across multiple
plots in a composition. This is useful when you have side-by-side or
stacked plots and want their legends to be visually aligned.

## Usage

``` r
align_guides_h(x, guides = c("collect", "keep"))
```

## Arguments

- x:

  A patchwork object created by combining ggplot2 plots.

- guides:

  How to handle guides. Either `"collect"` to combine into a single
  legend (default), or `"keep"` to maintain separate legends while
  ensuring they align.

## Value

A patchwork object with aligned guide areas.

## Details

This function works by applying patchwork's axis alignment features
which indirectly ensure that legend areas have consistent positioning.
When `guides = "collect"`, legends are also merged.

For cowplot: Horizontal alignment in cowplot requires manual use of
[`align_plots`](https://wilkelab.org/cowplot/reference/align_plots.html)
with `align = "h"`. This function does not directly support cowplot
objects.

## See also

[`collect_legends`](https://gcol33.github.io/ggguides/reference/collect_legends.md),
[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_wrap`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
library(patchwork)

# Two plots with different y-axis label widths
p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  labs(y = "Weight")
p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() +
  labs(y = "A very long y-axis label")

# Align horizontally with collected legend
align_guides_h(p1 / p2)

# Keep separate legends but aligned
align_guides_h(p1 / p2, guides = "keep")
} # }
```
