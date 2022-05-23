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

    #' @description Check that the provided resource has a URL that locates a Presto object: the URL scheme must be "presto", "presto+http" or "presto+https".
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
        dbname <- strsplit(super$getDatabaseName(url), split = "\\.")[[1]]
        protocol <- "http"
        if (identical(url$scheme, "presto+https")) {
          protocol <- "https"
        }
        # presto user
        user <- resource$identity
        if (is.null(user) || nchar(user) == 0) {
          user <- Sys.getenv('USER')
        }
        if (is.null(user) || nchar(user) == 0) {
          user <- "x" # better anything than nothing
        }
        if (!is.null(url$query) && url$query$flavor == "prestodb") {
          conn <- DBI::dbConnect(RPresto::Presto(), 
                                 host = paste0(protocol, "://", url$host), 
                                 port = url$port,
                                 user = user, 
                                 catalog = dbname[1], 
                                 schema = dbname[2]) 
        } 
        else {
          conn <- DBI::dbConnect(RPresto::Presto(), 
                                 host = paste0(protocol, "://", url$host), 
                                 port = url$port,
                                 use.trino.headers=TRUE,
                                 user = user, 
                                 catalog = dbname[1], 
                                 schema = dbname[2])
        }
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
