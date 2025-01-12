#' @title `FilterStates` subclass for matrices
#' @description Handles filter states in a `matrix`
#' @keywords internal
#'
#'
MatrixFilterStates <- R6::R6Class( # nolint
  classname = "MatrixFilterStates",
  inherit = FilterStates,

  # public methods ----
  public = list(
    #' @description Initialize `MatrixFilterStates` object
    #'
    #' Initialize `MatrixFilterStates` object
    #'
    #' @param dataname (`character(1)`)\cr
    #'   name of the data used in the expression
    #'   specified to the function argument attached to this `FilterStates`.
    #'
    #' @param datalabel (`character(0)` or `character(1)`)\cr
    #'   text label value.
    initialize = function(dataname, datalabel) {
      super$initialize(dataname, datalabel)
      private$state_list <- list(
        subset = reactiveVal()
      )
    },

    #' @description
    #' Returns the formatted string representing this `MatrixFilterStates` object.
    #'
    #' @param indent (`numeric(1)`) the number of spaces before each line of the representation
    #' @return `character(1)` the formatted string
    format = function(indent = 0) {
      checkmate::assert_number(indent, finite = TRUE, lower = 0)

      formatted_states <- c()
      for (state in self$state_list_get(state_list_index = "subset")) {
        formatted_states <- c(formatted_states, state$format(indent = indent + 2))
      }
      paste(formatted_states, collapse = "\n")
    },

    #' @description
    #' Server module
    #' @param id (`character(1)`)\cr
    #'   an ID string that corresponds with the ID used to call the module's UI function.
    #' @return `moduleServer` function which returns `NULL`
    server = function(id) {
      moduleServer(
        id = id,
        function(input, output, session) {
          previous_state <- reactiveVal(isolate(self$state_list_get("subset")))
          added_state_name <- reactiveVal(character(0))
          removed_state_name <- reactiveVal(character(0))

          observeEvent(self$state_list_get("subset"), {
            added_state_name(
              setdiff(names(self$state_list_get("subset")), names(previous_state()))
            )
            removed_state_name(
              setdiff(names(previous_state()), names(self$state_list_get("subset")))
            )
            previous_state(self$state_list_get("subset"))
          })

          observeEvent(added_state_name(), ignoreNULL = TRUE, {
            fstates <- self$state_list_get("subset")
            html_ids <- private$map_vars_to_html_ids(keys = names(fstates))
            for (fname in added_state_name()) {
              private$insert_filter_state_ui(
                id = html_ids[fname],
                filter_state = fstates[[fname]],
                state_list_index = "subset",
                state_id = fname
              )
            }
            added_state_name(character(0))
          })

          observeEvent(removed_state_name(), {
            req(removed_state_name())

            for (fname in removed_state_name()) {
              private$remove_filter_state_ui("subset", fname, .input = input)
            }
            removed_state_name(character(0))
          })
          NULL
        }
      )
    },

    #' @description
    #' Returns active `FilterState` objects.
    #'
    #' Gets all active filters from this dataset in form of the nested list.
    #' The output list can be used as input to `self$set_filter_state`.
    #'
    #' @return `list` containing `list` with selected values for each `FilterState`.
    get_filter_state = function() {
      lapply(self$state_list_get(state_list_index = "subset"), function(x) x$get_state())
    },

    #' @description
    #' Sets a filter state
    #'
    #' @param data (`matrix`)\cr
    #'   data which are supposed to be filtered.
    #' @param state (`named list`)\cr
    #'   should contain values which are initial selection in the `FilterState`.
    #'   Names of the `list` element should correspond to the name of the
    #'   column in `data`.
    #' @param ... ignored.
    #' @return `NULL`
    set_filter_state = function(data, state, ...) {
      checkmate::assert_class(data, "matrix")
      checkmate::assert(
        checkmate::assert(
          !checkmate::test_null(names(state)),
          checkmate::check_subset(names(state), colnames(data)),
          combine = "and"
        ),
        checkmate::check_class(state, "default_filter"),
        combine = "or"
      )
      logger::log_trace(paste(
        "MatrixFilterState$set_filter_state initializing,",
        "dataname: { private$dataname }"
      ))
      filter_states <- self$state_list_get("subset")
      for (varname in names(state)) {
        value <- resolve_state(state[[varname]])
        if (varname %in% names(filter_states)) {
          fstate <- filter_states[[varname]]
          fstate$set_state(value)
        } else {
          fstate <- init_filter_state(
            data[, varname],
            varname = varname,
            varlabel = varname,
            dataname = private$dataname,
            extract_type = "matrix"
          )
          fstate$set_state(value)
          self$state_list_push(
            x = fstate,
            state_list_index = "subset",
            state_id = varname
          )
        }
      }
      logger::log_trace(paste(
        "MatrixFilterState$set_filter_state initialized,",
        "dataname: { private$dataname }"
      ))
      NULL
    },

    #' @description Remove a variable from the `state_list` and its corresponding UI element.
    #'
    #' @param state_id (`character(1)`)\cr name of `state_list` element.
    #'
    #' @return `NULL`
    remove_filter_state = function(state_id) {
      logger::log_trace(
        sprintf(
          "%s$remove_filter_state of variable %s, dataname: %s",
          class(self)[1],
          state_id,
          private$dataname
        )
      )

      if (!state_id %in% names(self$state_list_get("subset"))) {
        warning(paste(
          "Variable:", state_id, "is not present in the actual active filters of dataset:",
          "{ private$dataname } therefore no changes are applied."
        ))
        logger::log_warn(
          paste(
            "Variable:", state_id, "is not present in the actual active filters of dataset:",
            "{ private$dataname } therefore no changes are applied."
          )
        )
      } else {
        self$state_list_remove(state_list_index = "subset", state_id = state_id)
        logger::log_trace(
          sprintf(
            "%s$remove_filter_state of variable %s done, dataname: %s",
            class(self)[1],
            state_id,
            private$dataname
          )
        )
      }
    },

    # shiny modules ----

    #' @description
    #' Shiny UI module to add filter variable.
    #'
    #' @param id (`character(1)`)\cr
    #'   id of shiny module
    #' @param data (`matrix`)\cr
    #'   data object for which to define a subset
    #'
    #' @return `shiny.tag`
    #'
    ui_add_filter_state = function(id, data) {
      checkmate::assert_string(id)
      stopifnot(is.matrix(data))

      ns <- NS(id)

      if (ncol(data) == 0) {
        div("no sample variables available")
      } else if (nrow(data) == 0) {
        div("no samples available")
      } else {
        teal.widgets::optionalSelectInput(
          ns("var_to_add"),
          choices = NULL,
          options = shinyWidgets::pickerOptions(
            liveSearch = TRUE,
            noneSelectedText = "Select variable to filter"
          )
        )
      }
    },

    #' @description
    #' Shiny server module to add filter variable
    #'
    #' Module controls available choices to select as a filter variable.
    #' Selected filter variable is being removed from available choices.
    #' Removed filter variable gets back to available choices.
    #'
    #' @param id (`character(1)`)\cr
    #'   shiny module instance id
    #' @param data (`matrix`)\cr
    #'   data object for which to define a subset
    #' @param ... ignored
    #'
    #' @return `moduleServer` function which returns `NULL`
    #'
    srv_add_filter_state = function(id, data, ...) {
      stopifnot(is.matrix(data))
      check_ellipsis(..., stop = FALSE)
      moduleServer(
        id = id,
        function(input, output, session) {
          logger::log_trace(
            "MatrixFilterStates$srv_add_filter_state initializing, dataname: { private$dataname }"
          )
          shiny::setBookmarkExclude("var_to_add")
          active_filter_vars <- reactive({
            vapply(
              X = self$state_list_get(state_list_index = "subset"),
              FUN.VALUE = character(1),
              FUN = function(x) x$get_varname()
            )
          })

          # available choices to display
          avail_column_choices <- reactive({
            choices <- setdiff(
              get_supported_filter_varnames(data = data),
              active_filter_vars()
            )
            data_choices_labeled(
              data = data,
              choices = choices,
              varlabels = character(0),
              keys = NULL
            )
          })
          observeEvent(
            avail_column_choices(),
            ignoreNULL = TRUE,
            handlerExpr = {
              logger::log_trace(paste(
                "MatrixFilterStates$srv_add_filter_state@1 updating column choices,",
                "dataname: { private$dataname }"
              ))
              if (length(avail_column_choices()) < 0) {
                shinyjs::hide("var_to_add")
              } else {
                shinyjs::show("var_to_add")
              }
              teal.widgets::updateOptionalSelectInput(
                session,
                "var_to_add",
                choices = avail_column_choices()
              )
              logger::log_trace(paste(
                "MatrixFilterStates$srv_add_filter_state@1 updated column choices,",
                "dataname: { private$dataname }"
              ))
            }
          )

          observeEvent(
            eventExpr = input$var_to_add,
            handlerExpr = {
              logger::log_trace(
                sprintf(
                  "MatrixFilterState$srv_add_filter_state@2 adding FilterState of variable %s, dataname: %s",
                  deparse1(input$var_to_add),
                  private$dataname
                )
              )
              self$state_list_push(
                x = init_filter_state(
                  subset(data, select = input$var_to_add),
                  varname = input$var_to_add,
                  varlabel = private$get_varlabel(input$var_to_add),
                  dataname = private$dataname,
                  extract_type = "matrix"
                ),
                state_list_index = "subset",
                state_id = input$var_to_add
              )
              logger::log_trace(
                sprintf(
                  "MatrixFilterState$srv_add_filter_state@2 added FilterState of variable %s, dataname: %s",
                  deparse1(input$var_to_add),
                  private$dataname
                )
              )
            }
          )

          logger::log_trace(
            "MatrixFilterStates$srv_add_filter_state initialized, dataname: { private$dataname }"
          )
          NULL
        }
      )
    }
  )
)
