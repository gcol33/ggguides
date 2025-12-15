# Wrap Legend Entries into Columns or Rows

A one-liner to arrange legend entries in a grid layout. Works with
discrete legends by applying the specified layout to all color, fill,
shape, size, linetype, and alpha aesthetics.

## Usage

``` r
legend_wrap(ncol = NULL, nrow = NULL, byrow = TRUE)
```

## Arguments

- ncol:

  Number of columns for the legend layout. If `NULL`, determined
  automatically based on `nrow`.

- nrow:

  Number of rows for the legend layout. If `NULL`, determined
  automatically based on `ncol`.

- byrow:

  Logical. If `TRUE` (default), fills by row first. If `FALSE`, fills by
  column first.

## Value

A list of guide specifications that can be added to a plot.

## Details

This function creates a
[`guides()`](https://ggplot2.tidyverse.org/reference/guides.html)
specification that applies the same column/row layout to all common
discrete aesthetics. At least one of `ncol` or `nrow` should be
specified.

## See also

[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`collect_legends`](https://gcol33.github.io/ggguides/reference/collect_legends.md)

## Examples

``` r
library(ggplot2)

# Wrap a long legend into 2 columns
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2)

# Wrap into 3 rows, filling by column
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(nrow = 3, byrow = FALSE)

# Combine with legend_left for left-aligned wrapped legends
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2) +
  legend_left()
```
