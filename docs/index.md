# ggguides

Simplified legend and guide alignment for ggplot2.

## Installation

``` r

# Install from GitHub
# install.packages("pak")
pak::pak("gcol33/ggguides")
```

## Overview

ggguides provides one-liner functions for common legend operations in
ggplot2:

- **Position**:
  [`legend_left()`](https://gcol33.github.io/ggguides/reference/legend_left.md),
  [`legend_right()`](https://gcol33.github.io/ggguides/reference/legend_right.md),
  [`legend_top()`](https://gcol33.github.io/ggguides/reference/legend_top.md),
  [`legend_bottom()`](https://gcol33.github.io/ggguides/reference/legend_bottom.md),
  [`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md),
  [`legend_none()`](https://gcol33.github.io/ggguides/reference/legend_none.md)
- **Direction**:
  [`legend_horizontal()`](https://gcol33.github.io/ggguides/reference/legend_horizontal.md),
  [`legend_vertical()`](https://gcol33.github.io/ggguides/reference/legend_vertical.md)
- **Style**:
  [`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md),
  [`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md),
  [`legend_reverse()`](https://gcol33.github.io/ggguides/reference/legend_reverse.md)
- **Patchwork**:
  [`collect_legends()`](https://gcol33.github.io/ggguides/reference/collect_legends.md),
  [`align_guides_h()`](https://gcol33.github.io/ggguides/reference/align_guides_h.md)

## Examples

### Position Helpers

``` r

library(ggplot2)
library(ggguides)

p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(color = "Cylinders")
```

#### `legend_left()` / `legend_right()`

Position with proper alignment (sets justification and box.just
together):

``` r

p + legend_left()
p + legend_right()
```

![](reference/figures/legend_left.png)![](reference/figures/legend_right.png)

#### `legend_top()` / `legend_bottom()`

Horizontal layout with optional plot alignment:

``` r

p + legend_top()
p + legend_bottom()

# Align to full plot (useful with titles)
p + labs(title = "My Title") + legend_top(align_to = "plot")
```

![](reference/figures/legend_top.png)![](reference/figures/legend_bottom.png)

#### `legend_inside()`

Position inside the plot using coordinates or shortcuts:

``` r

# Using shortcuts
p + legend_inside(position = "topright")
p + legend_inside(position = "bottomleft")

# Using coordinates
p + legend_inside(x = 0.95, y = 0.95, just = c("right", "top"))

# With custom styling
p + legend_inside(position = "center", background = "grey95", border = "grey50")
```

![](reference/figures/legend_inside_topright.png)![](reference/figures/legend_inside_bottomleft.png)

#### `legend_none()`

Remove the legend entirely:

``` r

p + legend_none()
```

![](reference/figures/legend_none.png)

------------------------------------------------------------------------

### Style Helpers

#### `legend_style()`

Comprehensive styling in one call:

``` r

# Change font size - affects both title and labels
p + legend_style(size = 14)

# Change font family
p + legend_style(family = "serif")
p + legend_style(family = "mono")

# Combine size and family
p + legend_style(size = 14, family = "serif")
```

![](reference/figures/legend_style_size.png)![](reference/figures/legend_style_font.png)

``` r

# Full styling with title emphasis
p + legend_style(
  size = 12,
  title_size = 14,
  title_face = "bold",
  key_width = 1.5,
  background = "grey95",
  background_color = "grey70",
  margin = 0.3
)
```

![](reference/figures/legend_style_full.png)

#### `legend_wrap()`

Wrap legend entries into columns or rows:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2)

# Or by rows
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(nrow = 2)
```

![](reference/figures/legend_wrap_ncol2.png)![](reference/figures/legend_wrap_nrow2.png)

#### `legend_reverse()`

Reverse legend entry order:

``` r

p + legend_reverse()
```

![](reference/figures/legend_reverse.png)

------------------------------------------------------------------------

### Patchwork Integration

#### `collect_legends()`

Collect legends from patchwork compositions:

``` r

library(patchwork)

p1 <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 1")
p2 <- ggplot(mtcars, aes(mpg, hp, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 2")

# Without collection (duplicate legends)
p1 | p2

# With collection
collect_legends(p1 | p2)

# Position at bottom
collect_legends(p1 | p2, position = "bottom")
```

![](reference/figures/patchwork_no_collect.png)

![](reference/figures/patchwork_collect.png)

#### Height Spanning

For stacked plots, use `span = TRUE` to make the legend span the full
height:

``` r

p3 <- ggplot(mtcars, aes(mpg, disp, color = factor(cyl))) +
  geom_point() + labs(title = "Plot 3")

# Default: legend centered
collect_legends(p1 / p2 / p3, position = "right")

# With spanning: legend fills full height
gt <- collect_legends(p1 / p2 / p3, position = "right", span = TRUE)
grid::grid.draw(gt)
```

![](reference/figures/patchwork_stacked_default.png)![](reference/figures/patchwork_stacked_span.png)

#### Row-Specific Attachment

Attach the legend to specific rows instead of spanning all:

``` r

# Attach legend to row 1 only
gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1)
grid::grid.draw(gt)

# Attach legend to rows 1 and 2
gt <- collect_legends(p1 / p2 / p3, position = "right", span = 1:2)
grid::grid.draw(gt)
```

![](reference/figures/patchwork_span_row1.png)![](reference/figures/patchwork_span_row12.png)

------------------------------------------------------------------------

### Combining Functions

Functions compose naturally:

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_left() +
  legend_style(size = 12, title_face = "bold", background = "grey95")
```

![](reference/figures/combined_left_styled.png)

``` r

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  legend_wrap(ncol = 2) +
  legend_bottom()
```

![](reference/figures/combined_wrap_bottom.png)

------------------------------------------------------------------------

## cowplot Users

For cowplot, we recommend the
[lemon](https://github.com/stefanedwards/lemon) package which provides:

- `g_legend()` - extract legend as grob
- `grid_arrange_shared_legend()` - combine plots with shared legend
- `reposition_legend()` - place legend inside panels

ggguides functions like
[`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md),
[`legend_wrap()`](https://gcol33.github.io/ggguides/reference/legend_wrap.md),
and position helpers work on individual plots regardless of layout
package.

## License

MIT
