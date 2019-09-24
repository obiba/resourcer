.onLoad <- function(libname, pkgname) {
  registerResolver(FileResourceResolver$new())
}
