#' Coerce a resource to a data.frame
#'
#' Attempt to coerce a resource object to a data.frame: find a ResourceResolver and get the
#' ResourceClient that will connect to the described dataset and make a data.frame of it.
#'
#' @param x a resource object.
#' @param ... additional parameters, that may be used (or ignored) by the resource client.
#'
#' @return a data.frame (or a tibble)
#'
#' @export
as.data.frame.resource <- function(x, ...) {
  # find scheme resolver
  resolver <- resolveResource(x)
  if (is.null(resolver)) {
    stop("No resource resolver found for ", x$url)
  }
  # coerce resource data to a data.frame
  client <- resolver$newClient(x)
  df <- client$asDataFrame(...)
  client$close()
  df
}

#' Coerce a ResourceClient object to a data.frame
#'
#' Attempt to coerce a resource object to a data.frame: find a ResourceResolver and get the
#' ResourceClient that will connect to the described dataset and make a data.frame of it.
#'
#' @param x a ResourceClient object
#' @param ... additional parameters, that may be used (or ignored) by the resource client.
#'
#' @return a data.frame (or a tibble)
#'
#' @export
as.data.frame.ResourceClient <- function(x, ...) {
  x$asDataFrame(...)
}
