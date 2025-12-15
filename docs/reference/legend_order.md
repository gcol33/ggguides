# Reorder Legend Entries

Change the order of legend entries without modifying factor levels in
your data. This provides a simpler alternative to manually setting
factor levels or using the `breaks` argument in scale functions.

## Usage

``` r
legend_order(order, aesthetic = "colour")
```

## Arguments

- order:

  A character vector specifying the desired order of legend entries, or
  a function to apply to the current order (e.g., `rev`, `sort`).

- aesthetic:

  Character string specifying which aesthetic's legend to reorder.
  Default is `"colour"`. Common values: `"colour"`, `"color"`, `"fill"`,
  `"shape"`, `"linetype"`, `"size"`, `"alpha"`.

## Value

A ggplot2 scale object that reorders the legend.

## Details

This function works by setting the `breaks` argument of the appropriate
discrete scale. It automatically detects whether to use
`scale_colour_discrete`, `scale_fill_discrete`, etc. based on the
`aesthetic` argument.

When `order` is a function (like `rev` or `sort`), it will be applied to
the default order of legend entries.

## See also

[`legend_reverse`](https://gcol33.github.io/ggguides/reference/legend_reverse.md)
for a simpler way to reverse legend order,
[`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md)
for styling legend appearance.

## Examples

``` r
library(ggplot2)

p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3)

# Specify exact order
p + legend_order(c("8", "6", "4"))

# Reverse the order
p + legend_order(rev)

# Sort alphabetically/numerically
p + legend_order(sort)

# Reorder fill aesthetic
ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  legend_order(c("8", "4", "6"), aesthetic = "fill")
```
