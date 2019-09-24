#' File resource client
#'
#' Connects to a local file.
#'
#' @docType class
#' @format A R6 object of class FileResourceClient
#' @import R6
#' @export
FileResourceClient <- R6::R6Class(
  "FileResourceClient",
  inherit = ResourceClient,
  public = list(
    initialize = function(resource) {
      super$initialize(resource)
    },
    downloadFile = function(fileext = "") {
      super$parseURL()$path
    },
    getConnection = function() {
      conn <- super$getConnection()
      if (is.null(conn)) {
        conn <- base::file(self$downloadFile(), open = "r")
        super$setConnection(conn)
      }
      conn
    },
    close = function() {
      conn <- super$getConnection()
      if (!is.null(conn)) {
        base::close(conn)
        super$setConnection(NULL)
      }
    }
  )
)
