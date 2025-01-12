% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilteredData.R
\docType{class}
\name{FilteredData}
\alias{FilteredData}
\title{Class to encapsulate filtered datasets}
\description{
Class to encapsulate filtered datasets

Class to encapsulate filtered datasets
}
\details{
The main purpose of this class is to provide a collection of reactive datasets,
each dataset having a filter state that determines how it is filtered.

For each dataset, \code{get_filter_expr} returns the call to filter the dataset according
to the filter state. The data itself can be obtained through \code{get_data}.

The datasets are filtered lazily, i.e. only when requested / needed in a Shiny app.

By design, any dataname set through \code{set_dataset} cannot be removed because
other code may already depend on it. As a workaround, the underlying
data can be set to \code{NULL}.

The class currently supports variables of the following types within datasets:
\itemize{
\item \code{choices}: variable of type \code{factor}, e.g. \code{ADSL$COUNTRY}, \code{iris$Species}
zero or more options can be selected, when the variable is a factor
\item \code{logical}: variable of type \code{logical}, e.g. \code{ADSL$TRT_FLAG}
exactly one option must be selected, \code{TRUE} or \code{FALSE}
\item \code{ranges}: variable of type \code{numeric}, e.g. \code{ADSL$AGE}, \code{iris$Sepal.Length}
numerical range, a range within this range can be selected
\item \code{dates}: variable of type \code{Date}, \code{POSIXlt}
Other variables cannot be used for filtering the data in this class.
}

Common arguments are:
\enumerate{
\item \code{filtered}: whether to return a filtered result or not
\item \code{dataname}: the name of one of the datasets in this \code{FilteredData}
\item \code{varname}: one of the columns in a dataset
}
}
\examples{
library(shiny)
datasets <- teal.slice:::FilteredData$new(
  list(
    iris = list(dataset = iris),
    mtcars = list(dataset = mtcars, metadata = list(type = "training"))
  )
)

# get datanames
datasets$datanames()

df <- datasets$get_data("iris", filtered = FALSE)
print(df)

datasets$get_metadata("mtcars")

isolate(
  datasets$set_filter_state(
    list(iris = list(Species = list(selected = "virginica")))
  )
)
isolate(datasets$get_call("iris"))

isolate(
  datasets$set_filter_state(
    list(mtcars = list(mpg = list(selected = c(15, 20))))
  )
)

isolate(datasets$get_filter_state())
isolate(datasets$get_filter_overview("iris"))
isolate(datasets$get_filter_overview("mtcars"))
isolate(datasets$get_call("iris"))
isolate(datasets$get_call("mtcars"))


## ------------------------------------------------
## Method `FilteredData$get_formatted_filter_state`
## ------------------------------------------------

utils::data(miniACC, package = "MultiAssayExperiment")
datasets <- teal.slice:::FilteredData$new(
  list(iris = list(dataset = iris),
       mae = list(dataset = miniACC)
  ),
  join_keys = NULL
)
fs <- list(
  iris = list(
    Sepal.Length = list(selected = c(5.1, 6.4), keep_na = TRUE, keep_inf = FALSE),
    Species = list(selected = c("setosa", "versicolor"), keep_na = FALSE)
  ),
  mae = list(
    subjects = list(
      years_to_birth = list(selected = c(30, 50), keep_na = TRUE, keep_inf = FALSE),
      vital_status = list(selected = "1", keep_na = FALSE),
      gender = list(selected = "female", keep_na = TRUE)
    ),
    RPPAArray = list(
      subset = list(ARRAY_TYPE = list(selected = "", keep_na = TRUE))
    )
  )
)
isolate(datasets$set_filter_state(state = fs))
cat(shiny::isolate(datasets$get_formatted_filter_state()))


## ------------------------------------------------
## Method `FilteredData$set_filter_state`
## ------------------------------------------------

utils::data(miniACC, package = "MultiAssayExperiment")

datasets <- teal.slice:::FilteredData$new(
  list(iris = list(dataset = iris),
       mae = list(dataset = miniACC)
  ),
  join_keys = NULL
)
fs <- list(
  iris = list(
    Sepal.Length = list(selected = c(5.1, 6.4), keep_na = TRUE, keep_inf = FALSE),
    Species = list(selected = c("setosa", "versicolor"), keep_na = FALSE)
  ),
  mae = list(
    subjects = list(
      years_to_birth = list(selected = c(30, 50), keep_na = TRUE, keep_inf = FALSE),
      vital_status = list(selected = "1", keep_na = FALSE),
      gender = list(selected = "female", keep_na = TRUE)
    ),
    RPPAArray = list(
      subset = list(ARRAY_TYPE = list(selected = "", keep_na = TRUE))
    )
  )
)
shiny::isolate(datasets$set_filter_state(state = fs))
shiny::isolate(datasets$get_filter_state())

}
\keyword{internal}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-FilteredData-new}{\code{FilteredData$new()}}
\item \href{#method-FilteredData-datanames}{\code{FilteredData$datanames()}}
\item \href{#method-FilteredData-get_datalabel}{\code{FilteredData$get_datalabel()}}
\item \href{#method-FilteredData-get_filterable_datanames}{\code{FilteredData$get_filterable_datanames()}}
\item \href{#method-FilteredData-get_filterable_varnames}{\code{FilteredData$get_filterable_varnames()}}
\item \href{#method-FilteredData-set_filterable_varnames}{\code{FilteredData$set_filterable_varnames()}}
\item \href{#method-FilteredData-get_call}{\code{FilteredData$get_call()}}
\item \href{#method-FilteredData-get_code}{\code{FilteredData$get_code()}}
\item \href{#method-FilteredData-get_filtered_dataset}{\code{FilteredData$get_filtered_dataset()}}
\item \href{#method-FilteredData-get_data}{\code{FilteredData$get_data()}}
\item \href{#method-FilteredData-get_check}{\code{FilteredData$get_check()}}
\item \href{#method-FilteredData-get_metadata}{\code{FilteredData$get_metadata()}}
\item \href{#method-FilteredData-get_join_keys}{\code{FilteredData$get_join_keys()}}
\item \href{#method-FilteredData-get_filter_overview}{\code{FilteredData$get_filter_overview()}}
\item \href{#method-FilteredData-get_keys}{\code{FilteredData$get_keys()}}
\item \href{#method-FilteredData-get_varlabels}{\code{FilteredData$get_varlabels()}}
\item \href{#method-FilteredData-get_varnames}{\code{FilteredData$get_varnames()}}
\item \href{#method-FilteredData-handle_active_datanames}{\code{FilteredData$handle_active_datanames()}}
\item \href{#method-FilteredData-set_dataset}{\code{FilteredData$set_dataset()}}
\item \href{#method-FilteredData-set_join_keys}{\code{FilteredData$set_join_keys()}}
\item \href{#method-FilteredData-set_check}{\code{FilteredData$set_check()}}
\item \href{#method-FilteredData-set_code}{\code{FilteredData$set_code()}}
\item \href{#method-FilteredData-get_filter_state}{\code{FilteredData$get_filter_state()}}
\item \href{#method-FilteredData-get_formatted_filter_state}{\code{FilteredData$get_formatted_filter_state()}}
\item \href{#method-FilteredData-set_filter_state}{\code{FilteredData$set_filter_state()}}
\item \href{#method-FilteredData-remove_filter_state}{\code{FilteredData$remove_filter_state()}}
\item \href{#method-FilteredData-remove_all_filter_states}{\code{FilteredData$remove_all_filter_states()}}
\item \href{#method-FilteredData-restore_state_from_bookmark}{\code{FilteredData$restore_state_from_bookmark()}}
\item \href{#method-FilteredData-filter_panel_disable}{\code{FilteredData$filter_panel_disable()}}
\item \href{#method-FilteredData-filter_panel_enable}{\code{FilteredData$filter_panel_enable()}}
\item \href{#method-FilteredData-get_filter_panel_active}{\code{FilteredData$get_filter_panel_active()}}
\item \href{#method-FilteredData-get_filter_panel_ui_id}{\code{FilteredData$get_filter_panel_ui_id()}}
\item \href{#method-FilteredData-ui_filter_panel}{\code{FilteredData$ui_filter_panel()}}
\item \href{#method-FilteredData-srv_filter_panel}{\code{FilteredData$srv_filter_panel()}}
\item \href{#method-FilteredData-ui_filter_overview}{\code{FilteredData$ui_filter_overview()}}
\item \href{#method-FilteredData-srv_filter_overview}{\code{FilteredData$srv_filter_overview()}}
\item \href{#method-FilteredData-clone}{\code{FilteredData$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-new"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-new}{}}}
\subsection{Method \code{new()}}{
Initialize a \code{FilteredData} object
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$new(data_objects, join_keys = NULL, code = NULL, check = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data_objects}}{(\code{list}) should contain.
\itemize{
\item \code{dataset} data object object supported by \code{\link{FilteredDataset}}.
\item \code{metatada} (optional) additional metadata attached to the \code{dataset}.
\item \code{keys} (optional) primary keys.
\item \code{datalabel} (optional) label describing the \code{dataset}.
\item \code{parent} (optional) which \code{NULL} is a parent of this one.
}}

\item{\code{join_keys}}{(\code{JoinKeys} or NULL) see \code{\link[teal.data:join_keys]{teal.data::join_keys()}}.}

\item{\code{code}}{(\code{CodeClass} or \code{NULL}) see \code{\link[teal.data:CodeClass]{teal.data::CodeClass}}.}

\item{\code{check}}{(\code{logical(1)}) whether data has been check against reproducibility.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-datanames"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-datanames}{}}}
\subsection{Method \code{datanames()}}{
Gets datanames

The datanames are returned in the order in which they must be
evaluated (in case of dependencies).
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$datanames()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
(\code{character} vector) of datanames
Gets data label for the dataset

Useful to display in \verb{Show R Code}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_datalabel"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_datalabel}{}}}
\subsection{Method \code{get_datalabel()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_datalabel(dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character}) keys of dataset
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_filterable_datanames"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_filterable_datanames}{}}}
\subsection{Method \code{get_filterable_datanames()}}{
Gets dataset names of a given dataname for the filtering.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_filterable_datanames(dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character} vector) names of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character} vector) of dataset names
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_filterable_varnames"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_filterable_varnames}{}}}
\subsection{Method \code{get_filterable_varnames()}}{
Gets variable names of a given dataname for the filtering.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_filterable_varnames(dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character} vector) of variable names
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-set_filterable_varnames"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-set_filterable_varnames}{}}}
\subsection{Method \code{set_filterable_varnames()}}{
Set the variable names of a given dataset for the filtering.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$set_filterable_varnames(dataname, varnames)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}

\item{\code{varnames}}{(\code{character} or \code{NULL})
variables which users can choose to filter the data;
see \code{self$get_filterable_varnames} for more details}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
this \code{FilteredData} object invisibly
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_call"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_call}{}}}
\subsection{Method \code{get_call()}}{
Gets a \code{call} to filter the dataset according to the filter state.

It returns a \code{call} to filter the dataset only, assuming the
other (filtered) datasets it depends on are available.

Together with \code{self$datanames()} which returns the datasets in the correct
evaluation order, this generates the whole filter code, see the function
\code{FilteredData$get_filter_code}.

For the return type, note that \code{rlang::is_expression} returns \code{TRUE} on the
return type, both for base R expressions and calls (single expression,
capturing a function call).

The filtered dataset has the name given by \code{self$filtered_dataname(dataname)}

This can be used for the \verb{Show R Code} generation.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_call(dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{call} or \code{list} of calls) to filter dataset calls
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_code"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_code}{}}}
\subsection{Method \code{get_code()}}{
Gets the R preprocessing code string that generates the unfiltered datasets.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_code(dataname = self$datanames())}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name(s) of dataset(s)}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character(1)}) deparsed code
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_filtered_dataset"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_filtered_dataset}{}}}
\subsection{Method \code{get_filtered_dataset()}}{
Gets \code{FilteredDataset} object which contains all information
pertaining to the specified dataset.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_filtered_dataset(dataname = character(0))}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)})\cr
name of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{FilteredDataset} object or list of \code{FilteredDataset}s
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_data"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_data}{}}}
\subsection{Method \code{get_data()}}{
Gets filtered or unfiltered dataset.

For \code{filtered = FALSE}, the original data set with
\code{set_data} is returned including all attributes.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_data(dataname, filtered = TRUE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}

\item{\code{filtered}}{(\code{logical}) whether to return a filtered or unfiltered dataset}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_check"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_check}{}}}
\subsection{Method \code{get_check()}}{
Returns whether the datasets in the object has undergone a reproducibility check.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_check()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{logical}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_metadata"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_metadata}{}}}
\subsection{Method \code{get_metadata()}}{
Gets metadata for a given dataset.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_metadata(dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
value of metadata for given data (or \code{NULL} if it does not exist)
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_join_keys"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_join_keys}{}}}
\subsection{Method \code{get_join_keys()}}{
Get join keys between two datasets.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_join_keys()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
(\code{JoinKeys})
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_filter_overview"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_filter_overview}{}}}
\subsection{Method \code{get_filter_overview()}}{
Get filter overview table in form of X (filtered) / Y (non-filtered).

This is intended to be presented in the application.
The content for each of the data names is defined in \code{get_filter_overview_info} method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_filter_overview(datanames)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{datanames}}{(\code{character} vector) names of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{matrix}) matrix of observations and subjects of all datasets
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_keys"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_keys}{}}}
\subsection{Method \code{get_keys()}}{
Get keys for the dataset.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_keys(dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character}) keys of dataset
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_varlabels"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_varlabels}{}}}
\subsection{Method \code{get_varlabels()}}{
Gets labels of variables in the data.

Variables are the column names of the data.
Either, all labels must have been provided for all variables
in \code{set_data} or \code{NULL}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_varlabels(dataname, variables = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character(1)}) name of the dataset}

\item{\code{variables}}{(\code{character}) variables to get labels for;
if \code{NULL}, for all variables in data}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character} or \code{NULL}) variable labels, \code{NULL} if \code{column_labels}
attribute does not exist for the data
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_varnames"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_varnames}{}}}
\subsection{Method \code{get_varnames()}}{
Gets variable names.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_varnames(dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataname}}{(\code{character}) the name of the dataset}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character} vector) of variable names
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-handle_active_datanames"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-handle_active_datanames}{}}}
\subsection{Method \code{handle_active_datanames()}}{
When active_datanames is "all", sets them to all \code{datanames},
otherwise, it makes sure that it is a subset of the available \code{datanames}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$handle_active_datanames(datanames)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{datanames}}{\verb{character vector} datanames to pick}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
the intersection of \code{self$datanames()} and \code{datanames}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-set_dataset"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-set_dataset}{}}}
\subsection{Method \code{set_dataset()}}{
Adds a dataset to this \code{FilteredData}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$set_dataset(dataset_args, dataname)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dataset_args}}{(\code{list})\cr
containing the arguments except (\code{dataname})
needed by \code{init_filtered_dataset}}

\item{\code{dataname}}{(\code{string})\cr
the name of the \code{dataset} to be added to this object}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
\code{set_dataset} creates a \code{FilteredDataset} object which keeps
\code{dataset} for the filtering purpose.
}

\subsection{Returns}{
(\code{self}) invisibly this \code{FilteredData}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-set_join_keys"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-set_join_keys}{}}}
\subsection{Method \code{set_join_keys()}}{
Set the \code{join_keys}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$set_join_keys(join_keys)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{join_keys}}{(\code{JoinKeys}) join_key (converted to a nested list)}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{self}) invisibly this \code{FilteredData}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-set_check"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-set_check}{}}}
\subsection{Method \code{set_check()}}{
Sets whether the datasets in the object have undergone a reproducibility check.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$set_check(check)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{check}}{(\code{logical}) whether datasets have undergone reproducibility check}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{self})
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-set_code"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-set_code}{}}}
\subsection{Method \code{set_code()}}{
Sets the R preprocessing code for single dataset.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$set_code(code)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{code}}{(\code{CodeClass})\cr
preprocessing code that can be parsed to generate the unfiltered datasets}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{self})
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_filter_state"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_filter_state}{}}}
\subsection{Method \code{get_filter_state()}}{
Gets the reactive values from the active \code{FilterState} objects.

Gets all active filters in the form of a nested list.
The output list is a compatible input to \code{self$set_filter_state}.
The attribute \code{formatted} renders the output of \code{self$get_formatted_filter_state},
which is a character formatting of the filter state.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_filter_state()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\verb{named list} with elements corresponding to \code{FilteredDataset} objects
with active filters. In addition, the \code{formatted} attribute holds
the character format of the active filter states.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_formatted_filter_state"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_formatted_filter_state}{}}}
\subsection{Method \code{get_formatted_filter_state()}}{
Returns the filter state formatted for printing to an \code{IO} device.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_formatted_filter_state()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} the pre-formatted filter state
}
\subsection{Examples}{
\if{html}{\out{<div class="r example copy">}}
\preformatted{utils::data(miniACC, package = "MultiAssayExperiment")
datasets <- teal.slice:::FilteredData$new(
  list(iris = list(dataset = iris),
       mae = list(dataset = miniACC)
  ),
  join_keys = NULL
)
fs <- list(
  iris = list(
    Sepal.Length = list(selected = c(5.1, 6.4), keep_na = TRUE, keep_inf = FALSE),
    Species = list(selected = c("setosa", "versicolor"), keep_na = FALSE)
  ),
  mae = list(
    subjects = list(
      years_to_birth = list(selected = c(30, 50), keep_na = TRUE, keep_inf = FALSE),
      vital_status = list(selected = "1", keep_na = FALSE),
      gender = list(selected = "female", keep_na = TRUE)
    ),
    RPPAArray = list(
      subset = list(ARRAY_TYPE = list(selected = "", keep_na = TRUE))
    )
  )
)
isolate(datasets$set_filter_state(state = fs))
cat(shiny::isolate(datasets$get_formatted_filter_state()))

}
\if{html}{\out{</div>}}

}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-set_filter_state"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-set_filter_state}{}}}
\subsection{Method \code{set_filter_state()}}{
Sets active filter states.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$set_filter_state(state)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{state}}{(\verb{named list})\cr
nested list of filter selections applied to datasets}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{NULL}
}
\subsection{Examples}{
\if{html}{\out{<div class="r example copy">}}
\preformatted{utils::data(miniACC, package = "MultiAssayExperiment")

datasets <- teal.slice:::FilteredData$new(
  list(iris = list(dataset = iris),
       mae = list(dataset = miniACC)
  ),
  join_keys = NULL
)
fs <- list(
  iris = list(
    Sepal.Length = list(selected = c(5.1, 6.4), keep_na = TRUE, keep_inf = FALSE),
    Species = list(selected = c("setosa", "versicolor"), keep_na = FALSE)
  ),
  mae = list(
    subjects = list(
      years_to_birth = list(selected = c(30, 50), keep_na = TRUE, keep_inf = FALSE),
      vital_status = list(selected = "1", keep_na = FALSE),
      gender = list(selected = "female", keep_na = TRUE)
    ),
    RPPAArray = list(
      subset = list(ARRAY_TYPE = list(selected = "", keep_na = TRUE))
    )
  )
)
shiny::isolate(datasets$set_filter_state(state = fs))
shiny::isolate(datasets$get_filter_state())

}
\if{html}{\out{</div>}}

}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-remove_filter_state"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-remove_filter_state}{}}}
\subsection{Method \code{remove_filter_state()}}{
Removes one or more \code{FilterState} of a \code{FilteredDataset} in a \code{FilteredData} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$remove_filter_state(state)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{state}}{(\verb{named list})\cr
nested list of filter selections applied to datasets}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{NULL} invisibly
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-remove_all_filter_states"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-remove_all_filter_states}{}}}
\subsection{Method \code{remove_all_filter_states()}}{
Remove all \code{FilterStates} of a \code{FilteredDataset} or all \code{FilterStates}
of a \code{FilteredData} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$remove_all_filter_states(datanames = self$datanames())}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{datanames}}{(\code{character})\cr
datanames to remove their \code{FilterStates} or empty which removes
all \code{FilterStates} in the \code{FilteredData} object}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{NULL} invisibly
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-restore_state_from_bookmark"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-restore_state_from_bookmark}{}}}
\subsection{Method \code{restore_state_from_bookmark()}}{
Sets this object from a bookmarked state.

Only sets the filter state, does not set the data
and the preprocessing code. The data should already have been set.
Also checks the preprocessing code is identical if provided in the \code{state}.

Since this function is used from the end-user part, its error messages
are more verbose. We don't call the Shiny modals from here because this
class may be used outside of a Shiny app.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$restore_state_from_bookmark(state, check_data_hash = TRUE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{state}}{(\verb{named list})\cr
containing fields \code{data_hash}, \code{filter_states} and \code{preproc_code}}

\item{\code{check_data_hash}}{(\code{logical}) whether to check that \code{md5sums} agree
for the data; may not make sense with randomly generated data per session}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-filter_panel_disable"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-filter_panel_disable}{}}}
\subsection{Method \code{filter_panel_disable()}}{
Disable the filter panel by adding \code{disable} class to \code{filter_add_vars}
and \code{filter_panel_active_vars} tags in the User Interface.
In addition, it will store the existing filter states in a private field called \code{cached_states}
before removing all filter states from the object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$filter_panel_disable()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-filter_panel_enable"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-filter_panel_enable}{}}}
\subsection{Method \code{filter_panel_enable()}}{
enable the filter panel
Enable the filter panel by adding \code{enable} class to \code{filter_add_vars}
and \code{filter_active_vars} tags in the User Interface.
In addition, it will restore the filter states from a private field called \code{cached_states}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$filter_panel_enable()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_filter_panel_active"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_filter_panel_active}{}}}
\subsection{Method \code{get_filter_panel_active()}}{
Gets the state of filter panel, if activated.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_filter_panel_active()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-get_filter_panel_ui_id"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-get_filter_panel_ui_id}{}}}
\subsection{Method \code{get_filter_panel_ui_id()}}{
Gets the id of the filter panel UI.
Module for the right filter panel in the teal app
with a filter overview panel and a filter variable panel.

This panel contains info about the number of observations left in
the (active) datasets and allows to filter the datasets.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$get_filter_panel_ui_id()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-ui_filter_panel"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-ui_filter_panel}{}}}
\subsection{Method \code{ui_filter_panel()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$ui_filter_panel(id)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{(\code{character(1)})\cr
module id
Server function for filter panel}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-srv_filter_panel"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-srv_filter_panel}{}}}
\subsection{Method \code{srv_filter_panel()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$srv_filter_panel(id, active_datanames = function() "all")}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{(\code{character(1)})\cr
an ID string that corresponds with the ID used to call the module's UI function.}

\item{\code{active_datanames}}{\verb{function / reactive} returning datanames that
should be shown on the filter panel,
must be a subset of the \code{datanames} argument provided to \code{ui_filter_panel};
if the function returns \code{NULL} (as opposed to \code{character(0)}), the filter
panel will be hidden}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{moduleServer} function which returns \code{NULL}
Creates the UI for the module showing counts for each dataset
contrasting the filtered to the full unfiltered dataset

Per dataset, it displays
the number of rows/observations in each dataset,
the number of unique subjects.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-ui_filter_overview"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-ui_filter_overview}{}}}
\subsection{Method \code{ui_filter_overview()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$ui_filter_overview(id)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{module id
Server function to display the number of records in the filtered and unfiltered
data}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-srv_filter_overview"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-srv_filter_overview}{}}}
\subsection{Method \code{srv_filter_overview()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$srv_filter_overview(id, active_datanames = function() "all")}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{(\code{character(1)})\cr
an ID string that corresponds with the ID used to call the module's UI function.}

\item{\code{active_datanames}}{(\code{function}, \code{reactive})\cr
returning datanames that should be shown on the filter panel,
must be a subset of the \code{datanames} argument provided to \code{ui_filter_panel};
if the function returns \code{NULL} (as opposed to \code{character(0)}), the filter
panel will be hidden.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{moduleServer} function which returns \code{NULL}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilteredData-clone"></a>}}
\if{latex}{\out{\hypertarget{method-FilteredData-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilteredData$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
