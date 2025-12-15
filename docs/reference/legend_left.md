# Place Legend on the Left with Proper Alignment

A one-liner to position the legend on the left side of the plot with
correct left alignment for both the key box and text labels. This goes
beyond simple `legend.position = "left"` by also setting justification
and box alignment.

## Usage

``` r
legend_left()
```

## Value

A ggplot2 theme object that can be added to a plot.

## Details

This function sets three theme elements:

- `legend.position = "left"` to place the legend on the left

- `legend.justification = "left"` to left-justify the legend box

- `legend.box.just = "left"` to left-align multiple legend boxes

## See also

[`legend_right`](https://gcol33.github.io/ggguides/reference/legend_right.md),
[`legend_top`](https://gcol33.github.io/ggguides/reference/legend_top.md),
[`legend_bottom`](https://gcol33.github.io/ggguides/reference/legend_bottom.md),
[`legend_inside`](https://gcol33.github.io/ggguides/reference/legend_inside.md),
[`legend_none`](https://gcol33.github.io/ggguides/reference/legend_none.md)

## Examples

``` r
library(ggplot2)

# Basic usage
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_left()

# Works with multiple legends
ggplot(mtcars, aes(mpg, wt, color = factor(cyl), shape = factor(am))) +
  geom_point(size = 3) +
  legend_left()
```
