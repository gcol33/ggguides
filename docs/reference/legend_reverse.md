# Reverse Legend Order

Reverses the order of entries in all legends. Useful when the natural
data order doesn't match the desired visual order (e.g., when stacking
bars).

## Usage

``` r
legend_reverse()
```

## Value

A guides specification that can be added to a plot.

## Details

This function applies `guide_legend(reverse = TRUE)` to all common
discrete aesthetics: colour, fill, shape, size, linetype, and alpha.

## See also

[`legend_wrap`](https://gcol33.github.io/ggguides/reference/legend_wrap.md),
[`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md)

## Examples

``` r
library(ggplot2)

# Default order
p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point()

# Reversed order
p2 <- p1 + legend_reverse()
```
