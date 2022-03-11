#' Opal file resource getter
#'
#' Access a file that is stored in a Opal server. Use Basic authentication header if both
#' resource's identity and secret are defined, token authentication if secret only is defined.
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

    #' @description Creates a new OpalFileResourceGetter instance.
    #' @return A OpalFileResourceGetter object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a Opal file: the URL scheme must be "opal+http" or "opal+https" and the path must designate a file web service entry point (i.e. starts with "ws/files/").
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      if (super$isFor(resource)) {
        url <- super$parseURL(resource)
        scheme <- url$scheme
        path <- url$path
        (scheme == "opal+http" || scheme == "opal+https") && length(strsplit(path, "ws/files/")[[1]]) == 2
      } else {
        FALSE
      }
    },

    #' @description Download the file from the Opal file system in a temporary location.
    #' @param resource A valid resource object.
    #' @param ... Unused additional parameters.
    #' @return The "resource.file" object.
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir()
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
      if (!is.null(resource$identity) && nchar(resource$identity)>0 && !is.null(resource$secret) && nchar(resource$secret)>0) {
        httr::add_headers(Authorization = jsonlite::base64_enc(paste0("X-Opal-Auth ", resource$identity, ":", resource$secret)))
      } else if (!is.null(resource$secret) && nchar(resource$secret)>0) {
        httr::add_headers("X-Opal-Auth" = resource$secret)
      } else {
        httr::add_headers()
      }
    }
  )
)
