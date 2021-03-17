#' Coerce resource client to a data.frame
#'
#' Coerce a ResourceClient object to a data.frame.
#'
#' @param x The ResourceClient object to coerce to a data.frame.
#' @param strict logical whether the resulting object must be strictly of class data.frame or if it can be a tibble.
#' @param ... Additional parameters, that may be used (or ignored) by the resource client.
#'
#' @return a data.frame (or a tibble)
#' @export
as.resource.data.frame <- function(x, strict = FALSE, ...) {
  if ("ResourceClient" %in% class(x)) {
    df <- x$asDataFrame(...)
    if (strict) {
      as.data.frame(df)
    } else {
      df
    }
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
#' @param x The ResourceClient object to coerce to a data.frame.
#' @param ... Additional parameters, that may be used (or ignored) by the resource client.
#'
#' @return the internal data object.
#' @export
as.resource.object <- function(x, ...) {
  if ("ResourceClient" %in% class(x)) {
    # backward compatibility before ... was added
    tryCatch(x$getValue(...), error = function(e) {
      if (startsWith(e$message, "unused argument"))
        x$getValue()
      else
        stop(e)
      })
  } else {
    stop("Trying to coerce to data object, an object that is not a ResourceClient: ", paste0(class(x), collapse = ", "))
  }
}

#' Coerce resource client to a tbl
#'
#' Coerce a ResourceClient object to a dplyr's tbl.
#'
#' @param x The ResourceClient object to coerce to a data.frame
#' @param ... Additional parameters, that may be used (or ignored) by the resource client.
#'
#' @return a dplyr's tbl
#' @export
as.resource.tbl <- function(x, ...) {
  if ("ResourceClient" %in% class(x)) {
    x$asTbl(...)
  } else {
    stop("Trying to coerce to tbl an object that is not a ResourceClient: ", paste0(class(x), collapse = ", "))
  }
}
