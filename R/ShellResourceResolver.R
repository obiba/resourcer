#' Shell Resource resolver
#'
#' The resource is a computation unit, accessible by issuing local system commands, i.e. which URL scheme is "sh".
#'
#' @docType class
#' @format A R6 object of class ShellResourceResolver
#' @import R6
#' @export
ShellResourceResolver <- R6::R6Class(
  "ShellResourceResolver",
  inherit = ResourceResolver,
  public = list(

    #' @description Check that the provided resource is a computation resource accessible by shell commands. The resource URL scheme must be "sh" or "shell".
    #' @param x The resource object.
    #' @return A logical.
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme %in% c("sh", "shell") && is.null(x$format)
      } else {
        FALSE
      }
    },

    #' @description Create a ShellResourceClient instance from the provided resource.
    #' @param x A valid resource object.
    #' @return A ShellResourceClient object.
    newClient = function(x) {
      if (self$isFor(x)) {
        ShellResourceClient$new(x)
      } else {
        stop("Resource is not a shell computation resource")
      }
    }

  )
)
