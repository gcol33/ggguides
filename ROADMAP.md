# ggguides Roadmap: Comprehensive Guide Toolkit

## Vision

Expand ggguides from a legend-focused package to a **comprehensive guide toolkit** that simplifies all common guide operations in ggplot2 - legends, colorbars, and axes.

## Phase 1: Legend Enhancements (Priority)

### 1.1 Legend Order Control
**Pain point:** Multiple competing methods to reorder legends (factor levels, breaks, guide_legend, forcats)

```r
# Simple reordering
legend_order(c("C", "B", "A"))
legend_order(rev)
legend_order(sort)

# Already have legend_reverse() - keep as-is
```

### 1.2 Legend Key Appearance
**Pain point:** `override.aes` syntax is clunky

```r
# Simpler override.aes wrapper
legend_keys(
  size = 4,
  alpha = 1,
  shape = 16,
  linewidth = 1.5
)
```

### 1.3 Legend Merge Helper
**Pain point:** Legends split unexpectedly when modifying aesthetics

```r
# Force legends to merge by syncing names
legend_merge(color, fill)  # uses NSE
legend_merge("color", "fill", "shape")  # or strings
```

## Phase 2: Colorbar Helpers

### 2.1 Colorbar Styling
**Pain point:** Complex syntax for simple customizations

```r
colorbar_style(
  width = 0.5,        # lines

height = 10,        # lines
  ticks = TRUE,
  ticks_length = 0.2,
  frame = "grey50",   # or NULL for none
  frame_linewidth = 0.5
)

# Quick presets
colorbar_thin()
colorbar_wide()
```

### 2.2 Colorbar Position
**Pain point:** Same positioning issues as discrete legends

```r
# Reuse existing position helpers - they should work for colorbars too
# May need internal adjustments to handle guide_colorbar
```

## Phase 3: Axis Guide Helpers

### 3.1 Minor Ticks
**Pain point:** Verbose syntax for common operation

```r
axis_minor_ticks(n = 5)  # number of minor ticks between major
axis_minor_ticks(x = TRUE, y = FALSE)  # selective
```

### 3.2 Capped Axes
**Pain point:** Axis line extends to panel edge by default

```r
axis_cap()  # cap both axes
axis_cap(x = TRUE, y = FALSE)
axis_cap(cap = "both")  # or "upper", "lower"
```

### 3.3 Label Overlap Solutions
**Pain point:** `n.dodge` is trial-and-error, `check.overlap` is crude

```r
axis_dodge(n = 2)  # stagger labels into n rows
axis_angle(45)  # rotate with smart hjust/vjust
axis_angle(90, hjust = 1)  # explicit control
axis_overlap_hide()  # cleaner name for check.overlap
```

### 3.4 Axis Text Styling
**Pain point:** Must use theme() with element_text()

```r
axis_text_style(
  size = 10,
  color = "grey30",
  face = "bold",
  x = TRUE, y = FALSE  # selective
)
```

## Implementation Plan

### Batch 1 (Core) - Implement First
- [x] `legend_order()`
- [x] `legend_keys()`
- [x] Update vignettes

### Batch 2 (Colorbar)
- [x] `colorbar_style()`
- [x] Ensure position helpers work with colorbars
- [x] Add colorbar vignette section

### Batch 3 (Axes)
- [ ] `axis_minor_ticks()`
- [ ] `axis_cap()`
- [ ] `axis_dodge()`
- [ ] `axis_angle()`
- [ ] Add axes vignette

### Batch 4 (Polish)
- [ ] `legend_merge()` - complex, may require careful design
- [ ] Comprehensive testing
- [ ] Update all documentation

## Design Principles

1. **One function, one job** - Each function does exactly one thing
2. **Sensible defaults** - Works out of the box, customizable when needed
3. **Composable** - All functions work together with `+`
4. **Discoverable** - Consistent naming (`legend_*`, `colorbar_*`, `axis_*`)
5. **Non-breaking** - New features don't change existing behavior

## API Summary

```r
# Legends (existing)
legend_left(), legend_right(), legend_top(), legend_bottom()
legend_inside(), legend_none()
legend_horizontal(), legend_vertical()
legend_style(), legend_wrap(), legend_reverse()
collect_legends(), align_guides_h()

# Legends (new)
legend_order()
legend_keys()
legend_merge()

# Colorbars (new)
colorbar_style()

# Axes (new)
axis_minor_ticks()
axis_cap()
axis_dodge()
axis_angle()
```

## File Structure

```
R/
├── legend_position.R      # existing
├── legend_style.R         # existing
├── legend_wrap.R          # existing
├── legend_order.R         # NEW
├── legend_keys.R          # NEW
├── legend_merge.R         # NEW (future)
├── colorbar_style.R       # NEW
├── axis_helpers.R         # NEW (all axis functions)
├── collect_legends.R      # existing
└── align_guides.R         # existing
```
