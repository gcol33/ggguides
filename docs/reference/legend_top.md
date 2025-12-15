# Place Legend on Top with Horizontal Layout

A one-liner to position the legend above the plot with horizontal
layout. Optionally aligns to the full plot area (including title) rather
than just the panel.

## Usage

``` r
legend_top(align_to = c("panel", "plot"))
```

## Arguments

- align_to:

  Where to align the legend. Either `"panel"` (default, aligns to plot
  panel) or `"plot"` (aligns to full plot including title). Requires
  ggplot2 \>= 3.5.0 for `"plot"` alignment.

## Value

A ggplot2 theme object that can be added to a plot.

## See also

[`legend_bottom`](https://gcol33.github.io/ggguides/reference/legend_bottom.md),
[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_right`](https://gcol33.github.io/ggguides/reference/legend_right.md),
[`legend_horizontal`](https://gcol33.github.io/ggguides/reference/legend_horizontal.md)

## Examples

``` r
library(ggplot2)

# Basic usage - aligned to panel
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_top()


# Aligned to full plot (useful with titles)
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  labs(title = "My Plot Title") +
  legend_top(align_to = "plot")

```
