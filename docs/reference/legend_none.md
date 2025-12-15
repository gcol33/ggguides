# Remove Legend from Plot

A one-liner to remove the legend from a plot. Cleaner alternative to
`theme(legend.position = "none")`.

## Usage

``` r
legend_none()
```

## Value

A ggplot2 theme object that can be added to a plot.

## See also

[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_right`](https://gcol33.github.io/ggguides/reference/legend_right.md)

## Examples

``` r
library(ggplot2)

# Remove legend
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_none()

```
