#' Spark DBI resource connector
#'
#' Makes a Spark connection object, that is also a DBI connection object, from a resource description.
#'
#' @section Methods:
#'
#' \code{$new()} Create new SparkResourceConnector instance.
#' \code{$isFor(resource)} Get a logical that indicates that the DBI connector is applicable to the provided resource object.
#' \code{$createDBIConnection(resource, ...)} Get the DBI connection object described by the provided resource.
#' \code{$closeDBIConnection(conn)} Release the DBI connection when done.
#'
#' @docType class
#' @format A R6 object of class SparkResourceConnector
#' @import R6
#' @import httr
#' @export
SparkResourceConnector <- R6::R6Class(
  "SparkResourceConnector",
  inherit = DBIResourceConnector,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("spark", "spark+http", "spark+https")
    },
    createDBIConnection = function(resource) {
      super$loadDBI()
      private$loadSparklyr()
      url <- super$parseURL(resource)
      if (identical(url$host, "local")) {
        conn <- sparklyr::spark_connect(master = "local")
      } else {
        protocol <- "http"
        if (identical(url$scheme, "sparksql+https")) {
          protocol <- "https"
        }
        master <- paste0(protocol, "://", url$host, ":", url:port)
        config <- sparklyr::livy_config(username=resource$identity, password=resource$secret)
        conn <- sparklyr::spark_connect(master = master, method = "livy", config = config)
      }
    },
    closeDBIConnection = function(conn) {
      if ("spark_connection" %in% class(conn)) {
        sparklyr::spark_disconnect(conn)
      }
    }
  ),
  private = list(
    loadSparklyr = function() {
      if (!require("sparklyr")) {
        install.packages("sparklyr", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
