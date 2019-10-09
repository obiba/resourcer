.make_file_resource <- function(path = "/data/CNSIM1.csv", format = "csv") {
  newResource(
    name = "test",
    url = paste0("file://", path),
    format = format
  )
}

test_that("file resource resolver works", {
  res <- .make_file_resource()
  resolver <- TidyFileResourceResolver$new()
  expect_true(resolver$isFor(res))

  res <- newResource(
    name = "CNSIM1",
    url = "app+https://app.example.org/files/data/CNSIM1.csv",
    secret = "DSDFrezerFgbgBC",
    format = "csv"
  )
  expect_false(resolver$isFor(res))
})

test_that("file resource resolver is loaded", {
  res <- .make_file_resource()
  registerResourceResolver(TidyFileResourceResolver$new())
  resolver <- resolveResource(res)
  expect_false(is.null(resolver))
  client <- newResourceClient(res)
  expect_false(is.null(client))
})

test_that("file resource client factory, file not found", {
  res <- .make_file_resource()
  resolver <- TidyFileResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("TidyFileResourceClient", "FileResourceClient", "ResourceClient", "R6"))
  expect_equal(client$downloadFile(), "/data/CNSIM1.csv")
  # no such file or directory
  expect_error(client$asDataFrame())
})

test_that("file resource client factory, csv file", {
  res <- .make_file_resource("./data/dataset.csv")
  resolver <- TidyFileResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("TidyFileResourceClient", "FileResourceClient", "ResourceClient", "R6"))
  expect_equal(client$downloadFile(), "data/dataset.csv")
  df <- client$asDataFrame()
  expect_false(is.null(df))
  expect_true("data.frame" %in% class(df))
  expect_true("tbl" %in% class(df))
  client$close()
})

test_that("file resource client factory, spss file", {
  res <- .make_file_resource("./data/dataset.sav", format = "spss")
  resolver <- TidyFileResourceResolver$new()
  client <- resolver$newClient(res)
  expect_equal(class(client), c("TidyFileResourceClient", "FileResourceClient", "ResourceClient", "R6"))
  expect_equal(client$downloadFile(), "data/dataset.sav")
  df <- client$asDataFrame()
  expect_false(is.null(df))
  expect_true("data.frame" %in% class(df))
  expect_true("tbl" %in% class(df))
  client$close()
})

test_that("csv file resource coercing to data.frame", {
  res <- .make_file_resource("./data/dataset.csv")
  registerResourceResolver(TidyFileResourceResolver$new())
  df <- as.data.frame(res)
  expect_false(is.null(df))
  expect_true("data.frame" %in% class(df))
  expect_true("tbl" %in% class(df))
})

test_that("csv file resource client coercing to data.frame", {
  res <- .make_file_resource("./data/dataset.csv")
  registerResourceResolver(TidyFileResourceResolver$new())
  client <- newResourceClient(res)
  df <- as.data.frame(client)
  expect_false(is.null(df))
  expect_true("data.frame" %in% class(df))
  expect_true("tbl" %in% class(df))
})
