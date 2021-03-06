% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MariaDBResourceConnector.R
\docType{class}
\name{MariaDBResourceConnector}
\alias{MariaDBResourceConnector}
\title{MariaDB DBI resource connector}
\format{
A R6 object of class MariaDBResourceConnector
}
\description{
MariaDB DBI resource connector

MariaDB DBI resource connector
}
\details{
Makes a MariaDB/MySQL DBI connection from a resource description.
}
\section{Super class}{
\code{\link[resourcer:DBIResourceConnector]{resourcer::DBIResourceConnector}} -> \code{MariaDBResourceConnector}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{MariaDBResourceConnector$new()}}
\item \href{#method-isFor}{\code{MariaDBResourceConnector$isFor()}}
\item \href{#method-createDBIConnection}{\code{MariaDBResourceConnector$createDBIConnection()}}
\item \href{#method-clone}{\code{MariaDBResourceConnector$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="resourcer" data-topic="DBIResourceConnector" data-id="closeDBIConnection">}\href{../../resourcer/html/DBIResourceConnector.html#method-closeDBIConnection}{\code{resourcer::DBIResourceConnector$closeDBIConnection()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Creates a new MariaDBResourceConnector instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MariaDBResourceConnector$new()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
A MariaDBResourceConnector object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-isFor"></a>}}
\if{latex}{\out{\hypertarget{method-isFor}{}}}
\subsection{Method \code{isFor()}}{
Check that the provided resource has a URL that locates a MySQL or MariaDB object: the URL scheme must be "mysql" or "mariadb".
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MariaDBResourceConnector$isFor(resource)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{resource}}{The resource object to validate.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A logical.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-createDBIConnection"></a>}}
\if{latex}{\out{\hypertarget{method-createDBIConnection}{}}}
\subsection{Method \code{createDBIConnection()}}{
Creates a DBI connection object from a resource.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MariaDBResourceConnector$createDBIConnection(resource)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{resource}}{A valid resource object.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A DBI connection object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MariaDBResourceConnector$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
