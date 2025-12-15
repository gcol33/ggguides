# Style Legend Appearance

A comprehensive one-liner to style all legend elements consistently.
Instead of setting multiple theme elements separately, use this function
to control text, title, keys, spacing, background, and direction in one
call.

## Usage

``` r
legend_style(
  size = NULL,
  family = NULL,
  face = NULL,
  color = NULL,
  angle = NULL,
  hjust = NULL,
  vjust = NULL,
  title_size = NULL,
  title_face = NULL,
  title_color = NULL,
  title_angle = NULL,
  title_hjust = NULL,
  title_vjust = NULL,
  title_position = NULL,
  key_width = NULL,
  key_height = NULL,
  key_fill = NULL,
  spacing = NULL,
  spacing_x = NULL,
  spacing_y = NULL,
  margin = NULL,
  background = NULL,
  background_color = NULL,
  box_background = NULL,
  box_margin = NULL,
  direction = NULL,
  byrow = NULL
)
```

## Arguments

- size:

  Text size for legend labels (in points).

- family:

  Font family for legend text.

- face:

  Font face for legend text (`"plain"`, `"bold"`, `"italic"`,
  `"bold.italic"`).

- color:

  Text color for legend labels.

- angle:

  Rotation angle for legend labels (in degrees). Useful for long
  category names. Common values: 45 for diagonal, 90 for vertical.

- hjust:

  Horizontal justification for rotated text (0 = left, 0.5 = center, 1 =
  right). Often needed when using `angle`.

- vjust:

  Vertical justification for rotated text (0 = bottom, 0.5 = middle, 1 =
  top). Often needed when using `angle`.

- title_size:

  Text size for legend title (in points). If `NULL`, inherits from
  `size`.

- title_face:

  Font face for legend title. If `NULL`, inherits from `face`.

- title_color:

  Text color for legend title. If `NULL`, inherits from `color`.

- title_angle:

  Rotation angle for legend title (in degrees).

- title_hjust:

  Horizontal justification for rotated title.

- title_vjust:

  Vertical justification for rotated title.

- title_position:

  Position of legend title relative to keys. One of `"top"`, `"bottom"`,
  `"left"`, `"right"`.

- key_width:

  Width of legend keys. Numeric (in cm) or a `unit` object.

- key_height:

  Height of legend keys. Numeric (in cm) or a `unit` object.

- key_fill:

  Background fill color for legend keys.

- spacing:

  Spacing between legend entries. Numeric (in cm) or a `unit` object.

- spacing_x:

  Horizontal spacing between legend entries.

- spacing_y:

  Vertical spacing between legend entries.

- margin:

  Margin around entire legend. Single value (all sides) or vector of 4
  values (top, right, bottom, left) in cm.

- background:

  Legend background fill color. Use `NA` for transparent.

- background_color:

  Legend background border color. Use `NA` for no border.

- box_background:

  Background fill for the box containing multiple legends.

- box_margin:

  Margin around the legend box. Single value or 4-vector in cm.

- direction:

  Legend direction: `"horizontal"` or `"vertical"`.

- byrow:

  For multi-column legends, fill by row (`TRUE`) or by column (`FALSE`).

## Value

A ggplot2 theme object that can be added to a plot.

## See also

[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_wrap`](https://gcol33.github.io/ggguides/reference/legend_wrap.md),
[`legend_reverse`](https://gcol33.github.io/ggguides/reference/legend_reverse.md)

## Examples

``` r
library(ggplot2)

# Simple: consistent font
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_style(size = 12, family = "serif")

# Styled title and keys
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_style(
    size = 10,
    title_size = 14,
    title_face = "bold",
    key_width = 1.5
  )

# Full styling with background
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  legend_style(
    size = 11,
    title_size = 13,
    title_face = "bold",
    key_fill = "grey95",
    background = "white",
    background_color = "grey80",
    margin = 0.3
  )

# Rotated labels for long category names
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_style(angle = 45, hjust = 1)
```
