# =============================================================================
# Multiple Legend Functions
# =============================================================================

#' Normalize Aesthetic Names
#'
#' Internal helper to normalize aesthetic names (e.g., "color" to "colour").
#'
#' @param x Character string of aesthetic name.
#' @return Normalized aesthetic name.
#' @noRd
normalize_aesthetic <- function(x) {
  x <- tolower(x)
  if (x == "color") x <- "colour"
  x
}

#' Hide Specific Legends
#'
#' Remove specific legends from a plot while keeping others. This is more
#' targeted than \code{legend_none()} which removes all legends.
#'
#' @param ... Aesthetic names (unquoted) to hide. Common values: \code{colour},
#'   \code{fill}, \code{size}, \code{shape}, \code{linetype}, \code{alpha}.
#'   Note: \code{color} is automatically converted to \code{colour}.
#'
#' @return A guides specification that can be added to a plot.
#'
#' @examples
#' library(ggplot2)
#'
#' # Plot with multiple legends
#' p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point()
#'
#' # Hide the size legend
#' p + legend_hide(size)
#'
#' # Hide multiple legends
#' p + legend_hide(size, colour)
#'
#' @seealso \code{\link{legend_select}}, \code{\link{legend_none}}
#' @export
legend_hide <- function(...) {
  aesthetics <- as.character(substitute(list(...)))[-1]

  if (length(aesthetics) == 0) {
    stop("At least one aesthetic must be specified.", call. = FALSE)
  }

  aesthetics <- vapply(aesthetics, normalize_aesthetic, character(1),
                       USE.NAMES = FALSE)
  guides_list <- rep(list("none"), length(aesthetics))
  names(guides_list) <- aesthetics
  do.call(ggplot2::guides, guides_list)
}

#' Keep Only Specific Legends
#'
#' Show only the specified legends and hide all others. This is the inverse of
#' \code{\link{legend_hide}}.
#'
#' @param ... Aesthetic names (unquoted) to keep. All other legends will be
#'   hidden. Common values: \code{colour}, \code{fill}, \code{size},
#'   \code{shape}, \code{linetype}, \code{alpha}.
#'
#' @return A guides specification that can be added to a plot, or \code{NULL}
#'   if nothing needs to be hidden.
#'
#' @examples
#' library(ggplot2)
#'
#' # Plot with multiple legends
#' p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp,
#'                          shape = factor(am))) +
#'   geom_point()
#'
#' # Keep only the colour legend
#' p + legend_select(colour)
#'
#' # Keep colour and shape, hide size
#' p + legend_select(colour, shape)
#'
#' @seealso \code{\link{legend_hide}}, \code{\link{legend_none}}
#' @export
legend_select <- function(...) {
  keep <- as.character(substitute(list(...)))[-1]

  if (length(keep) == 0) {
    stop("At least one aesthetic must be specified.", call. = FALSE)
  }

  keep <- vapply(keep, normalize_aesthetic, character(1), USE.NAMES = FALSE)
  all_aes <- c("colour", "fill", "size", "shape", "linetype", "alpha")
  hide <- setdiff(all_aes, keep)

  if (length(hide) == 0) {
    return(NULL)
  }

  guides_list <- rep(list("none"), length(hide))
  names(guides_list) <- hide
  do.call(ggplot2::guides, guides_list)
}

#' Control Legend Display Order
#'
#' Set the display order of multiple legends. Legends with lower order values
#' appear first (top or left).
#'
#' @param ... Named arguments where names are aesthetic names and values are
#'   integer order positions. E.g., \code{colour = 1, size = 2}.
#'
#' @return A guides specification that can be added to a plot.
#'
#' @details
#' The order value determines the position of the legend relative to others.
#' Lower values appear first. By default, all legends have order = 0 and appear
#' in an unspecified order.
#'
#' @examples
#' library(ggplot2)
#'
#' # Plot with multiple legends
#' p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), size = hp)) +
#'   geom_point()
#'
#' # Default order
#' p
#'
#' # Size legend first, then colour
#' p + legend_order_guides(size = 1, colour = 2)
#'
#' # Colour legend first
#' p + legend_order_guides(colour = 1, size = 2)
#'
#' @seealso \code{\link{legend_merge}}, \code{\link{legend_split}}
#' @export
legend_order_guides <- function(...) {
  args <- list(...)

  if (length(args) == 0) {
    stop("At least one aesthetic-order pair must be specified.", call. = FALSE)
  }

  if (is.null(names(args)) || any(names(args) == "")) {
    stop("All arguments must be named (aesthetic = order).", call. = FALSE)
  }

  aes_names <- vapply(names(args), normalize_aesthetic, character(1),
                      USE.NAMES = FALSE)
  guides_list <- lapply(args, function(ord) {
    ggplot2::guide_legend(order = as.integer(ord))
  })
  names(guides_list) <- aes_names
  do.call(ggplot2::guides, guides_list)
}

#' Force Legends to Merge
#'
#' Force specified legends to merge together by setting them to the same order.
#' Legends will only merge if they have matching labels (same factor levels or
#' break values).
#'
#' @param ... Aesthetic names (unquoted) to merge. E.g., \code{colour, fill}.
#'
#' @return A guides specification that can be added to a plot.
#'
#' @details
#' ggplot2 automatically merges legends when they have the same title and
#' matching labels. This function ensures legends have the same order value
#' (order = 0), which is a prerequisite for merging.
#'
#' If legends still don't merge after using this function, ensure:
#' \itemize{
#'   \item Both aesthetics map to the same variable

#'   \item The legends have identical titles (use \code{labs()})
#'   \item The breaks/labels are identical
#' }
#'
#' @examples
#' library(ggplot2)
#'
#' # Plot where colour and fill map to the same variable
#' p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
#'   geom_point(shape = 21, size = 3, stroke = 1.5) +
#'   labs(color = "Cylinders", fill = "Cylinders")
#'
#' # Force merge (they should merge automatically if labels match)
#' p + legend_merge(colour, fill)
#'
#' @seealso \code{\link{legend_split}}, \code{\link{legend_order_guides}}
#' @export
legend_merge <- function(...) {
  aesthetics <- as.character(substitute(list(...)))[-1]

  if (length(aesthetics) < 2) {
    stop("At least two aesthetics must be specified for merging.", call. = FALSE)
  }

  aesthetics <- vapply(aesthetics, normalize_aesthetic, character(1),
                       USE.NAMES = FALSE)
  guides_list <- rep(list(ggplot2::guide_legend(order = 0)), length(aesthetics))
  names(guides_list) <- aesthetics
  do.call(ggplot2::guides, guides_list)
}

#' Force Legends to Stay Separate
#'
#' Force specified legends to remain separate by assigning different order
#' values, preventing automatic merging.
#'
#' @param ... Aesthetic names (unquoted) to keep separate.
#'   E.g., \code{colour, fill}.
#'
#' @return A guides specification that can be added to a plot.
#'
#' @details
#' By default, ggplot2 merges legends that have matching titles and labels.
#' This function assigns different order values to each legend, which prevents
#' automatic merging.
#'
#' @examples
#' library(ggplot2)
#'
#' # Plot where colour and fill would normally merge
#' p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl), fill = factor(cyl))) +
#'   geom_point(shape = 21, size = 3, stroke = 1.5) +
#'   labs(color = "Cylinders", fill = "Cylinders")
#'
#' # Force separate legends
#' p + legend_split(colour, fill)
#'
#' @seealso \code{\link{legend_merge}}, \code{\link{legend_order_guides}}
#' @export
legend_split <- function(...) {
  aesthetics <- as.character(substitute(list(...)))[-1]

  if (length(aesthetics) < 2) {
    stop("At least two aesthetics must be specified for splitting.", call. = FALSE)
  }

  aesthetics <- vapply(aesthetics, normalize_aesthetic, character(1),
                       USE.NAMES = FALSE)
  guides_list <- lapply(seq_along(aesthetics), function(i) {
    ggplot2::guide_legend(order = i)
  })
  names(guides_list) <- aesthetics
  do.call(ggplot2::guides, guides_list)
}
