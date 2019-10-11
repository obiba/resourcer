#' NoSQL Database Resource resolver
#'
#' The resource is NoSQL database such as mongodb, elasticsearch, redis, couchdb, sqlite.
#'
#' @section Methods:
#'
#' \code{$new()} Create new NoSQLResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class NoSQLResourceResolver
#' @import R6
#' @export
NoSQLResourceResolver <- R6::R6Class(
  "NoSQLResourceResolver",
  inherit = ResourceResolver,
  public = list(
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme %in% c("mongodb", "mongodb+srv", "elasticsearch", "es", "redis", "couchdb", "sqlite") && is.null(x$format)
      } else {
        FALSE
      }
    },
    newClient = function(x) {
      if (self$isFor(x)) {
        NoSQLResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)
