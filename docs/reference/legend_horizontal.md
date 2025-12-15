# Set Legend Direction to Horizontal

A one-liner to arrange legend keys horizontally. Useful for legends
placed at the top or bottom of a plot.

## Usage

``` r
legend_horizontal()
```

## Value

A ggplot2 theme object that can be added to a plot.

## See also

[`legend_vertical`](https://gcol33.github.io/ggguides/reference/legend_vertical.md),
[`legend_top`](https://gcol33.github.io/ggguides/reference/legend_top.md),
[`legend_bottom`](https://gcol33.github.io/ggguides/reference/legend_bottom.md)

## Examples

``` r
library(ggplot2)

# Horizontal legend at bottom
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_bottom() +
  legend_horizontal()
```
