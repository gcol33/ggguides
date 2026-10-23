
# ggguides

*rearranging the legends on a ggplot*

<!-- badges: start -->

[![R-CMD-check](https://github.com/gcol33/ggguides/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/gcol33/ggguides/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/gcol33/ggguides/graph/badge.svg)](https://app.codecov.io/gh/gcol33/ggguides)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CRAN
status](https://www.r-pkg.org/badges/version/ggguides)](https://CRAN.R-project.org/package=ggguides)
<!-- badges: end -->

ggguides places, styles and combines the legends of
[ggplot2](https://ggplot2.tidyverse.org) plots with named functions,
such as `legend_left()`, `legend_inside()` or `legend_style()`, each
added to a plot with `+`.

Each function sets the ggplot2 theme and guide options that belong to
one change together, for a legend on the left its position, its
justification and the alignment of the legend boxes, and returns an
ordinary ggplot2 component that combines with the rest of the plot’s
theme. For layouts of several plots, `collect_legends()` and
`shared_legend()` edit the gtable, the table of graphical objects that
ggplot2 draws, so that one legend remains. You choose where each legend
goes and how it looks, one aesthetic at a time when a plot has several.
ggguides supports:

- **Placement.** `legend_left()`, `legend_right()`, `legend_top()` and
  `legend_bottom()` move the legend to a side,
  [`legend_inside()`](https://gillescolling.com/ggguides/reference/legend_inside.html)
  into a corner or to `x`/`y` coordinates, and `legend_none()` removes
  it.
- **Styling.**
  [`legend_style()`](https://gillescolling.com/ggguides/reference/legend_style.html)
  sets size, font, background, border and margins. `legend_wrap()`
  arranges the keys in columns or rows, `legend_reverse()` and
  `legend_order()` set the order of the entries, and `colorbar_style()`
  styles continuous scales.
- **Several legends on one plot.** The `by` argument of every placement
  and style function targets one aesthetic. `legend_hide()` and
  `legend_select()` drop or keep legends by aesthetic, and
  `legend_order_guides()` sets their order.
- **One legend for several plots.** `collect_legends()` and
  `collect_axes()` remove duplicates from a
  [patchwork](https://patchwork.data-imaginist.com) layout,
  `shared_legend()` arranges plots with one legend without patchwork,
  and `get_legend()` extracts a legend for
  [cowplot](https://wilkelab.org/cowplot/) or grid.

## Installation

``` r
install.packages("ggguides")
```

Development version:

``` r
# install.packages("pak")
pak::pak("gcol33/ggguides")
```

## Usage

1.  Build the plot with ggplot2.
2.  Add a placement function such as `legend_left()` or
    `legend_inside()`.
3.  Add `legend_style()` to change how the legend looks.

``` r
library(ggplot2)
library(ggguides)

p <- ggplot(mtcars, aes(mpg, wt, colour = factor(cyl))) +
  geom_point(size = 3)
p + legend_left()
```

<img src="man/figures/README-left-1.svg" alt="Scatter plot of car weight against fuel economy from mtcars, points coloured by number of cylinders, with the colour legend on the left of the panel." width="100%" />

Inside the panel, a corner is named with `position`, and the style is
added as a further layer:

``` r
p +
  legend_inside(position = "topright") +
  legend_style(size = 18, title_face = "bold")
```

<img src="man/figures/README-inside-1.svg" alt="The same scatter plot with the colour legend inside the panel in the top-right corner, its title in bold and its text larger." width="100%" />

## Compared with theme()

In ggplot2, a legend on the left with its keys aligned at the top takes
three `theme()` arguments. `legend_left()` sets them together:

``` r
p + theme(legend.position = "left",
          legend.justification.left = "top",
          legend.box.just = "left")

p + legend_left(justification = "top")
```

## Several legends on one plot

A plot with several aesthetics has one legend per aesthetic. The `by`
argument places or styles one of them and leaves the others as they are:

``` r
q <- ggplot(mtcars, aes(mpg, wt, colour = factor(cyl), size = hp)) +
  geom_point()
q + legend_top(by = "colour") + legend_right(by = "size")
```

<img src="man/figures/README-by-1.svg" alt="Scatter plot of car weight against fuel economy with points coloured by cylinders and sized by horsepower; the colour legend is above the panel and the size legend to its right." width="100%" />

Calls with `by` add up, one line per legend and setting. [Multiple
Legends](https://gillescolling.com/ggguides/articles/multiple-legends.html#six-legends-stacked-per-side)
builds this plot with six legends, two on top, two on the right, one at
the bottom and one on the left:

<img src="man/figures/README-six-legends-1.svg" alt="Scatter plot of car weight against fuel economy with six legends: colour and fill above the panel, size and transparency on the right, shape below and line type on the left." width="100%" />

## One legend for several plots

A patchwork layout repeats the legend of each plot. `collect_legends()`
keeps one, and `span = TRUE` stretches it along the full height of
stacked plots:

``` r
library(patchwork)

p1 <- ggplot(mtcars, aes(mpg, wt, colour = factor(cyl))) + geom_point()
p2 <- ggplot(mtcars, aes(mpg, hp, colour = factor(cyl))) + geom_point()
p3 <- ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) + geom_point()
stacked <- (p1 / p2 / p3) + plot_layout(heights = c(2, 1.5, 1))

gt <- collect_legends(stacked, position = "right", span = TRUE)
grid::grid.draw(gt)
```

<img src="man/figures/README-collect-1.svg" alt="Three scatter plots of mtcars stacked vertically, of weight, horsepower and displacement against fuel economy, with one colour legend for cylinders on the right spanning all three panels." width="100%" />

With `span = 1:2` the legend sits beside rows 1 and 2 only. Without
patchwork, `shared_legend(p1, p2, p3, ncol = 1, position = "bottom")`
arranges the plots with one legend. [Patchwork
Integration](https://gillescolling.com/ggguides/articles/patchwork.html)
covers both, along with collected axes and cowplot.

## Documentation

Start with [Getting Started with
ggguides](https://gillescolling.com/ggguides/articles/getting-started.html):
placing, styling and wrapping a legend, and combining the functions on
one plot.

- [Legend
  Positioning](https://gillescolling.com/ggguides/articles/positioning.html):
  the four sides, positions inside the panel, direction and removing the
  legend.
- [Styling &
  Customization](https://gillescolling.com/ggguides/articles/styling.html):
  fonts, text rotation, backgrounds, borders, key size, wrapping, entry
  order and colour bars.
- [Multiple
  Legends](https://gillescolling.com/ggguides/articles/multiple-legends.html):
  hiding, selecting, ordering, merging and placing legends per
  aesthetic.
- [Patchwork
  Integration](https://gillescolling.com/ggguides/articles/patchwork.html):
  one legend and shared axes across a layout of plots.
- [Full reference](https://gillescolling.com/ggguides/reference/): every
  function, grouped by job.

## Getting help

Questions and bug reports go to the [GitHub
issues](https://github.com/gcol33/ggguides/issues). A bug report is
easiest to act on with a small reproducible example, for instance made
with [reprex](https://reprex.tidyverse.org/).

## Support

> “Software is like sex: it’s better when it’s free.” — Linus Torvalds

I’m a PhD student who builds R packages in my free time because I
believe good tools should be free and open. I started these projects for
my own work and figured others might find them useful too.

If this package saved you some time, buying me a coffee is a nice way to
say thanks. It helps with my coffee addiction.

[![Buy Me A
Coffee](https://img.shields.io/badge/-Buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/gcol33)

## Acknowledgements

ggguides sets options of [ggplot2](https://ggplot2.tidyverse.org) and
edits the plots it draws with [gtable](https://gtable.r-lib.org);
multi-plot layouts come from
[patchwork](https://patchwork.data-imaginist.com).

## License

ggguides is licensed under MIT.

## Citation

``` text
Colling G (2026). _ggguides: Simplified Legend and Guide Alignment for
ggplot2_. doi:10.32614/CRAN.package.ggguides
<https://doi.org/10.32614/CRAN.package.ggguides>. R package version
1.1.10, <https://gillescolling.com/ggguides/>.
```

BibTeX:

``` bibtex
@Manual{colling2026ggguides,
  title = {ggguides: Simplified Legend and Guide Alignment for ggplot2},
  author = {Gilles Colling},
  year = {2026},
  note = {R package version 1.1.10},
  doi = {10.32614/CRAN.package.ggguides},
  url = {https://gillescolling.com/ggguides/},
}
```

Download the citation as
[BibTeX](https://gillescolling.com/ggguides/ggguides.bib) or
[RIS](https://gillescolling.com/ggguides/ggguides.ris).
