# Force Legends to Stay Separate

Force specified legends to remain separate by assigning different order
values, preventing automatic merging.

## Usage

``` r
legend_split(...)
```

## Arguments

- ...:

  Aesthetic names (unquoted) to keep separate. E.g., `colour, fill`.

## Value

A guides specification that can be added to a plot.

## Details

By default, ggplot2 merges legends that have matching titles and labels.
This function assigns different order values to each legend, which
prevents automatic merging.

## See also

[`legend_merge`](https://gcol33.github.io/ggguides/reference/legend_merge.md),
[`legend_order_guides`](https://gcol33.github.io/ggguides/reference/legend_order_guides.md)

## Examples

``` r
library(ggplot2)

# Plot where colour and fill would normally merge
p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
  geom_point(shape = 21, size = 3, stroke = 1.5) +
  labs(color = "Cylinders", fill = "Cylinders")

# Force separate legends
p + legend_split(colour, fill)
```
