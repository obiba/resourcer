#' SSH Resource resolver
#'
#' The resource is a computation unit, accessible through SSH, i.e. which URL scheme is "ssh".
#'
#' @docType class
#' @format A R6 object of class SshResourceResolver
#' @import R6
#' @export
SshResourceResolver <- R6::R6Class(
  "SshResourceResolver",
  inherit = ResourceResolver,
  public = list(

    #' @description Check that the provided resource is a computation resource accessible by ssh commands. The resource URL scheme is expected to be "ssh".
    #' @param x The resource object.
    #' @return A logical.
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme == "ssh" && is.null(x$format)
      } else {
        FALSE
      }
    },

    #' @description Create a SshResourceClient instance from the provided resource.
    #' @param x A valid resource object.
    #' @return A SshResourceClient object.
    newClient = function(x) {
      if (self$isFor(x)) {
        SshResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)
