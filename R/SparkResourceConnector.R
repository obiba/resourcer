#' Apache Spark DBI resource connector
#'
#' Makes a Apache Spark connection object, that is also a DBI connection object, from a resource description.
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

    #' @description Create a SparkResourceConnector instance.
    #' @return A SparkResourceConnector object.
    initialize = function() {},

    #' @description Check if the provided resource applies to a Apache Spark server.
    #'   The resource URL scheme must be one of "spark", "spark+http" or "spark+https".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      super$isFor(resource) && super$parseURL(resource)$scheme %in% c("spark", "spark+http", "spark+https")
    },

    #' @description Creates a DBI connection object from a Apache Spark resource.
    #' @param resource A valid resource object.
    #' @return A DBI connection object.
    createDBIConnection = function(resource) {
      if (self$isFor(resource)) {
        super$loadDBI()
        private$loadSparklyr()
        url <- super$parseURL(resource)
        if (identical(url$host, "local")) {
          conn <- sparklyr::spark_connect(master = "local")
        } else {
          protocol <- "http"
          if (identical(url$scheme, "spark+https")) {
            protocol <- "https"
          }
          master <- paste0(protocol, "://", url$host, ":", url:port)
          config <- sparklyr::livy_config(username=resource$identity, password=resource$secret)
          conn <- sparklyr::spark_connect(master = master, method = "livy", config = config)
        }
      } else {
        stop("Resource is not located in Apache Spark")
      }
    },

    #' @description Close the DBI connection to Apache Spark.
    #' @param conn A DBI connection object.
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
