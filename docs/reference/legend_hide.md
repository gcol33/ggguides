# Hide Specific Legends

Remove specific legends from a plot while keeping others. This is more
targeted than
[`legend_none()`](https://gcol33.github.io/ggguides/reference/legend_none.md)
which removes all legends.

## Usage

``` r
legend_hide(...)
```

## Arguments

- ...:

  Aesthetic names (unquoted) to hide. Common values: `colour`, `fill`,
  `size`, `shape`, `linetype`, `alpha`. Note: `color` is automatically
  converted to `colour`.

## Value

A guides specification that can be added to a plot.

## See also

[`legend_select`](https://gcol33.github.io/ggguides/reference/legend_select.md),
[`legend_none`](https://gcol33.github.io/ggguides/reference/legend_none.md)

## Examples

``` r
library(ggplot2)

# Plot with multiple legends
p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
  geom_point()

# Hide the size legend
p + legend_hide(size)

# Hide multiple legends
p + legend_hide(size, colour)
```
