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

  Numeric or character. Shape of point keys.

- linewidth:

  Numeric. Width of line keys.

- linetype:

  Character or numeric. Line type for line keys.

- fill:

  Character. Fill color for keys (e.g., bar charts).

- colour, color:

  Character. Outline/stroke color for keys.

- stroke:

  Numeric. Stroke width for point keys.

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

- Standardizing key appearance across different geoms

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


# Combine modifications
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(alpha = 0.3, size = 1) +
  legend_keys(size = 4, alpha = 1)


# Apply to fill aesthetic (e.g., for boxplots)
ggplot(mtcars, aes(factor(cyl), mpg, fill = factor(cyl))) +
  geom_boxplot(alpha = 0.5) +
  legend_keys(alpha = 1, aesthetic = "fill")

```
