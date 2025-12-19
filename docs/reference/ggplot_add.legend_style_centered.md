# Add legend_style_centered to ggplot

Add legend_style_centered to ggplot

## Usage

``` r
# S3 method for class 'legend_style_centered'
ggplot_add(object, plot, ...)
```

## Arguments

- object:

  A legend_style_centered object

- plot:

  A ggplot object

- ...:

  Additional arguments (ignored)

## Value

A modified ggplot object with additional class `gg_centered_title` or
`gg_autofit_legend` (for 90-degree rotation), used to trigger custom
rendering behavior.
