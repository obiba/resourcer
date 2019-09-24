.make_file_resource <- function() {
  newResource(
    name = "CNSIM1",
    url = "file:///data/CNSIM1.csv",
    clazz = "csv"
  )
}

test_that("file resource resolver works", {
  res <- .make_file_resource()
  resolver <- FileResourceResolver$new()
  expect_true(resolver$isFor(res))

  res <- newResource(
    name = "CNSIM1",
    url = "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv",
    secret = "DSDFrezerFgbgBC",
    clazz = "csv"
  )
  expect_false(resolver$isFor(res))
})

test_that("file resource resolver is loaded", {
  res <- .make_file_resource()
  registerResolver(FileResourceResolver$new())
  resolver <- resolveResource(res)
  expect_false(is.null(resolver))
})

test_that("file resource client factory", {
  res <- .make_file_resource()
  resolver <- FileResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("FileResourceClient", "ResourceClient", "R6"))
  expect_equal(client$downloadFile(), "/data/CNSIM1.csv")
  # no such file or directory
  expect_error(client$getConnection())
})
