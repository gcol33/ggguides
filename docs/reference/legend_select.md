# Keep Only Specific Legends

Show only the specified legends and hide all others. This is the inverse
of
[`legend_hide`](https://gcol33.github.io/ggguides/reference/legend_hide.md).

## Usage

``` r
legend_select(...)
```

## Arguments

- ...:

  Aesthetic names (unquoted) to keep. All other legends will be hidden.
  Common values: `colour`, `fill`, `size`, `shape`, `linetype`, `alpha`.

## Value

A guides specification that can be added to a plot, or `NULL` if nothing
needs to be hidden.

## See also

[`legend_hide`](https://gcol33.github.io/ggguides/reference/legend_hide.md),
[`legend_none`](https://gcol33.github.io/ggguides/reference/legend_none.md)

## Examples

``` r
library(ggplot2)

# Plot with multiple legends
p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp,
                         shape = factor(am))) +
  geom_point()

# Keep only the colour legend
p + legend_select(colour)

# Keep colour and shape, hide size
p + legend_select(colour, shape)
```
