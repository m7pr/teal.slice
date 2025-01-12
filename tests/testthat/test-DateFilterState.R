dates <- as.Date("2000-01-01") + 0:9

testthat::test_that("The constructor accepts a Date object", {
  testthat::expect_no_error(DateFilterState$new(dates, varname = "variable"))
})

testthat::test_that("get_call returns a condition true for the object passed in the constructor", {
  filter_state <- DateFilterState$new(dates, varname = "dates")
  testthat::expect_true(all(eval(shiny::isolate(filter_state$get_call()))))
})

testthat::test_that("set_selected accepts an array of two Date objects", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_no_error(filter_state$set_selected(dates[c(1, 10)]))
})

testthat::test_that("set_selected warns when selection is not within the possible range", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_warning(
    filter_state$set_selected(c(dates[1] - 1, dates[10])),
    regexp = "outside of the possible range"
  )
  testthat::expect_warning(
    filter_state$set_selected(c(dates[1], dates[10] + 1)),
    regexp = "outside of the possible range"
  )
  testthat::expect_warning(
    filter_state$set_selected(c(dates[1] - 1, dates[10] + 1)),
    regexp = "outside of the possible range"
  )
})

testthat::test_that("set_selected limits the selected range to the lower and the upper bound of the possible range", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  suppressWarnings(filter_state$set_selected(c(dates[1] - 1, dates[10])))
  testthat::expect_equal(shiny::isolate(filter_state$get_selected()), c(dates[1], dates[10]))
  suppressWarnings(filter_state$set_selected(c(dates[1], dates[10] + 1)))
  testthat::expect_equal(shiny::isolate(filter_state$get_selected()), c(dates[1], dates[10]))
  suppressWarnings(filter_state$set_selected(c(dates[1] - 1, dates[10] + 1)))
  testthat::expect_equal(shiny::isolate(filter_state$get_selected()), c(dates[1], dates[10]))
})

testthat::test_that("set_selected raises error when selection is not sorted", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_error(
    suppressWarnings(filter_state$set_selected(dates[c(10, 1)])),
    regexp = "the upper bound of the range lower than the lower bound"
  )
})

testthat::test_that("set_selected raises error when selection is not Date", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_error(
    filter_state$set_selected(c("a", "b")),
    "The array of set values must contain values coercible to Date."
  )
})

testthat::test_that("get_call returns call with limits imposed by constructor and selection", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_equal(
    shiny::isolate(filter_state$get_call()),
    quote(variable >= as.Date("2000-01-01") & variable <= as.Date("2000-01-10"))
  )
  filter_state$set_selected(dates[3:4])
  testthat::expect_equal(
    shiny::isolate(filter_state$get_call()),
    quote(variable >= as.Date("2000-01-03") & variable <= as.Date("2000-01-04"))
  )
})

testthat::test_that("set_keep_na changes whether call returned by get_call allows NA values", {
  variable <- c(dates, NA)
  filter_state <- DateFilterState$new(variable, varname = "variable")
  testthat::expect_identical(eval(shiny::isolate(filter_state$get_call()))[11], NA)
  filter_state$set_keep_na(TRUE)
  testthat::expect_identical(eval(shiny::isolate(filter_state$get_call()))[11], TRUE)
})

testthat::test_that("set_state accepts a named list with selected and keep_na elements", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_no_error(filter_state$set_state(list(selected = c(dates[2], dates[3]), keep_na = TRUE)))
  testthat::expect_error(
    filter_state$set_state(list(selected = c(dates[2], dates[3]), unknown = TRUE)),
    "all\\(names\\(state\\)"
  )
})

testthat::test_that("set_state sets values of selected and keep_na as provided in the list", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  filter_state$set_state(list(selected = c(dates[2], dates[3]), keep_na = TRUE))
  testthat::expect_identical(shiny::isolate(filter_state$get_selected()), c(dates[2], dates[3]))
  testthat::expect_true(shiny::isolate(filter_state$get_keep_na()))
})


testthat::test_that("set_state overwrites fields included in the input only", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  filter_state$set_state(list(selected = c(dates[2], dates[3]), keep_na = TRUE))
  testthat::expect_no_error(filter_state$set_state(list(selected = c(dates[3], dates[4]))))
  testthat::expect_identical(shiny::isolate(filter_state$get_selected()), c(dates[3], dates[4]))
  testthat::expect_true(shiny::isolate(filter_state$get_keep_na()))
})

testthat::test_that(
  "DateFilterState$is_any_filtered works properly when NA is present in data",
  code = {
    filter_state <- teal.slice:::DateFilterState$new(
      c(dates, NA),
      varname = "x",
      dataname = "data",
      extract_type = character(0)
    )

    shiny::isolate(filter_state$set_keep_na(FALSE))
    shiny::isolate(filter_state$set_selected(c(dates[1], dates[10])))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_keep_na(TRUE))
    shiny::isolate(filter_state$set_selected(c(dates[1], dates[10])))
    testthat::expect_false(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_keep_na(TRUE))
    shiny::isolate(filter_state$set_selected(c(dates[2], dates[10])))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_keep_na(TRUE))
    shiny::isolate(filter_state$set_selected(c(dates[1], dates[9])))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )
  }
)

# Format
testthat::test_that("$format() is a FilterStates's method that accepts indent", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_no_error(shiny::isolate(filter_state$format(indent = 0)))
})

testthat::test_that("$format() asserts that indent is numeric", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  testthat::expect_error(
    filter_state$format(indent = "wrong type"),
    regexp = "Assertion on 'indent' failed: Must be of type 'number'"
  )
})

testthat::test_that("$format() returns a string representation the FilterState object", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  filter_state$set_state(list(selected = range(dates)))
  testthat::expect_equal(
    shiny::isolate(filter_state$format(indent = 0)),
    paste(
      "Filtering on: variable",
      "  Selected range: 2000-01-01 - 2000-01-10",
      "  Include missing values: FALSE",
      sep = "\n"
    )
  )
})

testthat::test_that("$format() prepends spaces to every line of the returned string", {
  filter_state <- DateFilterState$new(dates, varname = "variable")
  filter_state$set_state(list(selected = range(dates)))
  for (i in 1:3) {
    whitespace_indent <- paste0(rep(" ", i), collapse = "")
    testthat::expect_equal(
      shiny::isolate(filter_state$format(indent = !!(i))),
      sprintf(
        "%sFiltering on: variable\n%1$s  Selected range: 2000-01-01 - 2000-01-10\n%1$s  Include missing values: FALSE",
        format("", width = i)
      )
    )
  }
})
