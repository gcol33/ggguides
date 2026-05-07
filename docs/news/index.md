# Changelog

## ggguides 1.1.10

### Bug Fixes

- `legend_style(by = <aes>, justification = ...)` collided when two or
  more legends shared the same edge. The 1.1.9 fix routed each call to a
  single global `theme(legend.justification.<side> = ...)`, so the
  second call overwrote the first —
  `legend_style(by = "colour", justification = "left") + legend_style(by = "fill", justification = "right")`
  on the top edge ended up with both legends pinned to the right.
  Per-legend justification now also stashes the requested rail position
  on the plot and rewrites the `guide-box-<side>` internal gtable at
  render time so each legend sits at its own fraction of the rail. The
  render-time path also reorders the guides so the gtable cell order
  matches the requested rail order. The global theme write is kept as a
  fallback for the single-legend case. (reported by Youtao)

### Internal

- The render-time gtable post-processor checks ggplot2’s guide-box
  layout shape (column count and pad-cell unit type) and falls back to
  the previous behavior with a one-shot warning if it doesn’t match what
  ggguides was tested against (currently ggplot2 4.0.3) — so a future
  ggplot2 internal change degrades gracefully instead of producing wrong
  output.

- If a guide already has an explicit `guide_legend(order = N)` set,
  per-legend justification reordering on that side is skipped and a
  warning is emitted, so the user-supplied order is never silently
  overwritten.

## ggguides 1.1.9

### Bug Fixes

- `legend_style(by = <aes>, justification = ...)` had no visible effect.
  The update attached the justification to the guide’s embedded theme
  via `guide_legend(theme = theme(legend.justification.<side> = ...))`,
  but ggplot2 \>= 3.5 does not consult the side-specific justification
  elements inside a guide’s embedded theme — only the whole-plot theme
  is read. Legends stayed centered along their rail regardless of the
  `justification` value. The NEWS entry for 1.1.5 that introduced this
  argument was therefore incorrect: the workaround Youtao documented,
  `theme(legend.justification.<side> = ...)`, was the only thing that
  actually worked. 1.1.9 fixes this by routing per-guide `justification`
  to a whole-plot theme element keyed on the guide’s resolved side, so
  `legend_top(by = "colour") + legend_style(by = "colour", justification = "left")`
  now slides the colour legend to the left end of the top rail as
  documented. If you had a `theme(legend.justification.<side> = ...)`
  workaround in your code, you can remove it. (reported by Youtao)

- `legend_style(justification = ...)` without `by` was writing to the
  generic `legend.justification`, which ggplot2 coerces per axis and
  mis-maps mixed-axis scalars (e.g., `"left"` on a vertical rail becomes
  `0` — bottom). It now writes to the side-specific theme elements
  (`legend.justification.top`/`.bottom` for horizontal scalars;
  `legend.justification.left`/`.right` for vertical scalars; all four
  for `"center"` and numerics).

## ggguides 1.1.8

### Bug Fixes

- [`legend_left()`](https://gcol33.github.io/ggguides/reference/legend_left.md),
  [`legend_right()`](https://gcol33.github.io/ggguides/reference/legend_right.md),
  [`legend_top()`](https://gcol33.github.io/ggguides/reference/legend_top.md),
  and
  [`legend_bottom()`](https://gcol33.github.io/ggguides/reference/legend_bottom.md)
  were writing to `legend.justification`, the generic fallback element.
  In ggplot2 \>= 3.5.0 each side has its own element —
  `legend.justification.left`, `legend.justification.right`,
  `legend.justification.top`, `legend.justification.bottom` — and the
  generic fallback is silently coerced per axis.
  [`legend_left()`](https://gcol33.github.io/ggguides/reference/legend_left.md)
  in particular was sending `"left"` to a vertical rail, which ggplot2
  coerced to `0` (bottom), so the legend was actually pinned to the
  bottom of the left edge when users expected it centered. The four side
  functions now write to the side-specific element and default to
  `"center"`, which is what the documentation has always described.
  (reported by Youtao)

### New Features

- [`legend_left()`](https://gcol33.github.io/ggguides/reference/legend_left.md),
  [`legend_right()`](https://gcol33.github.io/ggguides/reference/legend_right.md),
  [`legend_top()`](https://gcol33.github.io/ggguides/reference/legend_top.md),
  and
  [`legend_bottom()`](https://gcol33.github.io/ggguides/reference/legend_bottom.md)
  gain a `justification` argument. It slides the legend along its rail:
  `"top"`/`"center"`/`"bottom"` (or a number in `[0, 1]`) for
  left/right, `"left"`/`"center"`/`"right"` for top/bottom. This is the
  side-legend counterpart to `legend_inside(justification = ...)`. For
  per-guide control when several legends sit on different sides, keep
  using `legend_style(by = ..., justification = ...)`.

### Documentation

- [`?legend_left`](https://gcol33.github.io/ggguides/reference/legend_left.md)
  (and the three siblings) now explain the “rail” semantics and note the
  naming asymmetry with
  [`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md):
  on a side, the justification keyword refers to where the legend sits
  along the panel edge; inside, it refers to which corner of the legend
  anchors to the `(x, y)` position.

## ggguides 1.1.7

### Bug Fixes

- `legend_inside(justification = ...)` had no visible effect because the
  function was writing to `legend.justification` — the theme element
  that anchors side legends. In ggplot2 \>= 3.5.0 the anchor for
  `legend.position = "inside"` is a separate element,
  `legend.justification.inside`.
  [`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md)
  now writes to that element, so the `justification` argument (and the
  justifications implied by `position = "topright"`, `"bottomleft"`,
  etc.) move the legend as documented. Users who had been working around
  the bug with `theme(legend.justification = ...)` should remove that
  override. (reported by Youtao)

## ggguides 1.1.6

CRAN release: 2026-04-23

### Bug Fixes

- `legend_*(by = <aes>)` and `legend_style(by = <aes>)` now compose
  correctly when chained for the same aesthetic. Previously, each call
  built a fresh
  [`guide_legend()`](https://ggplot2.tidyverse.org/reference/guide_legend.html)
  that replaced the prior one, so
  `legend_top(by = "colour") + legend_style(by = "colour", margin = ...)`
  silently reset the colour legend’s position back to the plot default.
  The per-aesthetic helpers now return a ggguides update object whose
  `ggplot_add` method merges new params into the existing guide. This
  fixes the “Four Legends, One per Side” vignette example. (reported by
  Youtao)

### API Consistency

- [`legend_inside()`](https://gcol33.github.io/ggguides/reference/legend_inside.md):
  renamed `just` argument to `justification` for consistency with
  `legend_style(justification = ...)` and ggplot2’s
  `legend.justification` theme element. The old `just` name still works
  but emits a deprecation warning.

## ggguides 1.1.5

CRAN release: 2026-04-22

### New Features

- [`legend_style()`](https://gcol33.github.io/ggguides/reference/legend_style.md)
  gains a `justification` argument. With `by = NULL` it sets
  `legend.justification` globally; with `by = "<aes>"` it slides a
  single legend along its side via `guide_legend(theme = ...)`. Useful
  when four legends sit on four different sides and each needs its own
  alignment.

### Documentation

- `multiple-legends` vignette: added a “Four Legends, One per Side”
  section showing per-legend side, justification, and margin adjustments
  together.

## ggguides 1.1.4

CRAN release: 2026-01-09

### Documentation

- Replaced `\donttest{}` with `if(requireNamespace())` conditionals for
  examples using suggested packages

### Testing

- Increased test coverage to 95%+
- Added CI workflows and Codecov integration

## ggguides 1.1.3

### Maintenance

- Removed dev files from repository (CLAUDE.md, FEATURES.md, ROADMAP.md,
  build_site.R)

## ggguides 1.1.2

### Bug Fixes

- Fixed
  [`get_legend()`](https://gcol33.github.io/ggguides/reference/get_legend.md)
  returning empty grob with ggplot2 3.5.0+ (guide-box naming changed to
  position-specific names like “guide-box-right”)

## ggguides 1.1.1

### Documentation

- Added missing example images to README for Multiple Legends and
  cowplot/Grid sections

## ggguides 1.1.0

### CRAN Submission

- Added `@return` documentation to all S3 methods (ggplot_add, print,
  plot, and ggplotGrob methods)
- Changed `\dontrun{}` to `\donttest{}` in examples that require
  suggested packages

### Documentation

- [`legend_keys()`](https://gcol33.github.io/ggguides/reference/legend_keys.md):
  Added detailed documentation explaining how to use filled shapes
  (21-25) with different outline/fill color combinations. Clarified that
  “colored fill with black outline” requires mapping both `color` and
  `fill` aesthetics in the original plot
  ([\#1](https://github.com/gcol33/ggguides/issues/1)).

- Added new example showing correct usage for colored fills with black
  outlines.
