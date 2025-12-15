# build_site.R - Build pkgdown site with theme-aware SVG post-processing
#
# Usage: source("build_site.R") or Rscript build_site.R
#
# This script builds the pkgdown site and then post-processes all SVG files
# to make their backgrounds and text theme-aware (light/dark mode responsive).

# Theme colors matching the site's code blocks
# Light mode
LIGHT_BG <- "#F5F6F8"       # code-block background
LIGHT_BORDER <- "#DFD7CA"   # code-block border
LIGHT_TEXT <- "#3E3F3A"     # body text color

# Dark mode
DARK_BG <- "#343739"        # code-block background
DARK_BORDER <- "#495057"    # code-block border
DARK_TEXT <- "#DFD7CA"      # body text color

# Sandstone theme font stack
FONT_FAMILY <- '"Roboto", -apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif'

#' Make an SVG file theme-aware
#'
#' Handles both base R svg() and svglite output formats.
#' For svglite: Modifies background rect, CSS rules for strokes/text.
#' For base R: Finds white-filled backgrounds and black text, adds CSS classes.
#'
#' @param svg_path Path to SVG file
#' @param light_bg Background color for light mode
#' @param light_border Border color for light mode
#' @param light_text Text color for light mode
#' @param font_family Font family to use
#' @param verbose Print status
#' @return Invisible logical indicating if changes were made
make_svg_theme_aware <- function(svg_path,
                                 light_bg = LIGHT_BG,
                                 light_border = LIGHT_BORDER,
                                 light_text = LIGHT_TEXT,
                                 font_family = FONT_FAMILY,
                                 verbose = TRUE) {
  svg_lines <- readLines(svg_path, warn = FALSE)
  svg_content <- paste(svg_lines, collapse = "\n")
  original <- svg_content

  # Skip if already processed AND has correct background AND no issues
  # (check for svg-bg class which indicates background was properly set)
  has_white_strokes <- grepl("stroke: #FFFFFF;", svg_content, fixed = TRUE)
  # Check for incorrectly replaced white text (text with fill: #F5F6F8)
  has_wrong_text_fill <- grepl("<text [^>]*fill: #F5F6F8", svg_content)
  # Check if rect rule has wrong stroke (black instead of theme color)
  has_wrong_rect_stroke <- grepl("\\.svglite rect \\{[^}]*stroke: #000000", svg_content)
  # Check for old CSS variable approach that needs updating
  has_css_variables <- grepl("var\\(--svg-(stroke|bg)-color", svg_content)
  # Check for combined rule (rect not split out) that needs updating
  has_combined_rule <- grepl("\\.svglite line.*\\.svglite rect.*\\.svglite circle \\{", svg_content)
  # Check for legend boxes with fill: #F5F6F8 but no explicit stroke
  has_legend_without_stroke <- grepl("<rect [^>]*style='stroke-width:[^']*fill: #F5F6F8;'", svg_content)
  # Check for legend boxes that still have white fill (need to be themed)
  has_white_legend_fill <- grepl("<rect [^>]*style='[^']*fill: #FFFFFF;", svg_content)
  # Check for old stroke-based svg-bg rect (now we use CSS border instead)
  has_old_svg_bg_stroke <- grepl("class='svg-bg'[^>]*stroke-width:", svg_content)
  # Check for legend boxes without rounded corners (need rx attribute)
  has_legend_no_rounding <- grepl("<rect x='[^']+' y='[^']+' width='[^']+' height='[^']+' style='[^']*fill: #F5F6F8;", svg_content) &&
                            !grepl("<rect rx='[^']+' x='[^']+' y='[^']+' width='[^']+' height='[^']+' style='[^']*fill: #F5F6F8;", svg_content)
  # Check for old broad .svglite rect rule (should be .svglite > g > rect)
  has_broad_rect_rule <- grepl("\\.svglite rect \\{", svg_content)
  if (grepl("theme-aware-processed", svg_content, fixed = TRUE) &&
      grepl("class='svg-bg'", svg_content, fixed = TRUE) &&
      !has_white_strokes && !has_wrong_text_fill && !has_wrong_rect_stroke &&
      !has_css_variables && !has_combined_rule && !has_legend_without_stroke &&
      !has_white_legend_fill && !has_old_svg_bg_stroke && !has_legend_no_rounding &&
      !has_broad_rect_rule) {
    if (verbose) cat(sprintf("  %s: already processed\n", basename(svg_path)))
    return(invisible(FALSE))
  }

  # Fix text that was incorrectly changed from white to background color
  # (This happens when text should be white on dark cells in heatmaps)
  svg_content <- gsub(
    "(<text [^>]*style='[^']*)(fill: #F5F6F8;)",
    "\\1fill: #FFFFFF;",
    svg_content
  )

  # If we have the marker but need re-processing, remove existing processed CSS
  if (grepl("theme-aware-processed", svg_content, fixed = TRUE)) {
    # Remove the marker and the split rect rule we added before
    svg_content <- gsub(
      "    /\\* theme-aware-processed \\*/\n    \\.svglite line[^}]+\\}\n    \\.svglite rect[^}]+\\}",
      "    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {\n      fill: none;\n      stroke: #000000;\n      stroke-linecap: round;\n      stroke-linejoin: round;\n      stroke-miterlimit: 10.00;\n    }",
      svg_content
    )
    # Remove old CSS variable style block if present
    svg_content <- gsub(
      "\n  <style type=\"text/css\">\n    /\\* theme-aware-processed[^<]+</style>",
      "",
      svg_content
    )
    # Replace CSS variable stroke with black so the pattern matching works
    svg_content <- gsub(
      "stroke: var\\(--svg-stroke-color, #000000\\);",
      "stroke: #000000;",
      svg_content
    )
    # Replace CSS variable fill with white so the pattern matching works
    svg_content <- gsub(
      "fill: var\\(--svg-bg-color, #FFFFFF\\);",
      "fill: #FFFFFF;",
      svg_content
    )
    # Replace old svg-bg rect with stroke to new format without stroke
    svg_content <- gsub(
      "<rect class='svg-bg' width='100%' height='100%' style='stroke: [^;]+; stroke-width: [^;]+; fill: [^;]+;'/>",
      sprintf("<rect class='svg-bg' width='100%%' height='100%%' style='stroke: none; fill: %s;'/>", LIGHT_BG),
      svg_content
    )
    # Add stroke to legend boxes that have fill: #F5F6F8 but no explicit stroke
    # Use border color for legend box stroke (matches red.R approach)
    # Pattern requires: not svg-bg class, style with stroke-width but NO stroke: already
    # Also add rx for rounded corners
    svg_content <- gsub(
      "(<rect )((?!class='svg-bg')[^>]*style='stroke-width: [0-9.]+; )(fill: #F5F6F8;)(' />)",
      sprintf("\\1rx='4' \\2stroke: %s; \\3\\4", LIGHT_BORDER),
      svg_content,
      perl = TRUE
    )
    # Add rx to legend boxes that already have stroke but no rx
    svg_content <- gsub(
      "(<rect )(x='[^']+' y='[^']+' width='[^']+' height='[^']+' style='[^']*fill: #F5F6F8;[^']*' />)",
      "\\1rx='4' \\2",
      svg_content
    )
    # Replace old broad .svglite rect rule with more specific .svglite > g > rect
    svg_content <- gsub(
      "(\\.svglite) rect (\\{)",
      "\\1 > g > rect \\2",
      svg_content
    )
  }

  # Detect if this is svglite output (has .svglite class)
  is_svglite <- grepl("class='svglite'", svg_content, fixed = TRUE)

  if (is_svglite) {
    # === SVGLITE FORMAT ===
    # Based on working approach: modify CSS rules and specific elements
    # Using fixed = TRUE for exact pattern matching

    # 1) Replace background rect (full figure) - just set fill, no stroke
    # The outer CSS border (via .inline-svg) handles the border with rounded corners
    # Handle both fill: #FFFFFF and fill: none patterns
    svg_content <- sub(
      "<rect width='100%' height='100%' style='stroke: none; fill: #FFFFFF;'/>",
      sprintf(
        "<rect class='svg-bg' width='100%%' height='100%%' style='stroke: none; fill: %s;'/>",
        light_bg
      ),
      svg_content,
      fixed = TRUE
    )
    svg_content <- sub(
      "<rect width='100%' height='100%' style='stroke: none; fill: none;'/>",
      sprintf(
        "<rect class='svg-bg' width='100%%' height='100%%' style='stroke: none; fill: %s;'/>",
        light_bg
      ),
      svg_content,
      fixed = TRUE
    )

    # 2) Replace legend/other rect backgrounds with fill: #FFFFFF
    # Only replace in rect elements, not text (which might be white on dark cells)
    # Add explicit stroke (border color) for legend boxes - matches red.R approach
    # Pattern: rects with stroke-width but no stroke: in their style get a stroke added
    # This handles the legend box which svglite renders as:
    #   style='stroke-width: 0.75; fill: #FFFFFF;'
    # Add rx='4' for rounded corners (matches .375rem at typical SVG scale)
    svg_content <- gsub(
      "(<rect )([^>]*style='stroke-width: [0-9.]+; )(fill: #FFFFFF;)(' />)",
      sprintf("\\1rx='4' \\2stroke: %s; fill: %s;\\4", light_border, light_bg),
      svg_content
    )
    # Handle rects that already have an explicit stroke - just change the fill
    # Also add rx for rounded corners if not present
    svg_content <- gsub(
      "(<rect )([^>]*style='[^']*stroke: [^;]+;[^']*)(fill: #FFFFFF;)(' />)",
      sprintf("\\1rx='4' \\2fill: %s;\\4", light_bg),
      svg_content
    )

    # 3) Replace white strokes (histogram bars, legend keys) with text color
    svg_content <- gsub(
      "stroke: #FFFFFF;",
      sprintf("stroke: %s;", light_text),
      svg_content,
      fixed = TRUE
    )

    # 3) Modify the CSS block for lines/shapes - change stroke color
    # Use fixed = TRUE with exact pattern match
    # Keep original CSS structure but update colors
    # Split rules: lines/paths get theme color, rects keep black (for histogram bars)
    line_rule_pat <- paste0(
      "    .svglite line, .svglite polyline, .svglite polygon, ",
      ".svglite path, .svglite rect, .svglite circle {\n",
      "      fill: none;\n",
      "      stroke: #000000;\n",
      "      stroke-linecap: round;\n",
      "      stroke-linejoin: round;\n",
      "      stroke-miterlimit: 10.00;\n",
      "    }"
    )
    # Use .svglite > g > rect to only target rects inside g elements, not defs/clipPath
    new_line_rule <- sprintf(
      paste0(
        "    /* theme-aware-processed */\n",
        "    .svglite line, .svglite polyline, .svglite polygon, ",
        ".svglite path, .svglite circle {\n",
        "      fill: none;\n",
        "      stroke: %s;\n",
        "      stroke-linecap: round;\n",
        "      stroke-linejoin: round;\n",
        "      stroke-miterlimit: 10.00;\n",
        "    }\n",
        "    .svglite > g > rect {\n",
        "      fill: none;\n",
        "      stroke: %s;\n",
        "      stroke-linecap: round;\n",
        "      stroke-linejoin: round;\n",
        "      stroke-miterlimit: 10.00;\n",
        "    }"
      ),
      light_text, light_text
    )
    svg_content <- sub(line_rule_pat, new_line_rule, svg_content, fixed = TRUE)

    # 4) Modify the CSS block for text - add fill color
    text_rule_pat <- paste0(
      "    .svglite text {\n",
      "      white-space: pre;\n",
      "    }"
    )
    new_text_rule <- sprintf(
      paste0(
        "    .svglite text {\n",
        "      white-space: pre;\n",
        "      fill: %s;\n",
        "    }"
      ),
      light_text
    )
    svg_content <- sub(text_rule_pat, new_text_rule, svg_content, fixed = TRUE)

    # 5) Update font family in inline styles
    svg_content <- gsub(
      'font-family: "Arial";',
      sprintf("font-family: %s;", font_family),
      svg_content,
      fixed = TRUE
    )

  } else {
    # === BASE R SVG FORMAT ===
    # Pattern for white fills as encoded by base R svg()
    white_pattern <- 'fill="rgb\\(100%,\\s*100%,\\s*100%\\)"'

    # Pattern for black fills (text) as encoded by base R svg()
    black_pattern <- 'fill="rgb\\(0%,\\s*0%,\\s*0%\\)"'

    # Check if there are any white fills to process
    has_white <- grepl(white_pattern, svg_content)
    has_black <- grepl(black_pattern, svg_content)

    # Also check if this was previously processed but needs color update
    has_old_theme_styles <- grepl("class=\"theme-bg\"", svg_content, fixed = TRUE) ||
                            grepl("class=\"theme-text\"", svg_content, fixed = TRUE)

    if (!has_white && !has_black && !has_old_theme_styles) {
      if (verbose) cat(sprintf("  %s: no theme elements found\n", basename(svg_path)))
      return(invisible(FALSE))
    }

    # Replace white fills with class reference for backgrounds
    svg_content <- gsub(
      paste0('(<[^>]*)', white_pattern, '([^>]*>)'),
      '\\1class="theme-bg"\\2',
      svg_content
    )

    # Handle elements that already have a class attribute
    svg_content <- gsub(
      paste0('(<[^>]*class=")([^"]*)"([^>]*)', white_pattern),
      '\\1\\2 theme-bg"\\3',
      svg_content
    )

    # Handle other white patterns
    svg_content <- gsub(
      'fill="#[Ff][Ff][Ff][Ff][Ff][Ff]"',
      'class="theme-bg"',
      svg_content
    )
    svg_content <- gsub(
      'fill="#[Ff][Ff][Ff]"',
      'class="theme-bg"',
      svg_content
    )
    svg_content <- gsub(
      'fill="white"',
      'class="theme-bg"',
      svg_content,
      ignore.case = TRUE
    )

    # Replace black fills with class reference for text
    svg_content <- gsub(
      paste0('(<[^>]*)', black_pattern, '([^>]*>)'),
      '\\1class="theme-text"\\2',
      svg_content
    )

    # Handle elements that already have a class attribute for text
    svg_content <- gsub(
      paste0('(<[^>]*class=")([^"]*)"([^>]*)', black_pattern),
      '\\1\\2 theme-text"\\3',
      svg_content
    )

    # Handle other black patterns
    svg_content <- gsub(
      'fill="#000000"',
      'class="theme-text"',
      svg_content
    )
    svg_content <- gsub(
      'fill="#000"',
      'class="theme-text"',
      svg_content
    )
    svg_content <- gsub(
      'fill="black"',
      'class="theme-text"',
      svg_content,
      ignore.case = TRUE
    )

    # Remove any existing theme style block (for re-processing with new colors)
    svg_content <- gsub(
      '\n<style type="text/css">\n  /\\* [Tt]heme[^*]*\\*/\n  \\.theme-bg \\{[^}]+\\}\n  \\.theme-text \\{[^}]+\\}\n</style>\n',
      '',
      svg_content
    )

    # Create the style block - no media queries needed since we'll inline SVGs
    # The page's CSS will handle dark mode via [data-bs-theme="dark"] selectors
    style_block <- sprintf('
<style type="text/css">
  /* theme-aware-processed - auto-generated by build_site.R */
  .theme-bg {
    fill: %s;
  }
  .theme-text {
    fill: %s;
    font-family: %s;
  }
</style>
', light_bg, light_text, font_family)

    # Inject style block right after the opening <svg> tag
    svg_content <- sub(
      '(<svg[^>]*>)',
      paste0('\\1', style_block),
      svg_content
    )
  }

  changed <- !identical(original, svg_content)

  if (changed) {
    writeLines(svg_content, svg_path)
  }

  if (verbose) {
    cat(sprintf("  %s: %s\n",
                basename(svg_path),
                if (changed) {
                  if (is_svglite) "made theme-aware (svglite)" else "made theme-aware (base R)"
                } else "unchanged"))
  }

  invisible(changed)
}

#' Process all SVG files in pkgdown output
#'
#' Recursively finds all SVG files in docs/ and makes them theme-aware.
#'
#' @param docs_dir Path to pkgdown docs directory (default: "docs")
#' @param light_bg Background color for light mode
#' @param light_border Border color for light mode
#' @param light_text Text color for light mode
#' @param font_family Font family to use
#' @param verbose Print progress messages
#' @return Invisible vector of modified file paths
process_pkgdown_svgs <- function(docs_dir = "docs",
                                 light_bg = LIGHT_BG,
                                 light_border = LIGHT_BORDER,
                                 light_text = LIGHT_TEXT,
                                 font_family = FONT_FAMILY,
                                 verbose = TRUE) {
  svg_files <- list.files(
    docs_dir,
    pattern = "\\.svg$",
    recursive = TRUE,
    full.names = TRUE
  )

  if (length(svg_files) == 0) {
    if (verbose) cat("No SVG files found in", docs_dir, "\n")
    return(invisible(character(0)))
  }

  if (verbose) {
    cat(sprintf("Found %d SVG files in %s\n", length(svg_files), docs_dir))
    cat(sprintf("Light: bg=%s, border=%s, text=%s\n",
                light_bg, light_border, light_text))
  }

  modified <- character(0)

  for (svg_path in svg_files) {
    changed <- make_svg_theme_aware(
      svg_path, light_bg, light_border, light_text, font_family, verbose
    )
    if (changed) {
      modified <- c(modified, svg_path)
    }
  }

  if (verbose) {
    cat(sprintf("\nProcessed %d of %d files\n", length(modified), length(svg_files)))
  }

  invisible(modified)
}

#' Inline SVG images in HTML files
#'
#' Replaces <img src="...svg"> tags with inline <svg> content so that
#' the page's CSS can style the SVG elements (for dark mode support).
#'
#' @param html_path Path to HTML file
#' @param verbose Print status
#' @return Invisible logical indicating if changes were made
inline_svgs_in_html <- function(html_path, verbose = TRUE) {
  html_content <- paste(readLines(html_path, warn = FALSE), collapse = "\n")
  original <- html_content

  # Find all img tags with .svg sources
  # Pattern: <img src="path/to/file.svg" ...>
  img_pattern <- '<img\\s+[^>]*src="([^"]+\\.svg)"[^>]*>'

  matches <- gregexpr(img_pattern, html_content, perl = TRUE)
  if (matches[[1]][1] == -1) {
    if (verbose) cat(sprintf("  %s: no SVG images\n", basename(html_path)))
    return(invisible(FALSE))
  }

  # Get the HTML directory for resolving relative paths
  html_dir <- dirname(html_path)

  # Process each match (in reverse order to preserve positions)
  match_starts <- as.integer(matches[[1]])
  match_lengths <- attr(matches[[1]], "match.length")

  for (i in rev(seq_along(match_starts))) {
    start <- match_starts[i]
    len <- match_lengths[i]
    img_tag <- substr(html_content, start, start + len - 1)

    # Extract the src path
    src_match <- regmatches(img_tag, regexec('src="([^"]+\\.svg)"', img_tag))
    if (length(src_match[[1]]) < 2) next
    svg_src <- src_match[[1]][2]

    # Resolve the SVG path
    svg_path <- normalizePath(file.path(html_dir, svg_src), mustWork = FALSE)
    if (!file.exists(svg_path)) {
      if (verbose) cat(sprintf("    Warning: SVG not found: %s\n", svg_src))
      next
    }

    # Read the SVG content
    svg_content <- paste(readLines(svg_path, warn = FALSE), collapse = "\n")

    # Remove XML declaration if present
    svg_content <- sub('<\\?xml[^>]*\\?>', '', svg_content)

    # Extract any class from the img tag to add to svg
    class_match <- regmatches(img_tag, regexec('class="([^"]*)"', img_tag))
    img_class <- if (length(class_match[[1]]) >= 2) class_match[[1]][2] else ""

    # Add the img classes plus our styling class to the svg tag
    svg_class <- paste(c(img_class, "inline-svg"), collapse = " ")
    svg_class <- trimws(svg_class)

    # Add class to the svg element and make it responsive
    svg_content <- sub(
      '<svg([^>]*)>',
      sprintf('<svg\\1 class="%s" style="max-width:100%%;width:100%%;height:auto;">', svg_class),
      svg_content
    )

    # Replace the img tag with the SVG content
    html_content <- paste0(
      substr(html_content, 1, start - 1),
      svg_content,
      substr(html_content, start + len, nchar(html_content))
    )
  }

  changed <- !identical(original, html_content)

  if (changed) {
    writeLines(html_content, html_path)
  }

  n_inlined <- length(match_starts)
  if (verbose) {
    cat(sprintf("  %s: %s\n",
                basename(html_path),
                if (changed) sprintf("inlined %d SVG(s)", n_inlined) else "unchanged"))
  }

  invisible(changed)
}

#' Inline all SVGs in pkgdown HTML files
#'
#' @param docs_dir Path to pkgdown docs directory
#' @param verbose Print progress
#' @return Invisible vector of modified file paths
inline_all_svgs <- function(docs_dir = "docs", verbose = TRUE) {
  html_files <- list.files(
    docs_dir,
    pattern = "\\.html$",
    recursive = TRUE,
    full.names = TRUE
  )

  if (length(html_files) == 0) {
    if (verbose) cat("No HTML files found in", docs_dir, "\n")
    return(invisible(character(0)))
  }

  if (verbose) {
    cat(sprintf("Found %d HTML files in %s\n\n", length(html_files), docs_dir))
  }

  modified <- character(0)

  for (html_path in html_files) {
    changed <- inline_svgs_in_html(html_path, verbose)
    if (changed) {
      modified <- c(modified, html_path)
    }
  }

  if (verbose) {
    cat(sprintf("\nInlined SVGs in %d of %d HTML files\n", length(modified), length(html_files)))
  }

  invisible(modified)
}

# Main execution
if (!interactive() || TRUE) {
  cat("=== Building pkgdown site ===\n\n")
  pkgdown::build_site()

  cat("\n=== Making SVG files theme-aware ===\n")
  process_pkgdown_svgs("docs")

  cat("\n=== Inlining SVGs in HTML files ===\n")
  inline_all_svgs("docs")

  cat("\n=== Done! ===\n")
}
