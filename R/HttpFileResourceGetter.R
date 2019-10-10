#' HTTP file resource getter
#'
#' Access a file that is stored at a HTTP(S) address. Use Basic authentication header if both
#' resource's identity and secret are defined.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new HttpFileResourceGetter instance from provided resource object.
#' \code{$isFor(resource)} Get a logical that indicates that the file getter is applicable to the provided resource object.
#' \code{$downloadFile(resource)} Get the file described by the provided resource. Release the connection when done.
#'
#' @docType class
#' @format A R6 object of class HttpFileResourceGetter
#' @import R6
#' @import httr
#' @export
HttpFileResourceGetter <- R6::R6Class(
  "HttpFileResourceGetter",
  inherit = FileResourceGetter,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme %in% c("http", "https")
      } else {
        FALSE
      }
    },
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir(resource)
        path <- file.path(downloadDir, fileName)
        httr::GET(resource$url, private$addHeaders(resource), write_disk(path, overwrite = TRUE))
        super$newFileObject(path, temp = TRUE)
      } else {
        NULL
      }
    }
  ),
  private = list(
    # add basic auth header if there are credentials
    addHeaders = function(resource) {
      if (!is.null(resource$identity) && nchar(resource$identity)>0 && !is.null(resource$secret) && nchar(resource$secret)>0) {
        httr::add_headers(Authorization = jsonlite::base64_enc(paste0("Basic ", resource$identity, ":", resource$secret)))
      } else {
        httr::add_headers()
      }
    }
  )
)
