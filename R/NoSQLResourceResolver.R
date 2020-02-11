#' NoSQL Database Resource resolver
#'
#' The resource is NoSQL database such as mongodb (elasticsearch, redis, couchdb, sqlite are not supported yet).
#'
#' @docType class
#' @format A R6 object of class NoSQLResourceResolver
#' @import R6
#' @export
NoSQLResourceResolver <- R6::R6Class(
  "NoSQLResourceResolver",
  inherit = ResourceResolver,
  public = list(

    #' @description Check that the provided resource has a URL that locates a nodbi object: the URL scheme must be one of "mongodb", "mongodb+srv". Other NoSQL databases "elasticsearch", "redis", "couchdb", "sqlite" are not supported yet.
    #' @param x The resource object to validate.
    #' @return A logical.
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme %in% c("mongodb", "mongodb+srv") && is.null(x$format)
      } else {
        FALSE
      }
    },

    #' @description Creates a NoSQLResourceClient instance from provided resource.
    #' @param x A valid resource object.
    #' @return A NoSQLResourceClient object.
    newClient = function(x) {
      if (self$isFor(x)) {
        NoSQLResourceClient$new(x)
      } else {
        stop("Resource is not located in NoSQL database")
      }
    }
  )
)
