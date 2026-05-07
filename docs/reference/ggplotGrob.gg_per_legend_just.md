# Convert per-legend-justification plot to gtable

Convert per-legend-justification plot to gtable

## Usage

``` r
# S3 method for class 'gg_per_legend_just'
ggplotGrob(x)
```

## Arguments

- x:

  A gg_per_legend_just object

## Value

A gtable object (grob table) with per-legend justifications applied,
suitable for rendering with
[`grid::grid.draw()`](https://rdrr.io/r/grid/grid.draw.html) or saving
with
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).
