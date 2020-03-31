#' Resource client
#'
#' Helper class for connecting to a resource data store or a computation unit.
#'
#' @docType class
#' @format A R6 object of class ResourceClient
#' @import R6
#' @import httr
#' @export
ResourceClient <- R6::R6Class(
  "ResourceClient",
  public = list(

    #' @description Creates a ResourceClient instance.
    #' @param resource The resource object to be interprated.
    #' @return A ResourceClient object.
    initialize = function(resource) {
      private$.resource <- resource
    },

    #' @description Get the resource object.
    #' @return The resource object.
    getResource = function() {
      private$.resource
    },

    #' @description Get the implementation-specific object that connects to the resource
    #' @return The connection object.
    getConnection = function() {
      private$.connection
    },

    #' @description Stub function to be implemented by subclasses if relevant. Get the resource as a local file.
    #' @param ... Additional parameters.
    #' @return The path to the local file.
    downloadFile = function(...) {
      stop("Operation not applicable")
    },

    #' @description Stub function to be implemented by subclasses if relevant. Coerce the resource as a data.frame.
    #' @param ... Additional parameters.
    #' @return A data.frame object (can also be a tibble).
    asDataFrame = function(...) {
      stop("Operation not applicable")
    },

    #' @description Stub function to be implemented by subclasses if relevant. Coerce the resource as a dplyr's tbl.
    #' @param ... Additional parameters.
    #' @return A dplyr's tbl object.
    asTbl = function(...) {
      private$loadDPlyr()
      dplyr::as.tbl(self$asDataFrame())
    },

    #' @description Stub function to be implemented by subclasses if relevant. Executes a command on a computation resource.
    #' @param ... Additional parameters that will represent the command to execute.
    #' @return A command execution result object.
    exec = function(...) {
      stop("Operation not applicable")
    },

    #' @description Silently closes the connection to the resource
    close = function() {
      # no-op
    }
  ),
  private = list(
    .resource = NULL,
    .connection = NULL,
    parseURL = function() {
      httr::parse_url(private$.resource$url)
    },
    parseQuery = function() {
      private$parseURL()$query
    },
    setConnection = function(conn) {
      private$.connection <- conn
    },
    loadDPlyr = function() {
      if (!require("dplyr")) {
        install.packages("dplyr", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)

#' Creates a resource client
#'
#' From a resource object, find the corresponding resolver in the resolver registry
#' and create a new resource client.
#'
#' @param x The resource object which corresponding resolver is to be found.
#'
#' @return The corresponding ResourceClient object or NULL if none applies.
#'
#' @examples
#' \donttest{
#' library(resourcer)
#' res <- newResource(
#'   name = "CNSIM1",
#'   url = "file:///data/CNSIM1.sav",
#'   format = "spss"
#' )
#' client <- newResourceClient(res)
#' }
#'
#' @export
newResourceClient <- function(x) {
  client <- NULL
  resolver <- resolveResource(x)
  if (!is.null(resolver)) {
    client <- resolver$newClient(x)
  }
  client
}

