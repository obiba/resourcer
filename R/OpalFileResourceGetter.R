#' Opal file resource getter
#'
#' Access a file that is stored in a Opal server. Use Basic authentication header if both
#' resource's identity and secret are defined, token authentication if secret only is defined.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new OpalFileResourceGetter instance from provided resource object.
#' \code{$isFor(resource)} Get a logical that indicates that the file getter is applicable to the provided resource object.
#' \code{$downloadFile(resource)} Get the file described by the provided resource. Release the connection when done.
#'
#' @docType class
#' @format A R6 object of class OpalFileResourceGetter
#' @import R6
#' @import httr
#' @export
OpalFileResourceGetter <- R6::R6Class(
  "OpalFileResourceGetter",
  inherit = FileResourceGetter,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      if (super$isFor(resource)) {
        url <- super$parseURL(resource)
        scheme <- url$scheme
        path <- url$path
        (scheme == "opal+http" || scheme == "opal+https") && startsWith(path, "ws/files/")
      } else {
        FALSE
      }
    },
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir(resource)
        path <- file.path(downloadDir, fileName)

        url <- super$parseURL(resource)
        if (url$scheme == "opal+https") {
          url$scheme <- "https"
        } else if (url$scheme == "opal+http") {
          url$scheme <- "http"
        }
        urlstr <- super$buildURL(url)

        httr::GET(urlstr, private$addHeaders(resource), write_disk(path, overwrite = TRUE))
        super$newFileObject(path, temp = TRUE)
      } else {
        NULL
      }
    }
  ),
  private = list(
    # add auth header or token header if there are credentials
    addHeaders = function(resource) {
      if (nchar(resource$identity)>0 && nchar(resource$secret)>0) {
        httr::add_headers(Authorization = jsonlite::base64_enc(paste0("X-Opal-Auth ", resource$identity, ":", resource$secret)))
      } else if (nchar(resource$secret)>0) {
        httr::add_headers("X-Opal-Auth" = resource$secret)
      } else {
        httr::add_headers()
      }
    }
  )
)
