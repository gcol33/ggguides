# Place Legend on the Right with Proper Alignment

A one-liner to position the legend on the right side of the plot. Slides
the legend along the right rail via `justification`, and right-aligns
multiple legend boxes via `legend.box.just`.

## Usage

``` r
legend_right(justification = "center", by = NULL)
```

## Arguments

- justification:

  Where the legend sits along the right edge. One of `"top"`,
  `"center"`, `"bottom"`, or a numeric value in `[0, 1]` (0 = bottom, 1
  = top). Default is `"center"`. Only used when `by` is NULL.

- by:

  Optional aesthetic name (character) to position only a specific
  legend. When specified, uses per-guide positioning via
  `guide_legend(position = "right")`. Requires ggplot2 \>= 3.5.0. Common
  values: `"colour"`, `"fill"`, `"size"`.

## Value

A ggplot2 theme object (when `by` is NULL) or a guides specification
(when `by` is specified).

## Details

`justification` slides the legend along the right rail: `"top"` /
`"center"` / `"bottom"` or a number in `[0, 1]`. For per-guide
justification, use
[`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md)`(by = ..., justification = ...)`.

## See also

[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_top`](https://gcol33.github.io/ggguides/reference/legend_top.md),
[`legend_bottom`](https://gcol33.github.io/ggguides/reference/legend_bottom.md),
[`legend_inside`](https://gcol33.github.io/ggguides/reference/legend_inside.md)

## Examples

``` r
library(ggplot2)

# Basic usage
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_right()

# Pin legend to the bottom of the right rail
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_right(justification = "bottom")

# Position only the size legend on the right
ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
  geom_point() +
  legend_bottom(by = "colour") +
  legend_right(by = "size")
```
