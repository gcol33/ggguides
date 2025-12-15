# ggguides - Final Feature Set

## Package Philosophy

- **Minimal dependencies**: Only ggplot2 + optional patchwork
- **`+`-composable API**: All functions return theme/guides objects
- **One-liners**: Solve common problems in a single call
- **Theme-based**: Prefer theme modifications over grob manipulation

---

## Exported Functions

### Position Helpers

| Function | Description |
|----------|-------------|
| `legend_left()` | Left position with proper alignment |
| `legend_right()` | Right position with proper alignment |
| `legend_top(align_to)` | Top position, horizontal layout |
| `legend_bottom(align_to)` | Bottom position, horizontal layout |
| `legend_inside(x, y, position)` | Inside plot at coords or "topright" shortcuts |
| `legend_none()` | Remove legend |

### Direction Helpers

| Function | Description |
|----------|-------------|
| `legend_horizontal()` | Horizontal legend direction |
| `legend_vertical()` | Vertical legend direction |

### Style Helpers

| Function | Description |
|----------|-------------|
| `legend_style(...)` | Comprehensive styling: size, family, background, margins, etc. |
| `legend_wrap(ncol, nrow)` | Wrap legend into columns/rows |
| `legend_reverse()` | Reverse legend order |

### Patchwork Integration

| Function | Description |
|----------|-------------|
| `collect_legends(x, position, span)` | Collect legends with optional height spanning |
| `align_guides_h(x, guides)` | Horizontal alignment across plots |

---

## Usage Examples

```r
library(ggplot2)
library(ggguides)

# Position
p + legend_left()
p + legend_inside(position = "topright")

# Style
p + legend_style(size = 12, family = "serif", title_face = "bold")
p + legend_wrap(ncol = 2)

# Patchwork (requires patchwork package)
library(patchwork)
collect_legends(p1 / p2, position = "right", span = TRUE)
```

---

## What We Don't Do (Use Other Packages)

| Need | Recommendation |
|------|----------------|
| cowplot legend extraction | `lemon::g_legend()` |
| cowplot shared legends | `lemon::grid_arrange_shared_legend()` |
| Complex grob manipulation | `lemon::reposition_legend()` |
| Custom guide types | ggplot2 `guide_*()` functions |

---

## Dependencies

- **Imports**: ggplot2, rlang
- **Suggests**: patchwork, testthat

No cowplot dependency. Users needing cowplot integration should use the lemon package.
