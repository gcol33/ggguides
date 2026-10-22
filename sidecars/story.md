# Story: ggguides

## Claim
Named one-line functions for placing, styling and combining ggplot2 legends, including one legend across patchwork layouts.

## Audience
ggplot2 users who know `theme()` and `guides()` exist but look up the legend arguments each time, and who build multi-panel figures with patchwork or cowplot.

## Relation
- to: ggplot2 (sets its theme and guide options; edits the drawn gtable), patchwork (multi-plot layouts)
- phrase: none fixed yet; README says it "places, styles and combines the legends of ggplot2 plots"
- same: every function returns an ordinary ggplot2 component
- home: README, Compared with theme(); Getting Started with ggguides

## Arcs

### A1 Named verbs over theme() arguments
- question: "which theme() arguments move my legend?"
- answer: one function per change, setting the related options together
- home: Legend Positioning
- also: README (Usage, Compared with theme())

### A2 Styling
- answer: `legend_style()`, `legend_wrap()`, `legend_order()`, `legend_reverse()`, `legend_keys()`, `colorbar_style()`
- home: Styling & Customization
- also: README supports list

### A3 Several legends on one plot
- answer: `by` argument per aesthetic; hide, select, order, merge, split
- home: Multiple Legends
- also: README (Several legends on one plot)

### A4 One legend for several plots
- answer: `collect_legends()` (with `span`), `collect_axes()`, `shared_legend()`, `get_legend()`
- limits: `span` other than FALSE returns a gtable drawn with `grid::grid.draw()`
- home: Patchwork Integration
- also: README (One legend for several plots)

## Documents
- DESCRIPTION: claim, A4
- README / landing: claim, first placement, one section per A1, A3, A4, routing
- Getting Started with ggguides: tutorial
- Legend Positioning, Styling & Customization, Multiple Legends, Patchwork Integration: one arc each

## Open
- `_pkgdown.yml` url is https://gcol33.github.io/ggguides/ while DESCRIPTION URL and the README links use https://gillescolling.com/ggguides/.
