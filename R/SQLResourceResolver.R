#' SQL Database Resource resolver
#'
#' The resource is SQL database.
#'
#' @section Methods:
#'
#' \code{$new()} Create new SQLResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class SQLResourceResolver
#' @import R6
#' @export
SQLResourceResolver <- R6::R6Class(
  "SQLResourceResolver",
  inherit = ResourceResolver,
  public = list(
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme %in% c("mysql", "mariadb", "postres", "postgresql", "sparksql") && is.null(x$format)
      } else {
        FALSE
      }
    },
    newClient = function(x) {
      if (self$isFor(x)) {
        SQLResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)
