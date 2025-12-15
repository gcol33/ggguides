# Place Legend on the Right with Proper Alignment

A one-liner to position the legend on the right side of the plot with
correct right alignment for both the key box and text labels.

## Usage

``` r
legend_right(by = NULL)
```

## Arguments

- by:

  Optional aesthetic name (character) to position only a specific
  legend. When specified, uses per-guide positioning via
  `guide_legend(position = "right")`. Requires ggplot2 \>= 3.5.0. Common
  values: `"colour"`, `"fill"`, `"size"`.

## Value

A ggplot2 theme object (when `by` is NULL) or a guides specification
(when `by` is specified).

## Details

When `by` is NULL (default), this function sets three theme elements:

- `legend.position = "right"` to place the legend on the right

- `legend.justification = "right"` to right-justify the legend box

- `legend.box.just = "right"` to right-align multiple legend boxes

When `by` is specified, only the legend for that aesthetic is moved,
allowing different legends to be placed in different positions.

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

# Position only the size legend on the right
ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
  geom_point() +
  legend_bottom(by = "colour") +
  legend_right(by = "size")
```
