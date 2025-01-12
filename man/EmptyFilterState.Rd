% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilterStateEmpty.R
\docType{class}
\name{EmptyFilterState}
\alias{EmptyFilterState}
\title{\code{FilterState} object for empty variable}
\description{
\code{FilterState} subclass representing an empty variable
}
\examples{
filter_state <- teal.slice:::EmptyFilterState$new(
  NA,
  varname = "x",
  dataname = "data",
  extract_type = character(0)
)
isolate(filter_state$get_call())
isolate(filter_state$set_selected(TRUE))
isolate(filter_state$set_keep_na(TRUE))
isolate(filter_state$get_call())

}
\keyword{internal}
\section{Super class}{
\code{\link[teal.slice:FilterState]{teal.slice::FilterState}} -> \code{EmptyFilterState}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-EmptyFilterState-new}{\code{EmptyFilterState$new()}}
\item \href{#method-EmptyFilterState-is_any_filtered}{\code{EmptyFilterState$is_any_filtered()}}
\item \href{#method-EmptyFilterState-get_call}{\code{EmptyFilterState$get_call()}}
\item \href{#method-EmptyFilterState-get_state}{\code{EmptyFilterState$get_state()}}
\item \href{#method-EmptyFilterState-set_state}{\code{EmptyFilterState$set_state()}}
\item \href{#method-EmptyFilterState-clone}{\code{EmptyFilterState$clone()}}
}
}
\if{html}{\out{
<details><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="destroy_observers"><a href='../../teal.slice/html/FilterState.html#method-FilterState-destroy_observers'><code>teal.slice::FilterState$destroy_observers()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="format"><a href='../../teal.slice/html/FilterState.html#method-FilterState-format'><code>teal.slice::FilterState$format()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="get_dataname"><a href='../../teal.slice/html/FilterState.html#method-FilterState-get_dataname'><code>teal.slice::FilterState$get_dataname()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="get_keep_na"><a href='../../teal.slice/html/FilterState.html#method-FilterState-get_keep_na'><code>teal.slice::FilterState$get_keep_na()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="get_selected"><a href='../../teal.slice/html/FilterState.html#method-FilterState-get_selected'><code>teal.slice::FilterState$get_selected()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="get_varlabel"><a href='../../teal.slice/html/FilterState.html#method-FilterState-get_varlabel'><code>teal.slice::FilterState$get_varlabel()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="get_varname"><a href='../../teal.slice/html/FilterState.html#method-FilterState-get_varname'><code>teal.slice::FilterState$get_varname()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="print"><a href='../../teal.slice/html/FilterState.html#method-FilterState-print'><code>teal.slice::FilterState$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="server"><a href='../../teal.slice/html/FilterState.html#method-FilterState-server'><code>teal.slice::FilterState$server()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="set_keep_na"><a href='../../teal.slice/html/FilterState.html#method-FilterState-set_keep_na'><code>teal.slice::FilterState$set_keep_na()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="set_na_rm"><a href='../../teal.slice/html/FilterState.html#method-FilterState-set_na_rm'><code>teal.slice::FilterState$set_na_rm()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="set_selected"><a href='../../teal.slice/html/FilterState.html#method-FilterState-set_selected'><code>teal.slice::FilterState$set_selected()</code></a></span></li>
<li><span class="pkg-link" data-pkg="teal.slice" data-topic="FilterState" data-id="ui"><a href='../../teal.slice/html/FilterState.html#method-FilterState-ui'><code>teal.slice::FilterState$ui()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-EmptyFilterState-new"></a>}}
\if{latex}{\out{\hypertarget{method-EmptyFilterState-new}{}}}
\subsection{Method \code{new()}}{
Initialize \code{EmptyFilterState} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{EmptyFilterState$new(
  x,
  varname,
  varlabel = character(0),
  dataname = NULL,
  extract_type = character(0)
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{x}}{(\code{vector})\cr
values of the variable used in filter}

\item{\code{varname}}{(\code{character}, \code{name})\cr
name of the variable}

\item{\code{varlabel}}{(\code{character(1)})\cr
label of the variable (optional).}

\item{\code{dataname}}{(\code{character(1)})\cr
optional name of dataset where \code{x} is taken from}

\item{\code{extract_type}}{(\code{character(0)}, \code{character(1)})\cr
whether condition calls should be prefixed by dataname. Possible values:
\itemize{
\item{\code{character(0)} (default)}{ \code{varname} in the condition call will not be prefixed}
\item{\code{"list"}}{ \code{varname} in the condition call will be returned as \verb{<dataname>$<varname>}}
\item{\code{"matrix"}}{ \code{varname} in the condition call will be returned as \verb{<dataname>[, <varname>]}}
}}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-EmptyFilterState-is_any_filtered"></a>}}
\if{latex}{\out{\hypertarget{method-EmptyFilterState-is_any_filtered}{}}}
\subsection{Method \code{is_any_filtered()}}{
Reports whether the current state filters out any values.(?)
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{EmptyFilterState$is_any_filtered()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{logical(1)}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-EmptyFilterState-get_call"></a>}}
\if{latex}{\out{\hypertarget{method-EmptyFilterState-get_call}{}}}
\subsection{Method \code{get_call()}}{
Returns reproducible condition call for current selection relevant
for selected variable type.
Uses internal reactive values, hence must be called
in reactive or isolated context.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{EmptyFilterState$get_call()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{logical(1)}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-EmptyFilterState-get_state"></a>}}
\if{latex}{\out{\hypertarget{method-EmptyFilterState-get_state}{}}}
\subsection{Method \code{get_state()}}{
Returns the filtering state.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{EmptyFilterState$get_state()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{list} containing values taken from the reactive fields:
\itemize{
\item \code{keep_na} (\code{logical(1)}) whether \code{NA} should be kept.
}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-EmptyFilterState-set_state"></a>}}
\if{latex}{\out{\hypertarget{method-EmptyFilterState-set_state}{}}}
\subsection{Method \code{set_state()}}{
Set state.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{EmptyFilterState$set_state(state)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{state}}{(\code{list})\cr
contains fields relevant for specific class:
\itemize{
\item{\code{keep_na} (\code{logical})}{ defines whether to keep or remove \code{NA} values}
}}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
NULL invisibly
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-EmptyFilterState-clone"></a>}}
\if{latex}{\out{\hypertarget{method-EmptyFilterState-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{EmptyFilterState$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
