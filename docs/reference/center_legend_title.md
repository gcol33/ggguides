# Center Legend Title Over Keys

Modifies a ggplot so that legend titles are centered over the key column
only, rather than over the full legend width (keys + labels). This is
particularly useful when legend labels are rotated, as the default
centering places the title too far to the right.

## Usage

``` r
center_legend_title(plot, position = "all")
```

## Arguments

- plot:

  A ggplot object.

- position:

  Legend position to modify. One of `"right"`, `"left"`, `"top"`,
  `"bottom"`, or `"all"` (default).

## Value

A modified gtable object that can be drawn with
[`grid::grid.draw()`](https://rdrr.io/r/grid/grid.draw.html) or saved
with
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).

## Details

This function works by modifying the legend's internal gtable structure,
restricting the title's column span to only the keys column. Long titles
will automatically wrap to fit within the key column width, and proper
spacing is added to prevent overlap with rotated labels.

The title should have `hjust = 0.5` set (done automatically by
`legend_style(angle = ...)`) for proper centering.

## See also

[`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md)

## Examples

``` r
library(ggplot2)

p <- ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_style(angle = 45) +
  labs(color = "Vehicle Class")

# Center title over keys only (long titles wrap automatically)
# Returns a gtable - use grid::grid.draw() to render
if (FALSE) { # \dontrun{
g <- center_legend_title(p)
grid::grid.draw(g)
} # }
```
