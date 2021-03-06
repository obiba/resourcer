% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ResourceClient.R
\docType{class}
\name{ResourceClient}
\alias{ResourceClient}
\title{Resource client}
\format{
A R6 object of class ResourceClient
}
\description{
Resource client

Resource client
}
\details{
Helper class for connecting to a resource data store or a computation unit.
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{ResourceClient$new()}}
\item \href{#method-getResource}{\code{ResourceClient$getResource()}}
\item \href{#method-getConnection}{\code{ResourceClient$getConnection()}}
\item \href{#method-downloadFile}{\code{ResourceClient$downloadFile()}}
\item \href{#method-asDataFrame}{\code{ResourceClient$asDataFrame()}}
\item \href{#method-asTbl}{\code{ResourceClient$asTbl()}}
\item \href{#method-exec}{\code{ResourceClient$exec()}}
\item \href{#method-close}{\code{ResourceClient$close()}}
\item \href{#method-clone}{\code{ResourceClient$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Creates a ResourceClient instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$new(resource)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{resource}}{The resource object to be interprated.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A ResourceClient object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-getResource"></a>}}
\if{latex}{\out{\hypertarget{method-getResource}{}}}
\subsection{Method \code{getResource()}}{
Get the resource object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$getResource()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
The resource object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-getConnection"></a>}}
\if{latex}{\out{\hypertarget{method-getConnection}{}}}
\subsection{Method \code{getConnection()}}{
Get the implementation-specific object that connects to the resource
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$getConnection()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
The connection object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-downloadFile"></a>}}
\if{latex}{\out{\hypertarget{method-downloadFile}{}}}
\subsection{Method \code{downloadFile()}}{
Stub function to be implemented by subclasses if relevant. Get the resource as a local file.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$downloadFile(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Additional parameters.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
The path to the local file.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-asDataFrame"></a>}}
\if{latex}{\out{\hypertarget{method-asDataFrame}{}}}
\subsection{Method \code{asDataFrame()}}{
Stub function to be implemented by subclasses if relevant. Coerce the resource as a data.frame.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$asDataFrame(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Additional parameters.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A data.frame object (can also be a tibble).
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-asTbl"></a>}}
\if{latex}{\out{\hypertarget{method-asTbl}{}}}
\subsection{Method \code{asTbl()}}{
Stub function to be implemented by subclasses if relevant. Coerce the resource as a dplyr's tbl.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$asTbl(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Additional parameters.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A dplyr's tbl object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-exec"></a>}}
\if{latex}{\out{\hypertarget{method-exec}{}}}
\subsection{Method \code{exec()}}{
Stub function to be implemented by subclasses if relevant. Executes a command on a computation resource.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$exec(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Additional parameters that will represent the command to execute.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A command execution result object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-close"></a>}}
\if{latex}{\out{\hypertarget{method-close}{}}}
\subsection{Method \code{close()}}{
Silently closes the connection to the resource
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$close()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResourceClient$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
