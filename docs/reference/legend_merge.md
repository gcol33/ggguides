# Force Legends to Merge

Force specified legends to merge together by setting them to the same
order. Legends will only merge if they have matching labels (same factor
levels or break values).

## Usage

``` r
legend_merge(...)
```

## Arguments

- ...:

  Aesthetic names (unquoted) to merge. E.g., `colour, fill`.

## Value

A guides specification that can be added to a plot.

## Details

ggplot2 automatically merges legends when they have the same title and
matching labels. This function ensures legends have the same order value
(order = 0), which is a prerequisite for merging.

If legends still don't merge after using this function, ensure:

- Both aesthetics map to the same variable

- The legends have identical titles (use
  [`labs()`](https://ggplot2.tidyverse.org/reference/labs.html))

- The breaks/labels are identical

## See also

[`legend_split`](https://gcol33.github.io/ggguides/reference/legend_split.md),
[`legend_order_guides`](https://gcol33.github.io/ggguides/reference/legend_order_guides.md)

## Examples

``` r
library(ggplot2)

# Plot where colour and fill map to the same variable
p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
  geom_point(shape = 21, size = 3, stroke = 1.5) +
  labs(color = "Cylinders", fill = "Cylinders")

# Force merge (they should merge automatically if labels match)
p + legend_merge(colour, fill)
```
