#' Tidy file Resource resolver
#'
#' The resource is a file and data format is handled by a reader from tidyverse.
#' The data format is one of: csv (comma delimiter), csv2 (semicolon delimiter), tsv (tab delimiter), ssv (space delimiter),
#' delim (delim parameter to be specified in the URL, default is space char), spss, sav, por, stata, dta, sas, xpt,
#' excel, xls, xlsx.
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

    #' @description Check that the provided resource has a URL that locates a tidy data file: the resource can be accessed as a file and
    #'  the resource format is one of "csv", "csv2", "tsv", "delim", "ssv", "spss", "sav", "por", "stata", "dta", "sas", "xpt",
    #'  "excel", "xls" or "xlsx" (case is ignored).
    #' @param x The resource object to validate.
    #' @return A logical.
    isFor = function(x) {
      if (super$isFor(x)) {
        !is.null(findFileResourceGetter(x)) && tolower(x$format) %in% c("csv", "csv2", "tsv", "delim", "ssv",
                                                                        "spss", "sav", "por", "stata", "dta",
                                                                        "sas", "xpt",
                                                                        "excel", "xls", "xlsx")
      } else {
        FALSE
      }
    },

    #' @description Creates a TidyFileResourceClient instance from provided resource.
    #' @param x A valid resource object.
    #' @return A TidyFileResourceClient object.
    newClient = function(x) {
      if (self$isFor(x)) {
        TidyFileResourceClient$new(x)
      } else {
        stop("Resource is not a tidy data file")
      }
    }
  )
)


