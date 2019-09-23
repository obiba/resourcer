#' Resource client
#'
#' Helper class for conecting to a resource data store or a computation unit.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new ResourceClient instance from provided resource object.
#' \code{$getResource()} Get the resource reference object.
#' \code{$getConnection()} Get the raw connection object to the resource.
#' \code{$downloadFile(fileext)} Coerce the resource to a file with provided file extension.
#' \code{$asDataFrame()} Coerce the resource to a data.frame.
#' \code{$close()} Close the connection with the resource.
#'
#' @docType class
#' @format A R6 object of class ResourceClient
#' @import R6
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
    downloadFile = function(fileext = "") {
      stop("Operation not implemented")
    },
    asDataFrame = function(...) {
      stop("Operation not implemented")
    },
    close = function() {
      stop("Operation not implemented")
    }
  ),
  private = list(
    .resource = NULL,
    .connection = NULL
  )
)
