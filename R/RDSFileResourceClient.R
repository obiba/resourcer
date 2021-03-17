#' R object file resource client
#'
#' Connects to a RDS file and loads the serialized object. Similar to the R data file resource,
#' except that the RDS format stores a single R object.
#'
#' @docType class
#' @format A R6 object of class RDSFileResourceClient
#' @import R6
#' @export
RDSFileResourceClient <- R6::R6Class(
  "RDSFileResourceClient",
  inherit = FileResourceClient,
  public = list(

    #' @description Creates a new RDSFileResourceClient instance.
    #' @param resource A valid resource object.
    #' @return A RDSFileResourceClient object.
    initialize = function(resource) {
      super$initialize(resource)
    },

    #' @description Coerce the resource value extracted from the R object file to a data.frame.
    #' @param ... Additional parameters to as.data.frame (not used yet).
    #' @return A data.frame.
    asDataFrame = function(...) {
      # TODO as.data.frame parameters
      as.data.frame(private$getOrRead())
    },

    #' @description Get the resource value extracted from the R object file.
    #' @param ... Additional parameters to get the value object (not used yet).
    #' @return The resource value.
    getValue = function(...) {
      private$getOrRead()
    }

  ),
  private = list(
    .obj = NULL,
    getOrRead = function() {
      if (is.null(private$.obj)) {
        path <- super$downloadFile()
        resource <- super$getResource()
        format <- resource$format
        if (startsWith(tolower(format), "rds:")) {
          format <- substring(format, 5)
        }

        private$.obj <- readRDS(path)

        if (!(format %in% class(private$.obj))) {
          private$.obj <- NULL
          stop("Cannot find an object with expected format/class: ", format)
        }
      }
      private$.obj
    }
  )
)
