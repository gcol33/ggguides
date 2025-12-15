# Extract Legend from a ggplot

Extracts the legend (guide-box) from a ggplot object as a grob that can
be used independently with grid or cowplot.

## Usage

``` r
get_legend(plot)
```

## Arguments

- plot:

  A ggplot object.

## Value

A grob containing the legend, or `NULL` if the plot has no legend.

## Details

This function is useful for cowplot workflows where you want to manually
position a shared legend. The extracted legend can be combined with
plots using
[`cowplot::plot_grid()`](https://wilkelab.org/cowplot/reference/plot_grid.html)
or drawn directly with
[`grid::grid.draw()`](https://rdrr.io/r/grid/grid.draw.html).

## See also

[`shared_legend`](https://gcol33.github.io/ggguides/reference/shared_legend.md),
[`collect_legends`](https://gcol33.github.io/ggguides/reference/collect_legends.md)

## Examples

``` r
library(ggplot2)

p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  labs(color = "Cylinders")

# Extract the legend
leg <- get_legend(p)

# Draw just the legend
grid::grid.newpage()
grid::grid.draw(leg)
```
