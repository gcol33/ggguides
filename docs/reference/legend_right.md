# Place Legend on the Right with Proper Alignment

A one-liner to position the legend on the right side of the plot with
correct right alignment for both the key box and text labels.

## Usage

``` r
legend_right()
```

## Value

A ggplot2 theme object that can be added to a plot.

## Details

This function sets three theme elements:

- `legend.position = "right"` to place the legend on the right

- `legend.justification = "right"` to right-justify the legend box

- `legend.box.just = "right"` to right-align multiple legend boxes

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

```
