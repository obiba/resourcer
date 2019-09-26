#' File Resource resolver
#'
#' The resource is a local file, i.e. which URL scheme is "file".
#'
#' @section Methods:
#'
#' \code{$new()} Create new FileResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class FileResourceResolver
#' @import R6
#' @export
FileResourceResolver <- R6::R6Class(
  "FileResourceResolver",
  inherit = ResourceResolver,
  public = list(
    isFor = function(x) {
      if (super$isFor(x)) {
        super$parseURL(x)$scheme == "file" && x$format %in% c("csv", "csv2", "tsv",
                                                              "spss", "sav", "por",
                                                              "stata", "dta",
                                                              "sas", "xpt",
                                                              "excel", "xls", "xlsx")
      } else {
        FALSE
      }
    },
    newClient = function(x) {
      if (self$isFor(x)) {
        FileResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)
