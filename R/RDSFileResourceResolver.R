#' R object file Resource resolver
#'
#' The resource is a RDS file.
#'
#' @docType class
#' @format A R6 object of class RDSFileResourceResolver
#' @import R6
#' @export
RDSFileResourceResolver <- R6::R6Class(
  "RDSFileResourceResolver",
  inherit = ResourceResolver,
  public = list(

    #' @description Check that the provided resource has a URL that locates a R object file: the resource can be accessed as a file and
    #'  the resource URL path ends with ".rds" (case ignored), or the resource format is prefixed with "rds:" (a kind of
    #'  namespace to qualify the R object class).
    #' @param x The resource object to validate.
    #' @return A logical.
    isFor = function(x) {
      if (super$isFor(x)) {
        fileName <- basename(super$parseURL(x)$path)
        # either file ends with .rda or .RDS, or format is prefixed with a namespace r or rda
        (length(grep(".*\\.(rds)$", tolower(fileName))) > 0 || startsWith(tolower(x$format), 'rds:')) && !is.null(findFileResourceGetter(x))
      } else {
        FALSE
      }
    },

    #' @description Creates a RDSFileResourceClient instance from provided resource.
    #' @param x A valid resource object.
    #' @return A RDSFileResourceClient object.
    newClient = function(x) {
      if (self$isFor(x)) {
        RDSFileResourceClient$new(x)
      } else {
        stop("Resource is not located in a R object file")
      }
    }

  )
)


