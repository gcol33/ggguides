# Style Continuous Color Bar Legends

Customize the appearance of color bar legends for continuous scales.
This provides a simpler interface to
[`guide_colourbar()`](https://ggplot2.tidyverse.org/reference/guide_colourbar.html).

## Usage

``` r
colorbar_style(
  width = NULL,
  height = NULL,
  ticks = NULL,
  ticks_length = NULL,
  frame = NULL,
  frame_linewidth = NULL,
  label = NULL,
  label_position = NULL,
  title_position = NULL,
  direction = NULL,
  reverse = NULL,
  nbin = NULL,
  aesthetic = "colour"
)

colourbar_style(
  width = NULL,
  height = NULL,
  ticks = NULL,
  ticks_length = NULL,
  frame = NULL,
  frame_linewidth = NULL,
  label = NULL,
  label_position = NULL,
  title_position = NULL,
  direction = NULL,
  reverse = NULL,
  nbin = NULL,
  aesthetic = "colour"
)
```

## Arguments

- width:

  Numeric. Width of the color bar in lines. Default is 1.

- height:

  Numeric. Height of the color bar in lines. Default is 5.

- ticks:

  Logical. Whether to show tick marks. Default is TRUE.

- ticks_length:

  Numeric. Length of tick marks in lines. Default is 0.2.

- frame:

  Logical or character. If TRUE, draws a black frame. If a color string,
  draws a frame in that color. If FALSE or NULL, no frame. Default is
  FALSE.

- frame_linewidth:

  Numeric. Line width of the frame. Default is 0.5.

- label:

  Logical. Whether to show labels. Default is TRUE.

- label_position:

  Character. Position of labels: "right", "left", "top", or "bottom".
  Default depends on bar orientation.

- title_position:

  Character. Position of title: "top", "bottom", "left", or "right".
  Default is "top".

- direction:

  Character. Direction of the bar: "vertical" or "horizontal". Default
  is "vertical".

- reverse:

  Logical. Whether to reverse the color bar. Default is FALSE.

- nbin:

  Integer. Number of bins used to draw the color bar. Higher values give
  smoother gradients. Default is 300.

- aesthetic:

  Character. Which aesthetic to apply to. Default is "colour". Common
  values: "colour", "color", "fill".

## Value

A ggplot2 guides specification.

## Details

This function simplifies common color bar customizations:

- **Size**: Use `width` and `height` to make thin/wide bars

- **Ticks**: Toggle with `ticks`, adjust length with `ticks_length`

- **Frame**: Add a border with `frame = TRUE` or `frame = "grey50"`

- **Orientation**: Use `direction = "horizontal"` for horizontal bars

The function uses the theme system internally, which is the recommended
approach in ggplot2 3.5.0+.

## See also

[`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md)
for styling discrete legends,
[`legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md),
[`legend_bottom`](https://gcol33.github.io/ggguides/reference/legend_bottom.md)
for positioning.

## Examples

``` r
library(ggplot2)

p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile()

# Default appearance
p

# Taller, thinner bar
p + colorbar_style(width = 0.5, height = 10, aesthetic = "fill")

# Wide horizontal bar
p + colorbar_style(width = 10, height = 0.5, direction = "horizontal",
                   aesthetic = "fill")

# With frame and no ticks
p + colorbar_style(frame = "grey50", ticks = FALSE, aesthetic = "fill")

# Thin bar with frame
p + colorbar_style(width = 0.5, height = 8, frame = TRUE, aesthetic = "fill")
```
