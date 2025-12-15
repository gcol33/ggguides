# Place Legend Inside the Plot Area

Position the legend inside the plot panel at specified coordinates or
using convenient position shortcuts like `"topright"` or `"bottomleft"`.

## Usage

``` r
legend_inside(
  x = NULL,
  y = NULL,
  position = NULL,
  just = NULL,
  background = "white",
  border = NA,
  padding = 0.2
)
```

## Arguments

- x:

  Numeric x-coordinate in normalized 0-1 space, where 0 is left and 1 is
  right. Ignored if `position` is specified.

- y:

  Numeric y-coordinate in normalized 0-1 space, where 0 is bottom and 1
  is top. Ignored if `position` is specified.

- position:

  Character shortcut for common positions. One of `"topleft"`, `"top"`,
  `"topright"`, `"left"`, `"center"`, `"right"`, `"bottomleft"`,
  `"bottom"`, `"bottomright"`. If specified, overrides `x` and `y`.

- just:

  Justification of legend relative to the anchor point. Either a
  character vector of length 2 (horizontal, vertical) or a single value.
  Common values: `c("left", "top")`, `c("right", "bottom")`, `"center"`.
  If `NULL`, automatically determined based on position.

- background:

  Background fill color for the legend. Default is `"white"`.

- border:

  Border color for the legend box. Default is `NA` (no border).

- padding:

  Padding around legend content in cm. Default is `0.2`.

## Value

A ggplot2 theme object that can be added to a plot.

## See also

[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_right`](https://gcol33.github.io/ggguides/reference/legend_right.md),
[`legend_top`](https://gcol33.github.io/ggguides/reference/legend_top.md),
[`legend_bottom`](https://gcol33.github.io/ggguides/reference/legend_bottom.md)

## Examples

``` r
library(ggplot2)

# Using position shortcuts (recommended)
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_inside(position = "topright")

ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_inside(position = "bottomleft")

# Using coordinates
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_inside(x = 0.95, y = 0.95, just = c("right", "top"))

# Custom background and border
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_inside(position = "topright", background = "grey95", border = "grey50")
```
