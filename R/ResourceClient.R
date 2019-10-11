#' Resource client
#'
#' Helper class for connecting to a resource data store or a computation unit.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new ResourceClient instance from provided resource object.
#' \code{$getResource()} Get the resource reference object.
#' \code{$getConnection()} Get the raw connection object to the resource.
#' \code{$downloadFile(...)} Coerce the resource to a file with provided file extension.
#' \code{$asDataFrame(...)} Coerce the resource to a data.frame.
#' \code{$exec(...)} Execute an operation on the resource.
#' \code{$close()} Close the connection with the resource.
#'
#' @docType class
#' @format A R6 object of class ResourceClient
#' @import R6
#' @import httr
#' @export
ResourceClient <- R6::R6Class(
  "ResourceClient",
  public = list(
    initialize = function(resource) {
      private$.resource <- resource
    },
    getResource = function() {
      private$.resource
    },
    getConnection = function() {
      private$.connection
    },
    downloadFile = function(...) {
      stop("Operation not applicable")
    },
    asDataFrame = function(...) {
      stop("Operation not applicable")
    },
    asTbl = function(...) {
      private$loadDPlyr()
      dplyr::as.tbl(self$asDataFrame())
    },
    exec = function(...) {
      stop("Operation not applicable")
    },
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
#' @export
newResourceClient <- function(x) {
  client <- NULL
  resolver <- resolveResource(x)
  if (!is.null(resolver)) {
    client <- resolver$newClient(x)
  }
  client
}

