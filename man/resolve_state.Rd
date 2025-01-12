% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resolve_state.R
\name{resolve_state}
\alias{resolve_state}
\alias{resolve_state.default}
\alias{resolve_state.default_filter}
\alias{resolve_state.list}
\title{Resolve list of filter states}
\usage{
resolve_state(x)

\method{resolve_state}{default}(x)

\method{resolve_state}{default_filter}(x, filter_state)

\method{resolve_state}{list}(x)
}
\arguments{
\item{x}{(\code{list},\code{vector})\cr
values of the variable used in filter. Depending on the \code{FilterState} type
list must contain these fields:
\itemize{
\item{\code{selected}}{ defines initial selection. See notes for more details}
\item{\code{keep_na} (\code{logical})}{ defines whether to keep or remove \code{NA} values}
\item{\code{keep_inf} (\code{logical})}{ defines whether to keep or remove \code{Inf} values}
}
If \code{vector} is provided then \code{keep_na} and \code{keep_inf} can be specified
adding \code{NA} and \code{Inf} to the selection vector.}
}
\value{
\code{list} containing \code{selected}, \code{keep_na} and \code{keep_inf}
}
\description{
Resolves the state values for \code{FilterState$set_state()}, which accepts only a list
with \code{selected},\code{keep_na} and \code{keep_inf} fields. In case of the \code{default_filter} function,
it returns \code{NULL} as during the initialization of \code{FilterState} values are set to
default.
}
\note{
The value of the \code{x$selected} needs to be modified according to the type
of the passed \code{filter_state}.
}
\examples{
teal.slice:::resolve_state(list(c(1, 2), keep_na = FALSE, keep_inf = TRUE))
teal.slice:::resolve_state(c(1, 2, Inf))
teal.slice:::resolve_state(list())
}
\seealso{
\itemize{
\item \link{LogicalFilterState}
\item \link{ChoicesFilterState}
\item \link{RangeFilterState}
\item \link{DateFilterState}
\item \link{DatetimeFilterState}
}
}
\keyword{internal}
