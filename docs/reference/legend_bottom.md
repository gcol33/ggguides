# Place Legend on Bottom with Horizontal Layout

A one-liner to position the legend below the plot with horizontal
layout. Optionally aligns to the full plot area rather than just the
panel.

## Usage

``` r
legend_bottom(align_to = c("panel", "plot"), by = NULL)
```

## Arguments

- align_to:

  Where to align the legend. Either `"panel"` (default, aligns to plot
  panel) or `"plot"` (aligns to full plot including title). Requires
  ggplot2 \>= 3.5.0 for `"plot"` alignment. Ignored when `by` is
  specified.

- by:

  Optional aesthetic name (character) to position only a specific
  legend. When specified, uses per-guide positioning via
  `guide_legend(position = "bottom")`. Requires ggplot2 \>= 3.5.0.
  Common values: `"colour"`, `"fill"`, `"size"`.

## Value

A ggplot2 theme object (when `by` is NULL) or a guides specification
(when `by` is specified).

## See also

[`legend_top`](https://gcol33.github.io/ggguides/reference/legend_top.md),
[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_right`](https://gcol33.github.io/ggguides/reference/legend_right.md),
[`legend_horizontal`](https://gcol33.github.io/ggguides/reference/legend_horizontal.md)

## Examples

``` r
library(ggplot2)

# Basic usage
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_bottom()

# Aligned to full plot
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  labs(title = "My Plot Title") +
  legend_bottom(align_to = "plot")

# Position only the colour legend at bottom
ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
  geom_point() +
  legend_bottom(by = "colour") +
  legend_right(by = "size")
```
