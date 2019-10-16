#' Presto DBI resource connector
#'
#' Makes a Presto DBI connection from a resource description.
#'
#' @section Methods:
#'
#' \code{$new()} Create new PrestoResourceConnector instance.
#' \code{$isFor(resource)} Get a logical that indicates that the DBI connector is applicable to the provided resource object.
#' \code{$createDBIConnection(resource, ...)} Get the DBI connection object described by the provided resource.
#' \code{$closeDBIConnection(conn)} Release the DBI connection when done.
#'
#' @docType class
#' @format A R6 object of class PrestoResourceConnector
#' @import R6
#' @import httr
#' @export
PrestoResourceConnector <- R6::R6Class(
  "PrestoResourceConnector",
  inherit = DBIResourceConnector,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("presto", "presto+http", "presto+https")
    },
    createDBIConnection = function(resource) {
      super$loadDBI()
      private$loadRPresto()
      url <- super$parseURL(resource)
      dbname <- strsplit(super$getDatabaseName(), split = "\\.")[[1]]
      protocol <- "http"
      if (identical(url$scheme, "presto+https")) {
        protocol <- "https"
      }
      # presto user (might be different from the one that authenticate)
      user <- resource$identity
      if (!is.null(url$query) && !is.null(url$query$user)) {
        user <- url$query$user
      }
      # authentication header as supported by httr
      auth <- NULL
      if (!is.null(resource$identity)) {
        authType <- "basic"
        if (!is.null(url$query) && !is.null(url$query$auth_type)) {
          authType <- url$query$auth_type
        }
        auth <- httr::authenticate(user = resource$identity, password = resource$secret, type = authType)
      }
      conn <- DBI::dbConnect(RPresto::Presto(), host = paste0(protocol, "://", url$host), port = url$port,
                             user = user, catalog = dbname[1], schema = dbname[2]) # TODO: , httr_authenticate = auth)
    }
  ),
  private = list(
    loadRPresto = function() {
      if (!require("RPresto")) {
        install.packages("RPresto", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
