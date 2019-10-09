#' Local file resource getter
#'
#' Access a file that is stored in the local file system. No credentials apply.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new LocalFileResourceGetter instance from provided resource object.
#' \code{$isFor(resource)} Get a logical that indicates that the file getter is applicable to the provided resource object.
#' \code{$downloadFile(resource)} Get the file described by the provided resource. Release the connection when done.
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
    initialize = function() {},
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme == "file"
      } else {
        FALSE
      }
    },
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        super$newFileObject(super$parseURL(resource)$path, temp = FALSE)
      } else {
        NULL
      }
    }
  )
)
