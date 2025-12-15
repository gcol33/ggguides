# Collect Legends from Patchwork Compositions

Collects legends from multiple plots in a patchwork composition into a
single legend area. This is a convenience wrapper around patchwork's
guide collection functionality.

## Usage

``` r
collect_legends(
  x,
  position = c("right", "left", "bottom", "top"),
  span = FALSE
)
```

## Arguments

- x:

  A patchwork object created by combining ggplot2 plots with operators
  like `|`, `/`, or `+`.

- position:

  Where to place the collected legends. One of `"right"` (default),
  `"left"`, `"bottom"`, or `"top"`.

- span:

  Logical or integer vector. If `TRUE`, the legend will span the full
  height (for left/right) or width (for top/bottom). If an integer
  vector (e.g., `c(1, 2)` or `1:2`), the legend spans only those
  rows/columns. Default is `FALSE`. When not `FALSE`, returns a gtable
  instead of a patchwork object.

## Value

A patchwork object with legends collected, or a gtable if `span` is not
`FALSE`.

## Details

This function requires the patchwork package. If patchwork is not
installed, an informative error is raised.

When `span = TRUE`, the function converts the patchwork to a gtable and
modifies the legend cell to span all rows (for right/left positions) or
all columns (for top/bottom positions). This addresses the common issue
where collected legends are centered rather than spanning the full
composition.

When `span` is an integer vector (e.g., `c(1, 2)`), the legend is
centered between those specific rows (for right/left) or columns (for
top/bottom). This is useful for attaching a legend to specific plots in
a stacked layout. Row/column numbers refer to the panel positions in the
patchwork (1-indexed).

For cowplot users: cowplot does not have a built-in legend collection
mechanism. Consider using the lemon package for manual legend extraction
and positioning.

## See also

[`collect_axes`](https://gcol33.github.io/ggguides/reference/collect_axes.md),
[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_wrap`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
library(patchwork)

p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point()
p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point()

# Without collection: each plot has its own legend
p1 | p2

# With collection: single shared legend
collect_legends(p1 | p2)

# Place collected legend on the bottom
collect_legends(p1 | p2, position = "bottom")

# Legend spanning full height (returns gtable, draw with grid.draw)
gt <- collect_legends(p1 / p2, position = "right", span = TRUE)
grid::grid.draw(gt)

# Attach legend to specific rows (e.g., align with row 1 only)
p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 3")
gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1)
grid::grid.draw(gt)

# Attach legend to rows 1 and 2
gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1:2)
grid::grid.draw(gt)
} # }
```
