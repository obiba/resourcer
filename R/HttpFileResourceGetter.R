#' HTTP file resource getter
#'
#' Access a file that is stored at a HTTP(S) address. Use Basic authentication header if both
#' resource's identity and secret are defined.
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

    #' @description Creates a new HttpFileResourceGetter instance.
    #' @return A HttpFileResourceGetter object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a file accessible through "http" or "https".
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme %in% c("http", "https")
      } else {
        FALSE
      }
    },

    #' @description Download the file from the remote address in a temporary location. Applies Basic authentication if credentials are provided in the resource.
    #' @param resource A valid resource object.
    #' @param ... Unused additional parameters.
    #' @return The "resource.file" object.
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir()
        path <- file.path(downloadDir, fileName)
        httr::GET(resource$url, private$addHeaders(resource), write_disk(path, overwrite = TRUE))
        super$newFileObject(path, temp = TRUE)
      } else {
        stop("Resource file is not located in a HTTP server")
      }
    }
  ),
  private = list(
    # add basic auth header if there are credentials
    addHeaders = function(resource) {
      if (!is.null(resource$identity) && nchar(resource$identity)>0 && !is.null(resource$secret) && nchar(resource$secret)>0) {
        httr::add_headers(Authorization = paste0("Basic ", jsonlite::base64_enc(resource$identity, ":", resource$secret)))
      } else if(!is.null(resource$secret) && nchar(resource$secret)>0) {
        httr::add_headers(Authorization = paste0("Bearer ", resource$secret))
      } else {
        httr::add_headers()
      }
    }
  )
)
