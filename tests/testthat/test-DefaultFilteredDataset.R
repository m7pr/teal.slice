testthat::test_that("The constructor accepts a data.frame object with a dataname", {
  testthat::expect_no_error(DefaultFilteredDataset$new(dataset = head(iris), dataname = "iris"))
})

testthat::test_that("get_call returns a list of calls or NULL", {
  filtered_dataset <- DefaultFilteredDataset$new(
    dataset = iris, dataname = "iris"
  )
  testthat::expect_null(shiny::isolate(filtered_dataset$get_call()))
  fs <- list(
    Sepal.Length = c(5.1, 6.4),
    Species = c("setosa", "versicolor")
  )
  shiny::isolate(filtered_dataset$set_filter_state(state = fs))

  checkmate::expect_list(shiny::isolate(filtered_dataset$get_call()), types = "<-")
})

testthat::test_that(
  "DefaultFilteredDataset$set_filter_state sets filters specified by list names",
  code = {
    dataset <- DefaultFilteredDataset$new(dataset = iris, dataname = "iris")

    fs <- list(
      Sepal.Length = c(5.1, 6.4),
      Species = c("setosa", "versicolor")
    )
    shiny::isolate(dataset$set_filter_state(state = fs))
    testthat::expect_equal(
      shiny::isolate(dataset$get_call()),
      list(
        filter = quote(
          iris <- dplyr::filter(
            iris,
            Sepal.Length >= 5.1 & Sepal.Length <= 6.4 &
              Species %in% c("setosa", "versicolor")
          )
        )
      )
    )
  }
)

testthat::test_that(
  "DefaultFilteredDataset$set_filter_state throws error when list is not named",
  code = {
    dataset <- DefaultFilteredDataset$new(dataset = iris, dataname = "iris")
    fs <- list(
      c(5.1, 6.4),
      Species = c("setosa", "versicolor")
    )
    testthat::expect_error(dataset$set_filter_state(state = fs))
  }
)

testthat::test_that(
  "DefaultFilteredDataset$remove_filter_state removes desired filter",
  code = {
    dataset <- DefaultFilteredDataset$new(dataset = iris, dataname = "iris")
    fs <- list(
      Sepal.Length = c(5.1, 6.4),
      Species = c("setosa", "versicolor")
    )
    shiny::isolate(dataset$set_filter_state(state = fs))
    shiny::isolate(dataset$remove_filter_state("Species"))

    testthat::expect_equal(
      shiny::isolate(dataset$get_call()),
      list(
        filter = quote(
          iris <- dplyr::filter(
            iris,
            Sepal.Length >= 5.1 & Sepal.Length <= 6.4
          )
        )
      )
    )
  }
)

testthat::test_that(
  "DefaultFilteredDataset$get_filter_state returns list identical to input",
  code = {
    dataset <- DefaultFilteredDataset$new(dataset = iris, dataname = "iris")
    fs <- list(
      Sepal.Length = list(selected = c(5.1, 6.4), keep_na = TRUE, keep_inf = TRUE),
      Species = list(selected = c("setosa", "versicolor"), keep_na = FALSE)
    )
    shiny::isolate(dataset$set_filter_state(state = fs))
    testthat::expect_identical(shiny::isolate(dataset$get_filter_state()), fs)
  }
)

testthat::test_that(
  "DefaultFilteredDataset$remove_filter_state removes more than one filter",
  code = {
    dataset <- DefaultFilteredDataset$new(dataset = iris, dataname = "iris")
    fs <- list(
      Sepal.Length = c(5.1, 6.4),
      Species = c("setosa", "versicolor")
    )
    shiny::isolate(dataset$set_filter_state(state = fs))
    shiny::isolate(dataset$remove_filter_state(c("Species", "Sepal.Length")))

    testthat::expect_null(
      shiny::isolate(dataset$get_call())
    )
  }
)

testthat::test_that("get_filter_overview_info returns overview matrix for DefaultFilteredDataset without filtering", {
  testthat::expect_equal(
    shiny::isolate(DefaultFilteredDataset$new(
      dataset = utils::head(iris), dataname = "iris"
    )$get_filter_overview_info()),
    matrix(list("6/6", ""), nrow = 1, dimnames = list(c("iris"), c("Obs", "Subjects")))
  )
})

testthat::test_that(
  "get_filter_overview_info returns overview matrix for DefaultFilteredDataset if a filtered dataset is passed in",
  code = {
    dataset_iris <- DefaultFilteredDataset$new(dataset = utils::head(iris), dataname = "iris")
    testthat::expect_equal(
      shiny::isolate(
        dataset_iris$get_filter_overview_info(dplyr::filter(utils::head(iris), Species == "virginica"))
      ),
      matrix(list("0/6", ""), nrow = 1, dimnames = list(c("iris"), c("Obs", "Subjects")))
    )
  }
)
