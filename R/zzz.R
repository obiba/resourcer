.onLoad <- function(libname, pkgname) {
  registerResolver(FileResourceResolver$new())
  registerResolver(SshResourceResolver$new())
}
