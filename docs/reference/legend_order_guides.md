# Control Legend Display Order

Set the display order of multiple legends. Legends with lower order
values appear first (top or left).

## Usage

``` r
legend_order_guides(...)
```

## Arguments

- ...:

  Named arguments where names are aesthetic names and values are integer
  order positions. E.g., `colour = 1, size = 2`.

## Value

A guides specification that can be added to a plot.

## Details

The order value determines the position of the legend relative to
others. Lower values appear first. By default, all legends have order =
0 and appear in an unspecified order.

## See also

[`legend_merge`](https://gcol33.github.io/ggguides/reference/legend_merge.md),
[`legend_split`](https://gcol33.github.io/ggguides/reference/legend_split.md)

## Examples

``` r
library(ggplot2)

# Plot with multiple legends
p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
  geom_point()

# Default order
p

# Size legend first, then colour
p + legend_order_guides(size = 1, colour = 2)

# Colour legend first
p + legend_order_guides(colour = 1, size = 2)
```
