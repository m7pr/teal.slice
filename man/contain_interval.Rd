% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilterState-utils.R
\name{contain_interval}
\alias{contain_interval}
\title{Find containing limits for interval.}
\usage{
contain_interval(x, range)
}
\arguments{
\item{x}{\code{numeric(2)} interval to contain}

\item{range}{\verb{numeric(>=2)} vector of values to contain \code{x} in}
}
\value{
Numeric vector of length 2 that lies within \code{range}.
}
\description{
Given an interval and a numeric vector,
find the smallest interval within the numeric vector that contains the interval.
}
\details{
This is a helper function for \code{RangeFilterState} that modifies slider selection
so that the \emph{subsetting call} includes the value specified by the filter API call.

Regardless of the underlying numeric data, the slider always presents 100 steps.
The ticks on the slider do not represent actual observations but rather borders between virtual bins.
Since the value selected on the slider is passed to \code{private$selected} and that in turn
updates the slider selection, programmatic selection of arbitrary values may inadvertently shift
the selection to the closest tick, thereby dropping the actual value set (if it exists in the data).

This function purposely shifts the selection to the closest ticks whose values form an interval
that will contain the interval defined by the filter API call.
}
\examples{
\dontrun{
ticks <- 1:10
values1 <- c(3, 5)
contain_interval(values1, ticks)
values2 <- c(3.1, 5.7)
contain_interval(values2, ticks)
values3 <- c(0, 20)
contain_interval(values3, ticks)
}
}
\keyword{internal}
