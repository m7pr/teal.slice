#' Resolve list of filter states
#'
#' Resolves the state values for `FilterState$set_state()`, which accepts only a list
#' with `selected`,`keep_na` and `keep_inf` fields. In case of the `default_filter` function,
#' it returns `NULL` as during the initialization of `FilterState` values are set to
#' default.
#'
#' @param x (`list`,`vector`)\cr
#'  values of the variable used in filter. Depending on the `FilterState` type
#'  list must contain these fields:
#'  \itemize{
#'  \item{`selected`}{ defines initial selection. See notes for more details}
#'  \item{`keep_na` (`logical`)}{ defines whether to keep or remove `NA` values}
#'  \item{`keep_inf` (`logical`)}{ defines whether to keep or remove `Inf` values}
#'  }
#'  If `vector` is provided then `keep_na` and `keep_inf` can be specified
#'  adding `NA` and `Inf` to the selection vector.
#'
#' @note
#' The value of the `x$selected` needs to be modified according to the type
#' of the passed `filter_state`.
#'
#' @seealso
#' - [LogicalFilterState]
#' - [ChoicesFilterState]
#' - [RangeFilterState]
#' - [DateFilterState]
#' - [DatetimeFilterState]
#'
#' @return `list` containing `selected`, `keep_na` and `keep_inf`
#'
#' @keywords internal
#'
#' @examples
#' teal.slice:::resolve_state(list(c(1, 2), keep_na = FALSE, keep_inf = TRUE))
#' teal.slice:::resolve_state(c(1, 2, Inf))
#' teal.slice:::resolve_state(list())
resolve_state <- function(x) {
  UseMethod("resolve_state")
}

#' @rdname resolve_state
#' @keywords internal
#' @export
resolve_state.default <- function(x) {
  state <- list()
  if (length(x[!(is.infinite(x) | is.na(x))]) > 0) {
    state$selected <- x[!(is.infinite(x) | is.na(x))]
  }

  if (any(is.na(x))) {
    state$keep_na <- TRUE
  }

  if (any(is.infinite(x))) {
    state$keep_inf <- TRUE
  }

  state
}

#' @rdname resolve_state
#' @keywords internal
#' @export
resolve_state.default_filter <- function(x, filter_state) { # nolint
  list()
}

#' @rdname resolve_state
#' @keywords internal
#' @export
resolve_state.list <- function(x) {
  if (identical(x, list())) {
    return(x)
  }
  if (is.null(names(x))) {
    names(x) <- rep("", length(x))
  }
  x_names <- names(x)
  if (sum(x_names == "") > 1) {
    stop("More than one element of filter state is unnamed.")
  } else if (sum(x_names == "") == 1) {
    if ("selected" %in% x_names) {
      stop("Unnamed element of filter state cannot be intepreted as 'selected' because it already exists.")
    } else {
      x_idx <- which(x_names == "")
      names(x)[[x_idx]] <- "selected"
    }
  }
  x
}
