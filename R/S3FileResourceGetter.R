#' AWS S3 file resource getter
#'
#' Access a file that is in the Amazon Web Services S3 file store. The host name is the bucket name. Credentials may apply.
#'
#' @section Methods:
#'
#' \code{$new(resource)} Create new S3FileResourceGetter instance from provided resource object.
#' \code{$isFor(resource)} Get a logical that indicates that the file getter is applicable to the provided resource object.
#' \code{$downloadFile(resource)} Get the file described by the provided resource. Release the connection when done.
#'
#' @docType class
#' @format A R6 object of class S3FileResourceGetter
#' @import R6
#' @export
S3FileResourceGetter <- R6::R6Class(
  "S3FileResourceGetter",
  inherit = FileResourceGetter,
  public = list(
    initialize = function() {},
    isFor = function(resource) {
      if (super$isFor(resource)) {
        super$parseURL(resource)$scheme %in% c("s3", "aws")
      } else {
        FALSE
      }
    },
    downloadFile = function(resource, ...) {
      if (self$isFor(resource)) {
        fileName <- super$extractFileName(resource)
        downloadDir <- super$makeDownloadDir(resource)
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
