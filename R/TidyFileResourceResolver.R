#' Tidy file Resource resolver
#'
#' The resource is a file and data format is handled by a reader from tidyverse.
#' The data format is one of: csv (comma delimiter), csv2 (semicolon delimiter), tsv (tab delimiter),
#' spss, sav, por, stata, dta, sas, xpt, excel, xls, xlsx.
#'
#' @section Methods:
#'
#' \code{$new()} Create new TidyFileResourceResolver instance.
#' \code{$isFor(x)} Get a logical that indicates that the resolver is applicable to the provided resource object.
#' \code{$newClient()} Make a client for the provided resource.
#'
#' @docType class
#' @format A R6 object of class TidyFileResourceResolver
#' @import R6
#' @export
TidyFileResourceResolver <- R6::R6Class(
  "TidyFileResourceResolver",
  inherit = ResourceResolver,
  public = list(
    isFor = function(x) {
      if (super$isFor(x)) {
        !is.null(findFileResourceGetter(x)) && x$format %in% c("csv", "csv2", "tsv",
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
        TidyFileResourceClient$new(x)
      } else {
        NULL
      }
    }
  )
)


