# Styling & Customization

## Overview

ggguides provides styling functions to customize legend appearance
without diving into ggplot2’s theme element hierarchy. The main
functions are:

- [`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md) -
  Comprehensive styling (fonts, backgrounds, borders)
- [`legend_keys()`](https://gcol33.github.io/ggguides/reference/legend_keys.md) -
  Override key appearance (size, alpha, shape)
- [`legend_order()`](https://gcol33.github.io/ggguides/reference/legend_order.md) -
  Reorder legend entries
- [`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md) -
  Multi-column/row layouts
- [`legend_reverse()`](https://gcol33.github.io/ggguides/reference/legend_reverse.md) -
  Reverse entry order
- [`colorbar_style()`](https://gcol33.github.io/ggguides/reference/colorbar_style.md) -
  Customize continuous color bar legends

## Font Styling with legend_style()

### Font Size

Adjust the overall text size (applies to both title and labels):

``` r

p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(color = "Cylinders")

p + ggtitle("Default size")
p + legend_style(size = 14) + ggtitle("size = 14")
```

![](styling_files/figure-html/style-size-1.png)![](styling_files/figure-html/style-size-2.png)

### Font Family

Change the font family for legend text:

``` r

p + legend_style(family = "serif") + ggtitle("serif")
p + legend_style(family = "mono") + ggtitle("mono")
```

![](styling_files/figure-html/style-family-1.png)![](styling_files/figure-html/style-family-2.png)

### Title Emphasis

Make the title stand out with separate size and face settings:

``` r

p + legend_style(
  size = 12,
  title_size = 14,
  title_face = "bold"
)
```

![](styling_files/figure-html/style-title-1.png)

## Background and Border

Add visual containers around the legend:

``` r

p + legend_style(
  background = "grey95"
)
```

![](styling_files/figure-html/style-background-1.png)

``` r

p + legend_style(
  background = "grey95",
  background_color = "grey70"
)
```

![](styling_files/figure-html/style-border-1.png)

## Key Size

Adjust the size of legend keys (color swatches):

``` r

p + legend_style(
  key_width = 1.5,
  key_height = 1.5
)
```

![](styling_files/figure-html/style-key-1.png)

## Margin

Control spacing around the legend:

``` r

p + legend_style(
  background = "grey95",
  margin = 0.5
)
```

![](styling_files/figure-html/style-margin-1.png)

## Full Styling Example

Combine all styling options:

``` r

p + legend_style(
  size = 11,
  title_size = 13,
  title_face = "bold",
  family = "sans",
  key_width = 1.2,
  background = "grey95",
  background_color = "grey70",
  margin = 0.3
)
```

![](styling_files/figure-html/style-full-1.png)

## Wrapping Legend Entries

For legends with many entries,
[`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)
creates multi-column or multi-row layouts.

### By Columns

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2)
```

![](styling_files/figure-html/wrap-ncol-1.png)

### By Rows

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(nrow = 2)
```

![](styling_files/figure-html/wrap-nrow-1.png)

### With Bottom Position

Wrapping works well with horizontal legends:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(nrow = 2) +
  legend_bottom()
```

![](styling_files/figure-html/wrap-bottom-1.png)

## Customizing Legend Keys

When plot aesthetics like small point sizes or low alpha values make
legend keys hard to read,
[`legend_keys()`](https://gcol33.github.io/ggguides/reference/legend_keys.md)
overrides the key appearance without affecting the plot.

### Enlarging Small Points

``` r

p_small <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 1) +
  labs(color = "Cylinders")

p_small + ggtitle("Small points in legend")
p_small + legend_keys(size = 4) + ggtitle("Enlarged legend keys")
```

![](styling_files/figure-html/keys-size-1.png)![](styling_files/figure-html/keys-size-2.png)

### Removing Transparency

``` r

p_alpha <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(alpha = 0.3, size = 3) +
  labs(color = "Cylinders")

p_alpha + ggtitle("Transparent legend keys")
p_alpha + legend_keys(alpha = 1) + ggtitle("Opaque legend keys")
```

![](styling_files/figure-html/keys-alpha-1.png)![](styling_files/figure-html/keys-alpha-2.png)

### Combining Overrides

``` r

ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(alpha = 0.3, size = 1) +
  legend_keys(size = 4, alpha = 1)
```

![](styling_files/figure-html/keys-combined-1.png)

### Targeting Specific Aesthetics

By default,
[`legend_keys()`](https://gcol33.github.io/ggguides/reference/legend_keys.md)
applies to both colour and fill legends. Target specific aesthetics with
the `aesthetic` parameter:

``` r

ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(cyl))) +
  geom_boxplot(alpha = 0.5) +
  legend_keys(alpha = 1, aesthetic = "fill")
```

![](styling_files/figure-html/keys-fill-1.png)

## Reordering Legend Entries

[`legend_order()`](https://gcol33.github.io/ggguides/reference/legend_order.md)
changes the order of legend entries without modifying factor levels in
your data.

### Explicit Order

Specify the exact order you want:

``` r

p + legend_order(c("8", "6", "4"))
```

![](styling_files/figure-html/order-explicit-1.png)

### Using Functions

Apply functions like `rev` or `sort` to the current order:

``` r

p + legend_order(rev) + ggtitle("Reversed")
p + legend_order(sort) + ggtitle("Sorted")
```

![](styling_files/figure-html/order-rev-1.png)![](styling_files/figure-html/order-rev-2.png)

### Other Aesthetics

Reorder legends for fill, shape, or other aesthetics:

``` r

ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  legend_order(c("8", "4", "6"), aesthetic = "fill")
```

![](styling_files/figure-html/order-fill-1.png)

## Reversing Legend Order

For simple reversal,
[`legend_reverse()`](https://gcol33.github.io/ggguides/reference/legend_reverse.md)
is a convenient shorthand:

``` r

p + legend_reverse()
```

![](styling_files/figure-html/reverse-1.png)

## Combining Style Functions

All ggguides functions compose with `+`:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_left() +
  legend_style(
    size = 11,
    title_face = "bold",
    background = "grey95"
  )
```

![](styling_files/figure-html/combined-styling-1.png)

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2) +
  legend_bottom() +
  legend_style(size = 10, title_face = "bold")
```

![](styling_files/figure-html/combined-wrap-style-1.png)

## Styling Continuous Color Bars

For continuous scales,
[`colorbar_style()`](https://gcol33.github.io/ggguides/reference/colorbar_style.md)
customizes the color bar appearance.

### Basic Usage

``` r

p_cont <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile()

p_cont
```

![](styling_files/figure-html/colorbar-basic-1.png)

### Size Adjustments

Create taller, thinner bars:

``` r

p_cont + colorbar_style(width = 0.5, height = 10)
```

![](styling_files/figure-html/colorbar-size-1.png)

### Horizontal Orientation

``` r

p_cont + colorbar_style(width = 10, height = 0.5, direction = "horizontal") +
  legend_bottom()
```

![](styling_files/figure-html/colorbar-horizontal-1.png) \### Adding a
Frame

``` r

p_cont + colorbar_style(frame = TRUE) + ggtitle("Black frame")
p_cont + colorbar_style(frame = "grey50") + ggtitle("Grey frame")
```

![](styling_files/figure-html/colorbar-frame-1.png)![](styling_files/figure-html/colorbar-frame-2.png)

### Removing Ticks

``` r

p_cont + colorbar_style(ticks = FALSE, frame = "grey50")
```

![](styling_files/figure-html/colorbar-noticks-1.png)

### Combined Customization

``` r

p_cont + colorbar_style(
  width = 0.5,
  height = 8,
  frame = "grey30",
  ticks_length = 0.3
)
```

![](styling_files/figure-html/colorbar-full-1.png)

## Summary

| Function | Purpose | Key Parameters |
|----|----|----|
| [`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md) | Comprehensive styling | `size`, `title_size`, `title_face`, `family`, `background`, `background_color`, `margin` |
| [`legend_keys()`](https://gcol33.github.io/ggguides/reference/legend_keys.md) | Override key appearance | `size`, `alpha`, `shape`, `linewidth`, `aesthetic` |
| [`legend_order()`](https://gcol33.github.io/ggguides/reference/legend_order.md) | Reorder entries | `order` (vector or function), `aesthetic` |
| [`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md) | Multi-column layout | `ncol`, `nrow` |
| [`legend_reverse()`](https://gcol33.github.io/ggguides/reference/legend_reverse.md) | Reverse entry order | None |
| [`colorbar_style()`](https://gcol33.github.io/ggguides/reference/colorbar_style.md) | Continuous color bar | `width`, `height`, `frame`, `ticks`, `direction` |

**Learn more:**

- [Legend
  Positioning](https://gcol33.github.io/ggguides/articles/positioning.md)
  for placement control
- [Patchwork
  Integration](https://gcol33.github.io/ggguides/articles/patchwork.md)
  for multi-panel workflows
