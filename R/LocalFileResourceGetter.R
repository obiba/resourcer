#' Local file resource getter
#'
#' Access a file that is stored in the local file system. No credentials apply.
#'
#' @docType class
#' @format A R6 object of class LocalFileResourceGetter
#' @import R6
#' @import httr
#' @export
LocalFileResourceGetter <- R6::R6Class(
  "LocalFileResourceGetter",
  inherit = FileResourceGetter,
  public = list(

    #' @description Creates a new LocalFileResourceGetter instance.
    #' @return A LocalFileResourceGetter object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a file stored in the local file system.
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme == "file"
      } else {
        FALSE
      }
    },

    #' @description Make a "resource.file" object from a local file resource.
    #' @param resource A valid resource object.
    #' @param ... Unused additional parameters.
    #' @return The "resource.file" object.
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        super$newFileObject(super$parseURL(resource)$path, temp = FALSE)
      } else {
        stop("Resource is not in the local file system")
      }
    }
  )
)
