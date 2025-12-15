# Claude Instructions for ggguides

## Project Overview

ggguides is an R package that simplifies legend and guide alignment in
ggplot2, with special focus on multi-panel workflows using patchwork and
cowplot.

## Repository

<https://github.com/gcol33/ggguides>

## Design Principles

1.  **Minimal API surface**: Only export functions that solve real
    problems
2.  **Theme-based over grob-based**: Prefer ggplot2 theme modifications
    for stability across versions
3.  **Patchwork-first**: Primary integration target is patchwork;
    cowplot has documented limitations
4.  **CRAN-ready**: All code must pass R CMD check with no warnings or
    notes

## Package Structure

    R/
    ├── ggguides-package.R   # Package-level docs and imports
    ├── legend_position.R    # legend_left()
    ├── legend_wrap.R        # legend_wrap()
    ├── collect_legends.R    # collect_legends()
    └── align_guides.R       # align_guides_h()

    tests/testthat/
    ├── test-legend_position.R
    ├── test-legend_wrap.R
    ├── test-collect_legends.R
    └── test-align_guides.R

## Code Style

Follow the style established in the corrselect package:

- Use roxygen2 with markdown enabled
- Use `\code{\link{}}` for internal cross-references
- Use `\code{\link[pkg]{fun}}` for external package references
- Error messages should end with a period
- Use `inherits(x, "class")` for class checking
- Use `stop(..., call. = FALSE)` for user-facing errors
- Include `@seealso` tags linking to related functions

## Testing Guidelines

- One `test_that()` block per logical test case
- Test error conditions first, then success cases
- Use `skip_if_not_installed("patchwork")` for patchwork-dependent tests
- Each exported function needs at least 2 tests

## Dependencies

- **Imports** (required): ggplot2, grid, gtable, rlang
- **Suggests** (optional): patchwork, cowplot, testthat

Use
[`rlang::check_installed()`](https://rlang.r-lib.org/reference/is_installed.html)
to provide helpful errors when optional packages are missing.

## Building and Checking

``` r

# Generate documentation
devtools::document()

# Run tests
devtools::test()

# Full R CMD check
devtools::check()
```

## Common Tasks

### Adding a new function

1.  Create `R/function_name.R` with roxygen2 documentation
2.  Include `@export` tag
3.  Add `@seealso` linking to related functions
4.  Create `tests/testthat/test-function_name.R` with at least 2 tests
5.  Run
    [`devtools::document()`](https://devtools.r-lib.org/reference/document.html)
    to update NAMESPACE

### Updating documentation

1.  Edit roxygen2 comments in R files
2.  Run
    [`devtools::document()`](https://devtools.r-lib.org/reference/document.html)
3.  Check rendered help with `?function_name`

## Scope Limits

Do NOT: - Create themes, palettes, or layout systems - Add extensive
configuration options (prefer robust defaults) - Duplicate functionality
that patchwork/cowplot already does well - Work directly with grobs
unless absolutely necessary
