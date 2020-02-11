#' Presto DBI resource connector
#'
#' Makes a Presto DBI connection from a resource description.
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

    #' @description Creates a new PrestoResourceConnector instance.
    #' @return A PrestoResourceConnector object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a MySQL or MariaDB object: the URL scheme must be "presto", "presto+http" or "presto+https".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("presto", "presto+http", "presto+https")
    },

    #' @description Creates a DBI connection object from a resource.
    #' @param resource A valid resource object.
    #' @return A DBI connection object.
    createDBIConnection = function(resource) {
      if (self$isFor(resource)) {
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
      } else {
        stop("Resource is not located in a Presto database")
      }
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
