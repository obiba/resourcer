#' SSH Resource resolver
#'
#' The resource is a computation unit, accessible through SSH, i.e. which URL scheme is "ssh".
#'
#' @section Methods:
#'
#' \code{$new()} Create new SshResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class SshResourceResolver
#' @import R6
#' @export
SshResourceResolver <- R6::R6Class(
  "SshResourceResolver",
  inherit = ResourceResolver,
  public = list(
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme == "ssh" && is.null(x$format)
      } else {
        FALSE
      }
    },
    newClient = function(x) {
      if (self$isFor(x)) {
        SshResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)
