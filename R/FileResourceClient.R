#' File resource client
#'
#' Base class that connects to a file using a FileResourceGetter.
#'
#' @docType class
#' @format A R6 object of class FileResourceClient
#' @import R6
#' @export
FileResourceClient <- R6::R6Class(
  "FileResourceClient",
  inherit = ResourceClient,
  public = list(

    #' @description Creates a new FileResourceClient instance.
    #' @param resource A valid resource object.
    #' @param file.getter A FileResourceGetter object, optional. If not provided, it will be looked up in the FileResourceGetters registry. The operation will fail if none can be found.
    #' @return A FileResourceClient object.
    initialize = function(resource, file.getter = NULL) {
      super$initialize(resource)
      if (is.null(file.getter)) {
        private$.file.getter <- findFileResourceGetter(resource)
      } else {
        private$.file.getter <- file.getter
      }
      if (is.null(private$.file.getter)) {
        stop("File resource getter cannot be found: either provide one or register one.")
      }
    },

    #' @description Performs the file download, if it does not already exists locally.
    #' @return The local path to the downloaded file.
    downloadFile = function() {
      if (is.null(private$.file.object) || !file.exists(private$.file.object$path)) {
        private$.file.object <- private$.file.getter$downloadFile(super$getResource())
      }
      private$.file.object$path
    },

    #' @description Removes the file if it was downloaded. A local file resource will remain untouched.
    close = function() {
      # silently remove file object if it exists and if it is a temporary file
      if (!is.null(private$.file.object) && file.exists(private$.file.object$path) && private$.file.object$temp) {
        ignore <- tryCatch(file.remove(private$.file.object$path), error = function(e) {})
      }
    }

  ),
  private = list(
    .file.getter = NULL,
    .file.object = NULL
  )
)
