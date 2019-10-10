#' R data file Resource resolver
#'
#' The resource is a R data file and data format is the class of the symbol that will be loaded.
#'
#' @section Methods:
#'
#' \code{$new()} Create new RDataFileResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class RDataFileResourceResolver
#' @import R6
#' @export
RDataFileResourceResolver <- R6::R6Class(
  "RDataFileResourceResolver",
  inherit = ResourceResolver,
  public = list(
    isFor = function(x) {
      if (super$isFor(x)) {
        fileName <- basename(super$parseURL(x)$path)
        length(grep(".*\\.(rda|rdata)$", tolower(fileName))) > 0 && !is.null(findFileResourceGetter(x))
      } else {
        FALSE
      }
    },
    newClient = function(x) {
      if (self$isFor(x)) {
        RDataFileResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)


