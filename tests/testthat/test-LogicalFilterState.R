logs <- as.logical(c(rbinom(10, 1, 0.5), NA))

testthat::test_that("The constructor accepts logical values", {
  testthat::expect_no_error(LogicalFilterState$new(c(TRUE), varname = "test"))
})

testthat::test_that("The constructor accepts NA values", {
  testthat::expect_no_error(LogicalFilterState$new(c(TRUE, NA), varname = "test"))
})

testthat::test_that("get_call returns FALSE values from data passed to selector", {
  filter_state <- LogicalFilterState$new(logs, varname = "logs")
  expect_identical(
    eval(shiny::isolate(filter_state$get_call())),
    !logs
  )
})

testthat::test_that("set_selected accepts a logical of length 1", {
  filter_state <- LogicalFilterState$new(logs, varname = "logs")
  testthat::expect_no_error(filter_state$set_selected(TRUE))
  testthat::expect_no_error(filter_state$set_selected(FALSE))
  testthat::expect_error(filter_state$set_selected(c(TRUE, TRUE)), "should be a logical scalar")
})

testthat::test_that("set_selected accepts a non-logical coercible to logical of length 1", {
  filter_state <- LogicalFilterState$new(logs, varname = "logs")
  testthat::expect_no_error(filter_state$set_selected("TRUE"))
  testthat::expect_no_error(filter_state$set_selected("FALSE"))
  testthat::expect_error(filter_state$set_selected(c("TRUE", "TRUE")), "should be a logical scalar")
})

testthat::test_that("get_call returns appropriate call depending on selection state", {
  filter_state <- LogicalFilterState$new(logs, varname = "logs")
  expect_identical(
    shiny::isolate(filter_state$get_call()),
    quote(!logs)
  )
  filter_state$set_selected(TRUE)
  expect_identical(
    shiny::isolate(filter_state$get_call()),
    quote(logs)
  )
  filter_state$set_keep_na(TRUE)
  expect_identical(
    shiny::isolate(filter_state$get_call()),
    quote(is.na(logs) | logs)
  )
})

testthat::test_that("set_state needs a named list with selected and keep_na elements", {
  filter_state <- LogicalFilterState$new(x = c(TRUE, FALSE, NA), varname = "test")
  testthat::expect_no_error(filter_state$set_state(list(selected = FALSE, keep_na = TRUE)))
  testthat::expect_error(filter_state$set_state(list(selected = TRUE, unknown = TRUE)), "all\\(names\\(state\\)")
})

testthat::test_that("set_state sets values of selected and keep_na as provided in the list", {
  filter_state <- LogicalFilterState$new(x = c(TRUE, FALSE, NA), varname = "test")
  filter_state$set_state(list(selected = FALSE, keep_na = TRUE))
  testthat::expect_identical(shiny::isolate(filter_state$get_selected()), FALSE)
  testthat::expect_true(shiny::isolate(filter_state$get_keep_na()))
})

testthat::test_that("set_state overwrites fields included in the input only", {
  filter_state <- LogicalFilterState$new(x = c(TRUE, FALSE, NA), varname = "test")
  filter_state$set_state(list(selected = FALSE, keep_na = TRUE))
  testthat::expect_no_error(filter_state$set_state(list(selected = TRUE)))
  testthat::expect_true(shiny::isolate(filter_state$get_selected()))
  testthat::expect_true(shiny::isolate(filter_state$get_keep_na()))
})

testthat::test_that(
  "LogicalFilterState$is_any_filtered works properly when NA is present in data",
  code = {
    filter_state <- teal.slice:::LogicalFilterState$new(
      rep(c(TRUE, NA), 10),
      varname = "x",
      dataname = "data",
      extract_type = character(0)
    )
    shiny::isolate(filter_state$set_selected(TRUE))

    shiny::isolate(filter_state$set_keep_na(TRUE))
    testthat::expect_false(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_keep_na(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )
  }
)

testthat::test_that(
  "LogicalFilterState$is_any_filtered works properly when both TRUE and FALSE are present",
  code = {
    filter_state <- teal.slice:::LogicalFilterState$new(
      rep(c(TRUE, FALSE, NA), 10),
      varname = "x",
      dataname = "data",
      extract_type = character(0)
    )
    shiny::isolate(filter_state$set_selected(TRUE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(TRUE))
    shiny::isolate(filter_state$set_keep_na(TRUE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(TRUE))
    shiny::isolate(filter_state$set_keep_na(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(FALSE))
    shiny::isolate(filter_state$set_keep_na(TRUE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(FALSE))
    shiny::isolate(filter_state$set_keep_na(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )
  }
)

testthat::test_that(
  "LogicalFilterState$is_any_filtered works properly when only TRUE or FALSE is present",
  code = {
    filter_state <- teal.slice:::LogicalFilterState$new(
      rep(c(TRUE, NA), 10),
      varname = "x",
      dataname = "data",
      extract_type = character(0)
    )
    shiny::isolate(filter_state$set_selected(TRUE))
    shiny::isolate(filter_state$set_keep_na(TRUE))
    testthat::expect_false(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(TRUE))
    shiny::isolate(filter_state$set_keep_na(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(FALSE))
    shiny::isolate(filter_state$set_keep_na(TRUE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(FALSE))
    shiny::isolate(filter_state$set_keep_na(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    filter_state <- teal.slice:::LogicalFilterState$new(
      rep(c(FALSE, NA), 10),
      varname = "x",
      dataname = "data",
      extract_type = character(0)
    )
    shiny::isolate(filter_state$set_selected(FALSE))
    shiny::isolate(filter_state$set_keep_na(TRUE))
    testthat::expect_false(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(FALSE))
    shiny::isolate(filter_state$set_keep_na(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(TRUE))
    shiny::isolate(filter_state$set_keep_na(TRUE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )

    shiny::isolate(filter_state$set_selected(TRUE))
    shiny::isolate(filter_state$set_keep_na(FALSE))
    testthat::expect_true(
      shiny::isolate(filter_state$is_any_filtered())
    )
  }
)
