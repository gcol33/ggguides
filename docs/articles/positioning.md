# Legend Positioning

Installation is covered in [Getting Started with
ggguides](https://gcol33.github.io/ggguides/articles/getting-started.md).

## Overview

ggguides provides position helpers that handle legend placement without
requiring knowledge of ggplot2’s theme system. Each function sets the
appropriate combination of `legend.position`, `legend.justification`,
and `legend.box.just` to achieve proper alignment.

## Basic Positioning

### Left and Right

``` r

p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(color = "Cylinders")

p + legend_left() + ggtitle("Left")
```

![Scatter plot of car weight against fuel economy titled Left, coloured
by cylinders, with the legend on the left of the
panel.](positioning_files/figure-html/left-1.svg)

``` r

p + legend_right() + ggtitle("Right")
```

![Scatter plot of car weight against fuel economy titled Right, coloured
by cylinders, with the legend on the right of the
panel.](positioning_files/figure-html/right-1.svg)

### Top and Bottom

When placing legends at the top or bottom, the legend is automatically
oriented horizontally:

``` r

p + legend_top() + ggtitle("Top")
```

![Scatter plot of car weight against fuel economy titled Top, coloured
by cylinders, with the legend above the panel in a
row.](positioning_files/figure-html/top-1.svg)

``` r

p + legend_bottom() + ggtitle("Bottom")
```

![Scatter plot of car weight against fuel economy titled Bottom,
coloured by cylinders, with the legend below the panel in a
row.](positioning_files/figure-html/bottom-1.svg)

### Alignment with Titles

Use the `align_to` parameter to control how the legend aligns with the
plot. The difference is most visible when there’s a y-axis label. By
default the legend aligns with the panel:

``` r

p_labeled <- p + labs(title = "Fuel Economy", y = "Weight (1000 lbs)")

p_labeled + legend_top() + ggtitle("Panel alignment (default)")
```

![Scatter plot of car weight against fuel economy titled Panel
alignment, with the legend above the panel aligned to the panel's
extent.](positioning_files/figure-html/align-panel-1.svg)

With `align_to = "plot"` the legend aligns with the full plot, including
the axis title:

``` r

p_labeled + legend_top(align_to = "plot") + ggtitle("Plot alignment")
```

![Scatter plot of car weight against fuel economy titled Plot alignment,
with the legend above the panel aligned to the full plot including the
axis title.](positioning_files/figure-html/align-plot-1.svg)

## Inside Positioning

[`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md)
places the legend within the plot panel. You can use either coordinate
values or named shortcuts.

### Using Shortcuts

Available shortcuts: `"topright"`, `"topleft"`, `"bottomright"`,
`"bottomleft"`, `"center"`

``` r

p + legend_inside(position = "topright") + ggtitle("Top right")
```

![Scatter plot of car weight against fuel economy titled Top right, with
the legend inside the panel in the top-right
corner.](positioning_files/figure-html/inside-topright-1.svg)

``` r

p + legend_inside(position = "bottomleft") + ggtitle("Bottom left")
```

![Scatter plot of car weight against fuel economy titled Bottom left,
with the legend inside the panel in the bottom-left
corner.](positioning_files/figure-html/inside-bottomleft-1.svg)

### Using Coordinates

For precise control, specify x/y coordinates (0-1 scale) and
justification:

``` r

p + legend_inside(x = 0.95, y = 0.95, justification = c("right", "top"))
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend inside the panel in the top-right
corner.](positioning_files/figure-html/inside-coords-1.svg)

### Adding Background

Inside legends often need a background for readability:

``` r

p + legend_inside(
  position = "topright",
  background = "#FFF3E0",
  border = "#FF9800"
)
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend inside the panel in the top-right
corner on a cream box with an orange
border.](positioning_files/figure-html/inside-background-1.svg)

## Direction Control

### Horizontal and Vertical

Control legend entry direction independently of position:

``` r

p + legend_horizontal() + ggtitle("Horizontal")
```

![Scatter plot of car weight against fuel economy titled Horizontal,
with the legend on the right and its keys in a
row.](positioning_files/figure-html/horizontal-1.svg)

``` r

p + legend_vertical() + ggtitle("Vertical")
```

![Scatter plot of car weight against fuel economy titled Vertical, with
the legend on the right and its keys in a
column.](positioning_files/figure-html/vertical-1.svg)

### Combining Direction and Position

``` r

p + legend_right() + legend_horizontal()
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, with the legend on the right and its keys in a
row.](positioning_files/figure-html/direction-position-1.svg)

## Removing the Legend

``` r

p + legend_none()
```

![Scatter plot of car weight against fuel economy, points coloured by
number of cylinders, without a
legend.](positioning_files/figure-html/legend-none-1.svg)

## Summary

| Function | Position | Auto-Direction |
|----|----|----|
| [`legend_left()`](https://gcol33.github.io/ggguides/reference/legend_left.md) | Left of panel | Vertical |
| [`legend_right()`](https://gcol33.github.io/ggguides/reference/legend_right.md) | Right of panel | Vertical |
| [`legend_top()`](https://gcol33.github.io/ggguides/reference/legend_top.md) | Above panel | Horizontal |
| [`legend_bottom()`](https://gcol33.github.io/ggguides/reference/legend_bottom.md) | Below panel | Horizontal |
| [`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md) | Inside panel | Unchanged |
| [`legend_none()`](https://gcol33.github.io/ggguides/reference/legend_none.md) | Hidden | N/A |

**Learn more:**

- [Styling &
  Customization](https://gcol33.github.io/ggguides/articles/styling.md)
  for font, background, and border options

- [Patchwork
  Integration](https://gcol33.github.io/ggguides/articles/patchwork.md)
  for multi-panel workflows
