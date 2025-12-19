# Convert centered title plot to gtable

Convert centered title plot to gtable

## Usage

``` r
# S3 method for class 'gg_centered_title'
ggplotGrob(x)
```

## Arguments

- x:

  A gg_centered_title object

## Value

A gtable object (grob table) with centered legend titles, suitable for
rendering with
[`grid::grid.draw()`](https://rdrr.io/r/grid/grid.draw.html) or saving
with
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).
