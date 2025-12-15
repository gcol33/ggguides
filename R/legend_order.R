#' Reorder Legend Entries
#'
#' Change the order of legend entries without modifying factor levels in your data.
#' This provides a simpler alternative to manually setting factor levels or using
#' the `breaks` argument in scale functions.
#'
#' @param order A character vector specifying the desired order of legend entries,
#'   or a function to apply to the current order (e.g., `rev`, `sort`).
#' @param aesthetic Character string specifying which aesthetic's legend to reorder.
#'   Default is `"colour"`. Common values: `"colour"`, `"color"`, `"fill"`,
#'   `"shape"`, `"linetype"`, `"size"`, `"alpha"`.
#'
#' @return A ggplot2 scale object that reorders the legend.
#'
#' @details
#' This function works by setting the `breaks` argument of the appropriate
#' discrete scale. It automatically detects whether to use `scale_colour_discrete`,
#' `scale_fill_discrete`, etc. based on the `aesthetic` argument.
#'
#' When `order` is a function (like `rev` or `sort`), it will be applied to
#' the default order of legend entries.
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point(size = 3)
#'
#' # Specify exact order
#' p + legend_order(c("8", "6", "4"))
#'
#' # Reverse the order
#' p + legend_order(rev)
#'
#' # Sort alphabetically/numerically
#' p + legend_order(sort)
#'
#' # Reorder fill aesthetic
#' ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
#'   geom_bar() +
#'   legend_order(c("8", "4", "6"), aesthetic = "fill")
#'
#' @seealso
#' \code{\link{legend_reverse}} for a simpler way to reverse legend order,
#' \code{\link{legend_style}} for styling legend appearance.
#'
#' @export
legend_order <- function(order, aesthetic = "colour") {

 # Normalize aesthetic name
 aesthetic <- tolower(aesthetic)
 if (aesthetic == "color") aesthetic <- "colour"

 # Store order specification for later application
 structure(
   list(
     order = order,
     aesthetic = aesthetic
   ),
   class = c("ggguides_legend_order", "gg")
 )
}

#' @export
ggplot_add.ggguides_legend_order <- function(object, plot, ...) {
 aesthetic <- object$aesthetic
 order_spec <- object$order

 # Get the scale for this aesthetic
 scale_name <- paste0("scale_", aesthetic, "_discrete")

 # Determine current breaks/levels from the plot data
 # We need to find the mapping for this aesthetic
 aes_mapping <- plot$mapping[[aesthetic]]
 if (is.null(aes_mapping)) {
   # Check layer mappings
   for (layer in plot$layers) {
     if (!is.null(layer$mapping[[aesthetic]])) {
       aes_mapping <- layer$mapping[[aesthetic]]
       break
     }
   }
 }

 if (is.null(aes_mapping)) {
   warning(sprintf("No '%s' aesthetic found in plot.", aesthetic))
   return(plot)
 }

 # Evaluate the aesthetic expression in the context of the plot data
 # This handles cases like factor(cyl) or other transformations
 var_data <- tryCatch(
   rlang::eval_tidy(aes_mapping, data = plot$data),
   error = function(e) NULL
 )

 if (is.null(var_data)) {
   warning("Could not evaluate aesthetic mapping.")
   return(plot)
 }

 # Get current levels
 if (is.factor(var_data)) {
   current_levels <- levels(var_data)
 } else {
   current_levels <- as.character(sort(unique(var_data)))
 }

 # Determine new order
 if (is.function(order_spec)) {
   new_breaks <- order_spec(current_levels)
 } else if (is.character(order_spec)) {
   # Validate that all specified levels exist
   missing <- setdiff(order_spec, current_levels)
   if (length(missing) > 0) {
     warning(sprintf(
       "The following levels are not in the data and will be ignored: %s",
       paste(missing, collapse = ", ")
     ))
     order_spec <- intersect(order_spec, current_levels)
   }
   # Add any levels not specified (at the end)
   extra <- setdiff(current_levels, order_spec)
   new_breaks <- c(order_spec, extra)
 } else {
   stop("'order' must be a character vector or a function.")
 }

 # Create the appropriate scale
 scale_fn <- switch(aesthetic,
   colour = ggplot2::scale_colour_discrete,
   fill = ggplot2::scale_fill_discrete,
   shape = ggplot2::scale_shape_discrete,
   linetype = ggplot2::scale_linetype_discrete,
   size = ggplot2::scale_size_discrete,
   alpha = ggplot2::scale_alpha_discrete,
   stop(sprintf("Unsupported aesthetic: '%s'", aesthetic))
 )

 plot + scale_fn(breaks = new_breaks)
}
