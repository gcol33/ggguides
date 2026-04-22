# Changelog

## ggguides 1.1.6

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
