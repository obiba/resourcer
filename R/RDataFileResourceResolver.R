#' R data file Resource resolver
#'
#' The resource is a R data file and data format is the class of the symbol that will be loaded.
#'
#' @docType class
#' @format A R6 object of class RDataFileResourceResolver
#' @import R6
#' @export
RDataFileResourceResolver <- R6::R6Class(
  "RDataFileResourceResolver",
  inherit = ResourceResolver,
  public = list(

    #' @description Check that the provided resource has a URL that locates a R data file: the resource can be accessed as a file and
    #'  the resource URL path ends with ".rda" or ".rdata" (case ignored), or the resource format is prefixed with "r:" or "rda:" (a kind of
    #'  namespace to qualify the R object class).
    #' @param x The resource object to validate.
    #' @return A logical.
    isFor = function(x) {
      if (super$isFor(x)) {
        fileName <- basename(super$parseURL(x)$path)
        # either file ends with .rda or .rdata, or format is prefixed with a namespace r or rda
        (length(grep(".*\\.(rda|rdata)$", tolower(fileName))) > 0 || startsWith(tolower(x$format), 'r:') || startsWith(tolower(x$format), 'rda:')) && !is.null(findFileResourceGetter(x))
      } else {
        FALSE
      }
    },

    #' @description Creates a RDataFileResourceClient instance from provided resource.
    #' @param x A valid resource object.
    #' @return A RDataFileResourceClient object.
    newClient = function(x) {
      if (self$isFor(x)) {
        RDataFileResourceClient$new(x)
      } else {
        stop("Resource is not located in a R data file")
      }
    }

  )
)


