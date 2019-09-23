#' Resource resolver
#'
#' Helper class for building a Client that implements the access to the data or the
#' computation unit.
#'
#' @section Methods:
#'
#' \code{$new()} Create new ResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class ResourceResolver
#' @import R6
#' @export
ResourceResolver <- R6::R6Class(
  "ResourceResolver",
  public = list(
    initialize = function() {},
    isFor = function(x) {
      "resource" %in% class(x)
    },
    newClient = function(x) {
      stop("Operation not implemented")
    }
  )
)
