# Auto-fit Legend to Plot Height

## Usage

``` r
legend_auto_fit(plot, max_ratio = 0.95)
```

## Arguments

- plot:

  A ggplot object.

- max_ratio:

  Maximum ratio of legend height to panel height before wrapping is
  triggered. Default is 0.95 (95\\

A modified ggplot object with adjusted legend layout. Measures the
legend height relative to the plot panel and automatically wraps the
legend into multiple columns if it would overflow. This function must be
called on a complete ggplot object, not added with `+`. This function
builds the plot to measure actual dimensions, then rebuilds with an
appropriate number of legend rows if the legend is too tall. It's
particularly useful after applying `legend_style(angle = 90)` which can
cause legends to exceed the plot height.Because this requires building
the plot twice, it has a small performance cost. For static plots this
is negligible. library(ggplot2)# Legend with rotated text that might
overflow p \<- ggplot(mpg, aes(displ, hwy, color = class)) +
geom_point() + legend_style(angle = 90)# Auto-fit will wrap if needed
legend_auto_fit(p)
[`legend_style`](https://gcol33.github.io/ggguides/reference/legend_style.md),
[`legend_wrap`](https://gcol33.github.io/ggguides/reference/legend_wrap.md)
