# Place Legend on the Left with Proper Alignment

A one-liner to position the legend on the left side of the plot. Slides
the legend along the left rail via `justification`, and left-aligns
multiple legend boxes via `legend.box.just`.

## Usage

``` r
legend_left(justification = "center", by = NULL)
```

## Arguments

- justification:

  Where the legend sits along the left edge. One of `"top"`, `"center"`,
  `"bottom"`, or a numeric value in `[0, 1]` (0 = bottom, 1 = top).
  Default is `"center"`. Only used when `by` is NULL. For per-guide
  justification, use
  [`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md)`(by = ..., justification = ...)`.

- by:

  Optional aesthetic name (character) to position only a specific
  legend. When specified, uses per-guide positioning via
  `guide_legend(position = "left")`. Requires ggplot2 \>= 3.5.0. Common
  values: `"colour"`, `"fill"`, `"size"`.

## Value

A ggplot2 theme object (when `by` is NULL) or a guides specification
(when `by` is specified).

## Details

The left-positioned legend lives in a vertical rail along the panel's
left edge. `justification` slides it along that rail: `"top"` pins the
legend's top edge to the panel top; `"bottom"` pins its bottom edge to
the panel bottom; `"center"` centers it vertically.

Note the naming asymmetry with
[`legend_inside`](https://gcol33.github.io/ggguides/reference/legend_inside.md):
for side legends the justification keyword refers to where the legend
sits along the panel edge; for inside legends it refers to which corner
of the legend anchors to the `(x, y)` position.

When `by` is NULL (default), this function sets:

- `legend.position = "left"`

- `legend.justification.left = justification`

- `legend.box.just = "left"` to left-align multiple legend boxes

When `by` is specified, only the legend for that aesthetic is moved.

## See also

[`legend_right`](https://gcol33.github.io/ggguides/reference/legend_right.md),
[`legend_top`](https://gcol33.github.io/ggguides/reference/legend_top.md),
[`legend_bottom`](https://gcol33.github.io/ggguides/reference/legend_bottom.md),
[`legend_inside`](https://gcol33.github.io/ggguides/reference/legend_inside.md),
[`legend_none`](https://gcol33.github.io/ggguides/reference/legend_none.md)

## Examples

``` r
library(ggplot2)

# Basic usage — legend centered vertically on the left
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_left()

# Pin legend to the top of the left rail
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_left(justification = "top")

# Position only the colour legend on the left
ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
  geom_point() +
  legend_left(by = "colour") +
  legend_bottom(by = "size")
```
