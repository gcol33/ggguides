# Multiple Legends

## Overview

When a plot maps multiple aesthetics (colour, size, shape, etc.),
ggplot2 creates separate legends for each. ggguides provides functions
to control these legends individually:

- **Hide specific legends** with
  [`legend_hide()`](https://gcol33.github.io/ggguides/reference/legend_hide.md)
- **Keep only certain legends** with
  [`legend_select()`](https://gcol33.github.io/ggguides/reference/legend_select.md)
- **Control display order** with
  [`legend_order_guides()`](https://gcol33.github.io/ggguides/reference/legend_order_guides.md)
- **Force merge/split** with
  [`legend_merge()`](https://gcol33.github.io/ggguides/reference/legend_merge.md)
  and
  [`legend_split()`](https://gcol33.github.io/ggguides/reference/legend_split.md)
- **Position legends separately** using `by` parameter on position
  functions
- **Style legends separately** using `by` parameter on
  [`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md)

## Example Plot

``` r

# Plot with multiple aesthetics
p <- ggplot(mtcars, aes(mpg, wt,
                        color = factor(cyl),
                        size = hp,
                        shape = factor(am))) +
  geom_point() +
  labs(color = "Cylinders", size = "Horsepower", shape = "Transmission")

p
```

![](multiple-legends_files/figure-html/example-plot-1.svg)

## Hiding Legends

Use
[`legend_hide()`](https://gcol33.github.io/ggguides/reference/legend_hide.md)
to remove specific legends while keeping others:

``` r

# Hide the size legend
p + legend_hide(size)
```

![](multiple-legends_files/figure-html/hide-legends-1.svg)

``` r


# Hide multiple legends
p + legend_hide(size, shape)
```

![](multiple-legends_files/figure-html/hide-legends-2.svg)

## Selecting Legends

Use
[`legend_select()`](https://gcol33.github.io/ggguides/reference/legend_select.md)
to keep only certain legends (inverse of
[`legend_hide()`](https://gcol33.github.io/ggguides/reference/legend_hide.md)):

``` r

# Keep only the colour legend
p + legend_select(colour)
```

![](multiple-legends_files/figure-html/select-legends-1.svg)

``` r


# Keep colour and shape
p + legend_select(colour, shape)
```

![](multiple-legends_files/figure-html/select-legends-2.svg)

## Controlling Legend Order

By default, legends appear in an unspecified order. Use
[`legend_order_guides()`](https://gcol33.github.io/ggguides/reference/legend_order_guides.md)
to control the display order:

``` r

# Default order
p
```

![](multiple-legends_files/figure-html/order-legends-1.svg)

``` r


# Size legend first, then colour, then shape
p + legend_order_guides(size = 1, colour = 2, shape = 3)
```

![](multiple-legends_files/figure-html/order-legends-2.svg)

## Merging and Splitting Legends

ggplot2 automatically merges legends when they have the same title and
matching labels. Use
[`legend_merge()`](https://gcol33.github.io/ggguides/reference/legend_merge.md)
and
[`legend_split()`](https://gcol33.github.io/ggguides/reference/legend_split.md)
to override this behavior.

### Forcing Merge

``` r

# Plot where colour and fill map to the same variable
p_merge <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
  geom_point(shape = 21, size = 4, stroke = 1.5) +
  labs(color = "Cylinders", fill = "Cylinders")

# Legends merge automatically when titles and labels match
p_merge
```

![](multiple-legends_files/figure-html/merge-legends-1.svg)

``` r


# Explicitly request merge (reinforces default behavior)
p_merge + legend_merge(colour, fill)
```

![](multiple-legends_files/figure-html/merge-legends-2.svg)

### Forcing Split

``` r

# Force separate legends even when they could merge
p_merge + legend_split(colour, fill)
```

![](multiple-legends_files/figure-html/split-legends-1.svg)

## Positioning Legends Separately

Position functions
([`legend_left()`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_right()`](https://gcol33.github.io/ggguides/reference/legend_right.md),
[`legend_top()`](https://gcol33.github.io/ggguides/reference/legend_top.md),
[`legend_bottom()`](https://gcol33.github.io/ggguides/reference/legend_bottom.md))
accept a `by` parameter to position specific legends:

``` r

# Place colour legend on the left, size legend at bottom
p +
  legend_hide(shape) +
  legend_left(by = "colour") +
  legend_bottom(by = "size")
```

![](multiple-legends_files/figure-html/position-separately-1.svg)

``` r

# Colour legend on top, size on right
p +
  legend_hide(shape) +
  legend_top(by = "colour") +
  legend_right(by = "size")
```

![](multiple-legends_files/figure-html/position-top-right-1.svg)

## Styling Legends Separately

Use the `by` parameter on
[`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md)
to apply different styles to different legends:

``` r

p +
  legend_hide(shape) +
  legend_style(title_face = "bold", background = "grey95", by = "colour") +
  legend_style(size = 10, by = "size")
```

![](multiple-legends_files/figure-html/style-separately-1.svg)

## Combining Multiple Controls

All functions work together:

``` r

# Complex example: hide shape, position colour on left with bold title,
# position size at bottom with smaller text
p +
  legend_hide(shape) +
  legend_left(by = "colour") +
  legend_style(title_face = "bold", title_size = 14, by = "colour") +
  legend_bottom(by = "size") +
  legend_style(size = 9, direction = "horizontal", by = "size")
```

![](multiple-legends_files/figure-html/combined-1.svg)

## Summary

| Function | Purpose | Parameters |
|----|----|----|
| [`legend_hide()`](https://gcol33.github.io/ggguides/reference/legend_hide.md) | Hide specific legends | Aesthetic names (unquoted) |
| [`legend_select()`](https://gcol33.github.io/ggguides/reference/legend_select.md) | Keep only specific legends | Aesthetic names (unquoted) |
| [`legend_order_guides()`](https://gcol33.github.io/ggguides/reference/legend_order_guides.md) | Control legend display order | Named args: `aes = order` |
| [`legend_merge()`](https://gcol33.github.io/ggguides/reference/legend_merge.md) | Force legends to merge | Aesthetic names (unquoted) |
| [`legend_split()`](https://gcol33.github.io/ggguides/reference/legend_split.md) | Force legends to stay separate | Aesthetic names (unquoted) |
| `legend_left(by=)` | Position one legend on left | `by = "aesthetic"` |
| `legend_style(by=)` | Style one legend | `by = "aesthetic"` + style args |

**Learn more:**

- [Legend
  Positioning](https://gcol33.github.io/ggguides/articles/positioning.md)
  for single-legend placement
- [Styling &
  Customization](https://gcol33.github.io/ggguides/articles/styling.md)
  for legend appearance
- [Patchwork
  Integration](https://gcol33.github.io/ggguides/articles/patchwork.md)
  for multi-panel plots
