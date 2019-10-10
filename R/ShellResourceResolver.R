#' Shell Resource resolver
#'
#' The resource is a computation unit, accessible by issuing local system commands, i.e. which URL scheme is "sh".
#'
#' @section Methods:
#'
#' \code{$new()} Create new ShellResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class ShellResourceResolver
#' @import R6
#' @export
ShellResourceResolver <- R6::R6Class(
  "ShellResourceResolver",
  inherit = ResourceResolver,
  public = list(
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme %in% c("sh", "shell") && is.null(x$format)
      } else {
        FALSE
      }
    },
    newClient = function(x) {
      if (self$isFor(x)) {
        ShellResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)
