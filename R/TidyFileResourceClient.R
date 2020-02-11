#' Tidy file resource client
#'
#' Connects to a file and use one of the tidyverse reader.
#'
#' @docType class
#' @format A R6 object of class TidyFileResourceClient
#' @import R6
#' @export
TidyFileResourceClient <- R6::R6Class(
  "TidyFileResourceClient",
  inherit = FileResourceClient,
  public = list(

    #' @description Create a TidyFileResourceClient instance.
    #' @param resource A valid resource object.
    #' @return A TidyFileResourceClient object.
    initialize = function(resource) {
      super$initialize(resource)
    },

    #' @description Coerce the resource value extracted from the file in tidy format to a data.frame.
    #' @param ... Additional parameters to as.data.frame (not used yet).
    #' @return A data.frame (more specifically a tibble).
    asDataFrame = function(...) {
      path <- super$downloadFile()
      format <- super$getResource()$format
      if ("csv" == format) {
        private$loadReadr()
        readr::read_csv(path)
      } else if ("csv2" == format) {
        private$loadReadr()
        readr::read_csv2(path)
      } else if ("tsv" == format) {
        private$loadReadr()
        readr::read_tsv(path)
      } else if ("ssv" == format) {
        private$loadReadr()
        readr::read_delim(path, delim = " ")
      } else if ("delim" == format) {
        private$loadReadr()
        query <- super$parseQuery()
        delim <- " "
        if (!is.null(query) && !is.null(query$delim)) {
          delim <- as.character(query$delim)
        }
        readr::read_delim(path, delim = delim)
      } else if ("spss" == format) {
        private$loadHaven()
        haven::read_spss(path)
      } else if ("sav" == format) {
        private$loadHaven()
        haven::read_sav(path)
      } else if ("por" == format) {
        private$loadHaven()
        haven::read_por(path)
      } else if ("stata" == format) {
        private$loadHaven()
        haven::read_stata(path)
      } else if ("dta" == format) {
        private$loadHaven()
        haven::read_dta(path)
      } else if ("sas" == format) {
        private$loadHaven()
        haven::read_sas(path)
      } else if ("xpt" == format) {
        private$loadHaven()
        haven::read_xpt(path)
      } else if ("excel" == format || "xls" == format || "xlsx" == format) {
        private$loadReadxl()
        readxl::read_excel(path)
      } else {
        stop("Resource tidy format is unknown: ", format)
      }
    }

  ),
  private = list(
    loadHaven = function() {
      if (!require("haven")) {
        install.packages("haven", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    },
    loadReadr = function() {
      if (!require("readr")) {
        install.packages("readr", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    },
    loadReadxl = function() {
      if (!require("readxl")) {
        install.packages("readxl", repos = "https://cloud.r-project.org", dependencies = TRUE)
      }
    }
  )
)
