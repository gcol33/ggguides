# Customize Legend Key Appearance

Modify the appearance of legend keys (the symbols/glyphs in the legend)
without affecting the plot itself. This is a simpler alternative to
using `guide_legend(override.aes = list(...))`.

## Usage

``` r
legend_keys(
  size = NULL,
  alpha = NULL,
  shape = NULL,
  linewidth = NULL,
  linetype = NULL,
  fill = NULL,
  colour = NULL,
  color = NULL,
  stroke = NULL,
  aesthetic = c("colour", "fill")
)
```

## Arguments

- size:

  Numeric. Size of point keys.

- alpha:

  Numeric. Alpha (transparency) of keys, between 0 and 1.

- shape:

  Shape of point keys. Can be:

  - Numeric (0-25): Standard ggplot2 shape codes

  - Character name: `"circle"`, `"square"`, `"diamond"`, `"triangle"`,
    `"triangle_down"`, `"plus"`, `"cross"`, `"asterisk"`,
    `"circle_open"`, `"square_open"`, `"diamond_open"`,
    `"triangle_open"`, `"circle_filled"`, `"square_filled"`,
    `"diamond_filled"`, `"triangle_filled"`

  Shapes 21-25 (or names ending in `"_filled"`) support both outline
  (`colour`) and fill (`fill`) colors.

- linewidth:

  Numeric. Width of line keys.

- linetype:

  Character or numeric. Line type for line keys.

- fill:

  Character. Fill color for filled shapes (shapes 21-25). For shapes
  0-20, use `colour` instead.

- colour, color:

  Character. Outline/stroke color for keys. For shapes 21-25, this
  controls the outline; for shapes 0-20, this is the main color.

- stroke:

  Numeric. Stroke width for point outlines (shapes 21-25).

- aesthetic:

  Character vector specifying which aesthetic(s) to modify. Default is
  `c("colour", "fill")` which covers most common cases. Use `"all"` to
  apply to all legends.

## Value

A list of ggplot2 guide specifications.

## Details

This function wraps `guide_legend(override.aes = ...)` to provide a
cleaner interface for common legend key modifications. It's particularly
useful for:

- Making small points more visible in the legend

- Removing transparency from legend keys

- Changing symbol shapes to improve clarity

- Adding outlines to filled shapes for better visibility

**Shape types:**

- Shapes 0-14: Outline only (color from `colour`)

- Shapes 15-20: Filled solid (color from `colour`)

- Shapes 21-25: Outline + fill (outline from `colour`, interior from
  `fill`)

Only non-NULL arguments are applied, so you can selectively modify
specific properties.

## See also

[`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md)
for styling legend text and background,
[`legend_order`](https://gcol33.github.io/ggguides/reference/legend_order.md)
for reordering legend entries.

## Examples

``` r
library(ggplot2)

# Points get lost in legend - make them bigger
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 1) +
  legend_keys(size = 4)

# Remove transparency from legend
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(alpha = 0.3, size = 3) +
  legend_keys(alpha = 1)

# Change shape using name
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  legend_keys(shape = "square")

# Filled shape with outline (shapes 21-25)
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  legend_keys(shape = "circle_filled", fill = "white", stroke = 1.5)

# Apply to fill aesthetic (e.g., for boxplots)
ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(cyl))) +
  geom_boxplot(alpha = 0.5) +
  legend_keys(alpha = 1, aesthetic = "fill")
```
