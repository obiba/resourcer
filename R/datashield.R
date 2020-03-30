#' Coerce resource client to a data.frame
#'
#' Coerce a ResourceClient object to a data.frame.
#'
#' @param x The ResourceClient object to coerce to a data.frame
#'
#' @export
as.resource.data.frame <- function(x) {
  if ("ResourceClient" %in% class(x)) {
    x$asDataFrame()
  } else {
    stop("Trying to coerce to data.frame an object that is not a ResourceClient: ", paste0(class(x), collapse = ", "))
  }
}

#' Coerce resource client to the internal data object
#'
#' Coerce a ResourceClient object to internal data object: depending on the implementation of the ResourceClient,
#' it can be a data connection object (like a DBI connection to a SQL database),
#' or the actual data structure (when a resource is a R object extracted from a R data file for instance).
#'
#' @param x The ResourceClient object to coerce to a data.frame
#'
#' @export
as.resource.object <- function(x) {
  if ("ResourceClient" %in% class(x)) {
    x$getValue()
  } else {
    stop("Trying to coerce to data object, an object that is not a ResourceClient: ", paste0(class(x), collapse = ", "))
  }
}


#' Coerce resource client to a tbl
#'
#' Coerce a ResourceClient object to a dplyr's tbl.
#'
#' @param x The ResourceClient object to coerce to a data.frame
#'
#' @export
as.resource.tbl <- function(x) {
  if ("ResourceClient" %in% class(x)) {
    x$asTbl()
  } else {
    stop("Trying to coerce to tbl an object that is not a ResourceClient: ", paste0(class(x), collapse = ", "))
  }
}
