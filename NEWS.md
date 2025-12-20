# ggguides 1.1.3

## Maintenance

* Removed dev files from repository (CLAUDE.md, FEATURES.md, ROADMAP.md, build_site.R)

# ggguides 1.1.2

## Bug Fixes

* Fixed `get_legend()` returning empty grob with ggplot2 3.5.0+ (guide-box naming changed to position-specific names like "guide-box-right")

# ggguides 1.1.1

## Documentation

* Added missing example images to README for Multiple Legends and cowplot/Grid sections

# ggguides 1.1.0

## CRAN Submission

* Added `@return` documentation to all S3 methods (ggplot_add, print, plot, and ggplotGrob methods)
* Changed `\dontrun{}` to `\donttest{}` in examples that require suggested packages

## Documentation

* `legend_keys()`: Added detailed documentation explaining how to use filled shapes (21-25) with different outline/fill color combinations. Clarified that "colored fill with black outline" requires mapping both `color` and `fill` aesthetics in the original plot (#1).

* Added new example showing correct usage for colored fills with black outlines.
