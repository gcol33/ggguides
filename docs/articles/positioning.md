# Legend Positioning

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

p + legend_left() + ggtitle("legend_left()")
p + legend_right() + ggtitle("legend_right()")
```

![](positioning_files/figure-html/left-right-1.svg)![](positioning_files/figure-html/left-right-2.svg)

### Top and Bottom

When placing legends at the top or bottom, the legend is automatically
oriented horizontally:

``` r

p + legend_top() + ggtitle("legend_top()")
p + legend_bottom() + ggtitle("legend_bottom()")
```

![](positioning_files/figure-html/top-bottom-1.svg)![](positioning_files/figure-html/top-bottom-2.svg)

### Alignment with Titles

Use the `align_to` parameter to control how the legend aligns with the
plot:

``` r

p_titled <- p + labs(title = "Fuel Economy by Weight")

# Default: align to panel
p_titled + legend_top() + ggtitle("align_to = 'panel' (default)")

# Align to full plot (useful with titles)
p_titled + legend_top(align_to = "plot") + ggtitle("align_to = 'plot'")
```

![](positioning_files/figure-html/align-to-1.svg)![](positioning_files/figure-html/align-to-2.svg)

## Inside Positioning

[`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md)
places the legend within the plot panel. You can use either coordinate
values or named shortcuts.

### Using Shortcuts

Available shortcuts: `"topright"`, `"topleft"`, `"bottomright"`,
`"bottomleft"`, `"center"`

``` r

p + legend_inside(position = "topright") + ggtitle("topright")
p + legend_inside(position = "bottomleft") + ggtitle("bottomleft")
```

![](positioning_files/figure-html/inside-shortcuts-1.svg)![](positioning_files/figure-html/inside-shortcuts-2.svg)

### Using Coordinates

For precise control, specify x/y coordinates (0-1 scale) and
justification:

``` r

p + legend_inside(x = 0.95, y = 0.95, just = c("right", "top"))
```

![](positioning_files/figure-html/inside-coords-1.svg)

### Adding Background

Inside legends often need a background for readability:

``` r

p + legend_inside(
  position = "topright",
  background = "grey95",
  border = "grey50"
)
```

![](positioning_files/figure-html/inside-background-1.svg)

## Direction Control

### Horizontal and Vertical

Control legend entry direction independently of position:

``` r

p + legend_horizontal() + ggtitle("legend_horizontal()")
p + legend_vertical() + ggtitle("legend_vertical()")
```

![](positioning_files/figure-html/direction-1.svg)![](positioning_files/figure-html/direction-2.svg)

### Combining Direction and Position

``` r

p + legend_right() + legend_horizontal()
```

![](positioning_files/figure-html/direction-position-1.svg)

## Removing the Legend

``` r

p + legend_none()
```

![](positioning_files/figure-html/legend-none-1.svg)

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
