#' @name FilterState
#' @docType class
#'
#'
#' @title FilterState Abstract Class
#'
#' @description Abstract class to encapsulate filter states
#'
#' @details
#' This class is responsible for managing single filter item within
#' `FilteredData` class. Filter states depend on the variable type:
#' (`logical`, `integer`, `numeric`, `factor`, `character`, `Date`, `POSIXct`, `POSIXlt`)
#' and returns `FilterState` object with class corresponding to input variable.
#' Class controls single filter entry in `module_single_filter_item` and returns
#' code relevant to selected values.
#' - `factor`, `character`: `class = ChoicesFilterState`
#' - `numeric`: `class = RangeFilterState`
#' - `logical`: `class = LogicalFilterState`
#' - `Date`: `class = DateFilterState`
#' - `POSIXct`, `POSIXlt`: `class = DatetimeFilterState`
#' - all `NA` entries: `class: FilterState`, cannot be filtered
#' - default: `FilterState`, cannot be filtered
#' \cr
#' Each variable's filter state is an `R6` object which contains `choices`,
#' `selected`, `varname`, `dataname`, `labels`, `na_count`, `keep_na` and other
#' variable type specific fields (`keep_inf`, `inf_count`, `timezone`).
#' Object contains also shiny module (`ui` and `server`) which manages
#' state of the filter through reactive values `selected`, `keep_na`, `keep_inf`
#' which trigger `get_call()` and every R function call up in reactive
#' chain.
#' \cr
#' \cr
#' @section Modifying state:
#' Modifying a `FilterState` object is possible in three scenarios:
#' * In the interactive session by directly specifying values of `selected`,
#'   `keep_na` or `keep_inf` using `set_state` method (to update all at once),
#'   or using `set_selected`, `set_keep_na` or `set_keep_inf`
#' * In a running application by changing appropriate inputs
#' * In a running application by using [filter_state_api] which directly uses `set_state` method
#'  of the `FilterState` object.
#'
#' @keywords internal
FilterState <- R6::R6Class( # nolint
  "FilterState",

  # public methods ----
  public = list(
    #' @description
    #' Initialize a `FilterState` object
    #' @param x (`vector`)\cr
    #'   values of the variable used in filter
    #' @param varname (`character`)\cr
    #'   name of the variable
    #' @param varlabel (`character(1)`)\cr
    #'   label of the variable (optional).
    #' @param dataname (`character(1)`)\cr
    #'   name of dataset where `x` is taken from. Must be specified if `extract_type` argument
    #'   is not empty.
    #' @param extract_type (`character(0)`, `character(1)`)\cr
    #' whether condition calls should be prefixed by dataname. Possible values:
    #' \itemize{
    #' \item{`character(0)` (default)}{ `varname` in the condition call will not be prefixed}
    #' \item{`"list"`}{ `varname` in the condition call will be returned as `<dataname>$<varname>`}
    #' \item{`"matrix"`}{ `varname` in the condition call will be returned as `<dataname>[, <varname>]`}
    #' }
    #'
    #' @return self invisibly
    #'
    initialize = function(x,
                          varname,
                          varlabel = character(0),
                          dataname = NULL,
                          extract_type = character(0)) {
      checkmate::assert_string(varname)
      checkmate::assert_character(varlabel, max.len = 1, any.missing = FALSE)
      checkmate::assert_string(dataname, null.ok = TRUE)
      checkmate::assert_character(extract_type, max.len = 1, any.missing = FALSE)
      if (length(extract_type) == 1) {
        checkmate::assert_choice(extract_type, choices = c("list", "matrix"))
      }
      if (length(extract_type) == 1 && is.null(dataname)) {
        stop("if extract_type is specified, dataname must also be specified")
      }

      private$dataname <- dataname
      private$varname <- varname
      private$varlabel <- if (identical(varlabel, as.character(varname))) {
        # to not display duplicated label
        character(0)
      } else {
        varlabel
      }
      private$extract_type <- extract_type
      private$selected <- reactiveVal(NULL)
      private$na_count <- sum(is.na(x))
      private$keep_na <- reactiveVal(FALSE)
      logger::log_trace(
        sprintf(
          "Instantiated %s with variable %s, dataname: %s",
          class(self)[1],
          private$varname,
          private$dataname
        )
      )
      invisible(self)
    },

    #' @description
    #' Destroy observers stored in `private$observers`.
    #'
    #' @return NULL invisibly
    #'
    destroy_observers = function() {
      lapply(private$observers, function(x) x$destroy())
      return(invisible(NULL))
    },

    #' @description
    #' Returns a formatted string representing this `FilterState`.
    #'
    #' @param indent (`numeric(1)`)
    #'   number of spaces before after each new line character of the formatted string;
    #'   defaults to 0
    #' @param wrap_width (`numeric(1)`)
    #'   number of characters to wrap lines at in the printed output;
    #'   allowed range is 30 to 120; defaults to 76
    #'
    #' @return `character(1)` the formatted string
    #'
    format = function(indent = 0L, wrap_width = 76L) {
      checkmate::assert_number(indent, finite = TRUE, lower = 0L)
      checkmate::assert_number(wrap_width, finite = TRUE, lower = 30L, upper = 120L)

      # List all selected values separated by commas.
      values <- paste(format(self$get_selected(), nsmall = 3L, justify = "none"), collapse = ", ")
      paste(c(
        strwrap(
          sprintf("Filtering on: %s", private$varname),
          width = wrap_width,
          indent = indent
        ),
        # Add wrapping and progressive indent to values enumeration as it is likely to be long.
        strwrap(
          sprintf("Selected values: %s", values),
          width = wrap_width,
          indent = indent + 2L,
          exdent = indent + 4L
        ),
        strwrap(
          sprintf("Include missing values: %s", self$get_keep_na()),
          width = wrap_width,
          indent = indent + 2L
        )
      ), collapse = "\n")
    },

    #' @description
    #' Returns reproducible condition call for current selection relevant
    #' for selected variable type.
    #' Method is using internal reactive values which makes it reactive
    #' and must be executed in reactive or isolated context.
    #'
    get_call = function() {
      NULL
    },

    #' @description
    #' Returns dataname or "NULL" if dataname is NULL.
    #'
    #' @return `character(1)`
    #'
    get_dataname = function() {
      if (!is.null(private$dataname)) {
        private$dataname
      } else {
        character(1)
      }
    },

    #' @description
    #' Returns current `keep_na` selection.
    #'
    #' @return `logical(1)`
    #'
    get_keep_na = function() {
      private$keep_na()
    },

    #' @description
    #' Returns variable label.
    #'
    #' @return `character(1)`
    #'
    get_varlabel = function() {
      private$varlabel
    },

    #' @description
    #' Get variable name.
    #'
    #' @return `character(1)`
    #'
    get_varname = function() {
      private$varname
    },

    #' @description
    #' Get selected values from `FilterState`.
    #'
    #' @return class of the returned object depends of class of the `FilterState`
    #'
    get_selected = function() {
      private$selected()
    },

    #' @description
    #' Returns the filtering state.
    #'
    #' @return `list` containing values taken from the reactive fields:
    #' * `selected` (`atomic`) length depends on a `FilterState` variant.
    #' * `keep_na` (`logical(1)`) whether `NA` should be kept.
    #'
    get_state = function() {
      list(
        selected = self$get_selected(),
        keep_na = self$get_keep_na()
      )
    },

    #' @description
    #' Prints this `FilterState` object.
    #'
    #' @param ... additional arguments to this method
    #'
    print = function(...) {
      cat(shiny::isolate(self$format()), "\n")
    },

    #' @description
    #' Set whether to keep NAs.
    #'
    #' @param value `logical(1)`\cr
    #'   value(s) which come from the filter selection. Value is set in `server`
    #'   modules after selecting check-box-input in the shiny interface. Values are set to
    #'   `private$keep_na` which is reactive.
    #'
    #' @return NULL invisibly
    #'
    set_keep_na = function(value) {
      checkmate::assert_flag(value)
      private$keep_na(value)
      logger::log_trace(
        sprintf(
          "%s$set_keep_na set for variable %s to %s.",
          class(self)[1],
          private$varname,
          value
        )
      )
      invisible(NULL)
    },

    #' @description
    #' Some methods need an additional `!is.na(varame)` condition to drop
    #' missing values. When `private$na_rm = TRUE`, `self$get_call` returns
    #' condition extended by `!is.na`.
    #'
    #' @param value `logical(1)`\cr
    #'   when `TRUE`, `FilterState$get_call` appends an expression
    #'   removing `NA` values to the filter expression returned by `get_call`
    #'
    #' @return NULL invisibly
    #'
    set_na_rm = function(value) {
      checkmate::assert_flag(value)
      private$na_rm <- value
      invisible(NULL)
    },

    #' @description
    #' Set selection.
    #'
    #' @param value (`vector`)\cr
    #'   value(s) that come from filter selection; values are set in the
    #'   module server after a selection is made in the app interface;
    #'   values are stored in `private$selected` which is reactive;
    #'   value types have to be the same as `private$choices`
    #'
    #' @return NULL invisibly
    #'
    set_selected = function(value) {
      logger::log_trace(
        sprintf(
          "%s$set_selected setting selection of variable %s, dataname: %s.",
          class(self)[1],
          private$varname,
          private$dataname
        )
      )
      value <- private$cast_and_validate(value)
      value <- private$remove_out_of_bound_values(value)
      private$validate_selection(value)
      private$selected(value)
      logger::log_trace(sprintf(
        "%s$set_selected selection of variable %s set, dataname: %s",
        class(self)[1],
        private$varname,
        private$dataname
      ))
      invisible(NULL)
    },

    #' @description
    #' Set state.
    #'
    #' @param state (`list`)\cr
    #'  contains fields relevant for a specific class:
    #' \itemize{
    #' \item{`selected`}{ defines initial selection}
    #' \item{`keep_na` (`logical`)}{ defines whether to keep or remove `NA` values}
    #' }
    #'
    #' @return NULL invisibly
    #'
    set_state = function(state) {
      logger::log_trace(sprintf(
        "%s$set_state, dataname: %s setting state of variable %s to: selected=%s, keep_na=%s",
        class(self)[1],
        private$dataname,
        private$varname,
        paste(state$selected, collapse = " "),
        state$keep_na
      ))
      stopifnot(is.list(state) && all(names(state) %in% c("selected", "keep_na")))
      if (!is.null(state$keep_na)) {
        self$set_keep_na(state$keep_na)
      }
      if (!is.null(state$selected)) {
        self$set_selected(state$selected)
      }
      logger::log_trace(
        sprintf(
          "%s$set_state, dataname: %s done setting state for variable %s",
          class(self)[1],
          private$dataname,
          private$varname
        )
      )
      invisible(NULL)
    },

    #' @description
    #' Shiny module server.
    #'
    #' @param id (`character(1)`)\cr
    #'   shiny module instance id
    #'
    #' @return `moduleServer` function which returns reactive value
    #'   signaling that remove button has been clicked
    #'
    server = function(id) {
      moduleServer(
        id = id,
        function(input, output, session) {
          private$server_inputs("inputs")
          reactive(input$remove) # back to parent to remove self
        }
      )
    },

    #' @description
    #' Shiny module UI.
    #'
    #' @param id (`character(1)`)\cr
    #'  shiny element (module instance) id;
    #'  the UI for this class contains simple message stating that it is not supported
    #'
    ui = function(id) {
      ns <- NS(id)
      fluidPage(
        theme = get_teal_bs_theme(),
        fluidRow(
          column(
            width = 10,
            class = "no-left-right-padding",
            tags$div(
              tags$span(private$varname,
                class = "filter_panel_varname"
              ),
              if (checkmate::test_character(self$get_varlabel(), min.len = 1) &&
                tolower(private$varname) != tolower(self$get_varlabel())) {
                tags$span(self$get_varlabel(), class = "filter_panel_varlabel")
              }
            )
          ),
          column(
            width = 2,
            class = "no-left-right-padding",
            actionLink(
              ns("remove"),
              label = "",
              icon = icon("circle-xmark", lib = "font-awesome"),
              class = "remove pull-right"
            )
          )
        ),
        private$ui_inputs(ns("inputs"))
      )
    }
  ),

  # private members ----
  private = list(
    choices = NULL, # because each class has different choices type
    dataname = character(0),
    keep_na = NULL, # reactiveVal logical()
    na_count = integer(0),
    na_rm = FALSE, # it's logical(1)
    observers = NULL, # here observers are stored
    selected = NULL, # because it holds reactiveVal and each class has different choices type
    varname = character(0),
    varlabel = character(0),
    extract_type = logical(0),

    # private methods ----

    # @description
    # Return variable name prefixed by dataname to be evaluated as extracted object,
    # for example `data$var`
    # @return a character string representation of a subset call
    #         that extracts the variable from the dataset
    get_varname_prefixed = function() {
      ans <-
        if (isTRUE(private$extract_type == "list")) {
          sprintf("%s$%s", private$dataname, private$varname)
        } else if (isTRUE(private$extract_type == "matrix")) {
          sprintf("%s[, \"%s\"]", private$dataname, private$varname)
        } else {
          private$varname
        }
      str2lang(ans)
    },

    # @description
    # Adds `is.na(varname)` before existing condition calls if `keep_na` is selected.
    # Otherwise, if missings are found in the variable `!is.na` will be added
    # only if `private$na_rm = TRUE`
    # @return a `call`
    add_keep_na_call = function(filter_call) {
      if (isTRUE(self$get_keep_na())) {
        call("|", call("is.na", private$get_varname_prefixed()), filter_call)
      } else if (isTRUE(private$na_rm) && private$na_count > 0L) {
        call(
          "&",
          call("!", call("is.na", private$get_varname_prefixed())),
          filter_call
        )
      } else {
        filter_call
      }
    },

    # Sets `keep_na` field according to observed `input$keep_na`
    # If `keep_na = TRUE` `is.na(varname)` is added to the returned call.
    # Otherwise returned call excludes `NA` when executed.
    observe_keep_na = function(input) {

    },

    # @description
    # Set choices is supposed to be executed once in the constructor
    # to define set/range which selection is made from.
    # parameter choices (`vector`)\cr
    #  class of the vector depends on the `FilterState` class.
    # @return `NULL`
    set_choices = function(choices) {
      private$choices <- choices
      invisible(NULL)
    },

    # Checks if the selection is valid in terms of class and length.
    # It should not return anything but throw an error if selection
    # has a wrong class or is outside of possible choices
    validate_selection = function(value) {
      invisible(NULL)
    },

    # Filters out erroneous values from an array.
    #
    # @param values the array of values
    #
    # @return the array of values without elements, which are outside of
    # the accepted set for this FilterState
    remove_out_of_bound_values = function(values) {
      values
    },

    # Casts an array of values to the type fitting this `FilterState`
    # and validates the elements of the casted array
    # satisfy the requirements of this `FilterState`.
    #
    # @param values the array of values
    #
    # @return the casted array
    #
    # @note throws an error if the casting did not execute successfully.
    cast_and_validate = function(values) {
      values
    },

    # shiny modules -----
    # module with inputs
    ui_inputs = function(id) {
      stop("abstract class")
    },
    # module with inputs
    server_inputs = function(id) {
      stop("abstract class")
    },

    # @description
    # module displaying input to keep or remove NA in the FilterState call
    # @param id `shiny` id parameter
    #  renders checkbox input only when variable from which FilterState has
    #  been created has some NA values.
    keep_na_ui = function(id) {
      ns <- NS(id)
      if (private$na_count > 0) {
        checkboxInput(
          ns("value"),
          sprintf("Keep NA (%s)", private$na_count),
          value = self$get_keep_na()
        )
      } else {
        NULL
      }
    },

    # @description
    # module to handle NA values in the FilterState
    # @param shiny `id` parameter passed to moduleServer
    #  module sets `private$keep_na` according to the selection.
    #  Module also updates a UI element if the `private$keep_na` has been
    #  changed through the api
    keep_na_srv = function(id) {
      moduleServer(id, function(input, output, session) {
        # this observer is needed in the situation when private$keep_inf has been
        # changed directly by the api - then it's needed to rerender UI element
        # to show relevant values
        private$observers$keep_na_api <- observeEvent(
          ignoreNULL = FALSE, # nothing selected is possible for NA
          ignoreInit = TRUE, # ignoreInit: should not matter because we set the UI with the desired initial state
          eventExpr = self$get_keep_na(),
          handlerExpr = {
            if (!setequal(self$get_keep_na(), input$value)) {
              updateCheckboxInput(
                inputId = "value",
                value = self$get_keep_na()
              )
            }
          }
        )
        private$observers$keep_na <- observeEvent(
          ignoreNULL = FALSE, # ignoreNULL: we don't want to ignore NULL when nothing is selected in the `selectInput`
          ignoreInit = TRUE, # ignoreInit: should not matter because we set the UI with the desired initial state
          eventExpr = input$value,
          handlerExpr = {
            keep_na <- if (is.null(input$value)) {
              FALSE
            } else {
              input$value
            }
            self$set_keep_na(keep_na)
            logger::log_trace(
              sprintf(
                "%s$server keep_na of variable %s set to: %s, dataname: %s",
                class(self)[1],
                private$varname,
                deparse1(input$value),
                private$dataname
              )
            )
          }
        )
        invisible(NULL)
      })
    }
  )
)
