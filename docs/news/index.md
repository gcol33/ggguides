# Changelog

## ggguides (development version)

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
