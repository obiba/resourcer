.make_file_resource <- function(path = "/data/CNSIM1.rds", format = "data.frame") {
  newResource(
    name = "test",
    url = paste0("file://", path),
    format = format
  )
}

test_that("file resource resolver works", {
  res <- .make_file_resource()
  resolver <- RDSFileResourceResolver$new()
  expect_true(resolver$isFor(res))

  res <- newResource(
    name = "CNSIM1",
    url = "app+https://app.example.org/files/data/CNSIM1.rds",
    secret = "DSDFrezerFgbgBC",
    format = "data.frame"
  )
  expect_false(resolver$isFor(res))
})

test_that("file resource resolver is loaded", {
  res <- .make_file_resource()
  registerResourceResolver(RDSFileResourceResolver$new())
  resolver <- resolveResource(res)
  expect_false(is.null(resolver))
  client <- newResourceClient(res)
  expect_false(is.null(client))
})

test_that("file resource client factory, file not found", {
  res <- .make_file_resource()
  resolver <- RDSFileResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("RDSFileResourceClient", "FileResourceClient", "ResourceClient", "R6"))
  expect_equal(client$downloadFile(), "/data/CNSIM1.rds")
  # no such file or directory
  expect_error(client$asDataFrame())
})

test_that("file resource client factory, RDS file", {
  res <- .make_file_resource("./data/dataset.rds")
  resolver <- RDSFileResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("RDSFileResourceClient", "FileResourceClient", "ResourceClient", "R6"))
  expect_equal(client$downloadFile(), "data/dataset.rds")
  df <- client$asDataFrame()
  expect_false(is.null(df))
  expect_true("data.frame" %in% class(df))
  client$close()
})

test_that("RDS file resource coercing to data.frame", {
  res <- .make_file_resource("./data/dataset.rds")
  registerResourceResolver(RDSFileResourceResolver$new())
  df <- as.data.frame(res)
  expect_false(is.null(df))
  expect_true("data.frame" %in% class(df))
})

test_that("RDS file resource client coercing to data.frame", {
  res <- .make_file_resource("./data/dataset.rds")
  registerResourceResolver(RDSFileResourceResolver$new())
  client <- newResourceClient(res)
  df <- as.data.frame(client)
  expect_false(is.null(df))
  expect_true("data.frame" %in% class(df))
})
