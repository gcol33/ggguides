# Set Legend Direction to Vertical

A one-liner to arrange legend keys vertically. This is the default for
legends placed on the left or right of a plot.

## Usage

``` r
legend_vertical()
```

## Value

A ggplot2 theme object that can be added to a plot.

## See also

[`legend_horizontal`](https://gcol33.github.io/ggguides/reference/legend_horizontal.md),
[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_right`](https://gcol33.github.io/ggguides/reference/legend_right.md)

## Examples

``` r
library(ggplot2)

# Explicitly set vertical direction
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_right() +
  legend_vertical()

```
