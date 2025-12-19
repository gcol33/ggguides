# Convert auto-fit legend plot to gtable

Convert auto-fit legend plot to gtable

## Usage

``` r
# S3 method for class 'gg_autofit_legend'
ggplotGrob(x)
```

## Arguments

- x:

  A gg_autofit_legend object

## Value

A gtable object (grob table) with auto-fitted and centered legend,
suitable for rendering with
[`grid::grid.draw()`](https://rdrr.io/r/grid/grid.draw.html) or saving
with
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).
