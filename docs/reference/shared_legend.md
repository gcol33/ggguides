# Combine Plots with a Shared Legend

Combines multiple ggplot objects into a grid layout with a single shared
legend. Works with base ggplot and cowplot workflows (no patchwork
required).

## Usage

``` r
shared_legend(
  ...,
  ncol = NULL,
  nrow = NULL,
  position = c("right", "left", "bottom", "top"),
  legend_from = 1,
  rel_legend_size = 0.2
)
```

## Arguments

- ...:

  ggplot objects to combine.

- ncol:

  Number of columns in the plot grid.

- nrow:

  Number of rows in the plot grid. If NULL (default), computed from ncol
  and number of plots.

- position:

  Where to place the shared legend. One of `"right"` (default),
  `"left"`, `"bottom"`, or `"top"`.

- legend_from:

  Which plot to extract the legend from. Default is 1 (first plot). Can
  be an integer index or a ggplot object.

- rel_legend_size:

  Relative size of the legend compared to the plot area. Default is 0.2
  (20 percent).

## Value

A gtable that can be drawn with
[`grid::grid.draw()`](https://rdrr.io/r/grid/grid.draw.html) or used
with
[`cowplot::ggdraw()`](https://wilkelab.org/cowplot/reference/ggdraw.html).

## Details

This function provides a simple way to create multi-panel plots with a
shared legend without requiring patchwork. It:

1.  Removes legends from all plots

2.  Extracts the legend from the specified plot

3.  Arranges plots in a grid

4.  Attaches the legend to the specified position

For more complex layouts or patchwork users, see
[`collect_legends`](https://gcol33.github.io/ggguides/reference/collect_legends.md).

## See also

[`get_legend`](https://gcol33.github.io/ggguides/reference/get_legend.md),
[`collect_legends`](https://gcol33.github.io/ggguides/reference/collect_legends.md)

## Examples

``` r
library(ggplot2)

p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 1", color = "Cylinders")
p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 2", color = "Cylinders")
p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 3", color = "Cylinders")

# \donttest{
# Side-by-side with shared legend on right
gt <- shared_legend(p1, p2, ncol = 2, position = "right")
grid::grid.newpage()
grid::grid.draw(gt)

# 2x2 grid with legend at bottom
gt <- shared_legend(p1, p2, p3, p1, ncol = 2, nrow = 2, position = "bottom")
grid::grid.newpage()
grid::grid.draw(gt)

# Stacked with legend on left
gt <- shared_legend(p1, p2, p3, ncol = 1, position = "left")
grid::grid.newpage()
grid::grid.draw(gt)
# }
```
