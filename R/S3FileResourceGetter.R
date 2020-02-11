#' AWS S3 file resource getter
#'
#' Access a file that is in the Amazon Web Services S3 file store. The host name is the bucket name. Credentials may apply.
#'
#' @docType class
#' @format A R6 object of class S3FileResourceGetter
#' @import R6
#' @export
S3FileResourceGetter <- R6::R6Class(
  "S3FileResourceGetter",
  inherit = FileResourceGetter,
  public = list(

    #' @description Creates a new S3FileResourceGetter instance.
    #' @return A S3FileResourceGetter object.
    initialize = function() {},

    #' @description Check that the provided resource has a URL that locates a file accessible through "s3" or "aws" protocol (i.e. using AWS S3 file store API).
    #' @param resource The resource object to validate.
    #' @return A logical.
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme %in% c("s3", "aws")
      } else {
        FALSE
      }
    },

    #' @description Download the file from the remote address in a temporary location. Applies authentication if credentials are provided in the resource.
    #' @param resource A valid resource object.
    #' @param ... Unused additional parameters.
    #' @return The "resource.file" object.
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir()
        path <- file.path(downloadDir, fileName)

        private$loadS3()
        aws.s3::save_object(url$path, bucket = url$host, file = path, overwrite = TRUE,
                            key = resource$identity, secret = resource$secret)
        super$newFileObject(path, temp = TRUE)
      } else {
        NULL
      }
    }

  ),
  private = list(
    loadS3 = function() {
      if (!require("aws.s3")) {
        install.packages("aws.s3", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
