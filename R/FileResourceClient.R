#' File resource client
#'
#' Connects to a local file.
#'
#' @docType class
#' @format A R6 object of class FileResourceClient
#' @import R6
#' @export
FileResourceClient <- R6::R6Class(
  "FileResourceClient",
  inherit = ResourceClient,
  public = list(
    initialize = function(resource) {
      super$initialize(resource)
    },
    getConnection = function() {
      conn <- super$getConnection()
      if (is.null(conn)) {
        conn <- base::file(self$downloadFile(), open = "r")
        super$setConnection(conn)
      }
      conn
    },
    downloadFile = function(fileext = "") {
      super$parseURL()$path
    },
    asDataFrame = function(...) {
      path <- self$downloadFile()
      clazz <- class(super$getResource())
      if ("csv" %in% clazz) {
        private$loadReadr()
        readr::read_csv(path)
      } else if ("csv2" %in% clazz) {
        private$loadReadr()
        readr::read_csv2(path)
      } else if ("tsv" %in% clazz) {
        private$loadReadr()
        readr::read_tsv(path)
      } else if ("spss" %in% clazz) {
        private$loadHaven()
        haven::read_spss(path)
      } else if ("sav" %in% clazz) {
        private$loadHaven()
        haven::read_sav(path)
      } else if ("por" %in% clazz) {
        private$loadHaven()
        haven::read_por(path)
      } else if ("dta" %in% clazz) {
        private$loadHaven()
        haven::read_dta(path)
      } else if ("stata" %in% clazz) {
        private$loadHaven()
        haven::read_stata(path)
      } else if ("sas" %in% clazz) {
        private$loadHaven()
        haven::read_sas(path)
      } else if ("xpt" %in% clazz) {
        private$loadHaven()
        haven::read_xpt(path)
      } else if ("excel" %in% clazz || "xls" %in% clazz || "xlsx" %in% clazz) {
        private$loadReadxl()
        readxl::read_excel(path)
      } else {
        NULL
      }
    },
    close = function() {
      conn <- super$getConnection()
      if (!is.null(conn)) {
        base::close(conn)
        super$setConnection(NULL)
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
