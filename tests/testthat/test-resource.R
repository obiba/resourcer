test_that("resource builder works", {
  res <- newResource(
    name = "CNSIM1",
    url = "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv",
    identity = "administrator",
    secret = "password",
    format = "csv"
  )
  expect_equal(res$name, "CNSIM1")
  expect_equal(res$url, "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv")
  expect_equal(res$identity, "administrator")
  expect_equal(res$secret, "password")
  expect_equal(res$format, "csv")
  expect_equal(class(res), "resource")

  res <- newResource(
    name = "CNSIM1",
    url = "opal+https://opal-demo.obiba.org/ws/files/data/CNSIM1.csv",
    secret = "DSDFrezerFgbgBC",
    format = "csv"
  )
  expect_null(res$identity)
})

test_that("default asTbl coerces data.frame to tibble", {
  skip_if_not_installed("dplyr")
  Client <- R6::R6Class("Client", inherit = ResourceClient, public = list(
    asDataFrame = function(...) data.frame(a = 1:2)
  ))
  client <- Client$new(newResource(name = "test", url = "file:///tmp/test.csv", format = "csv"))
  tbl <- as.resource.tbl(client)
  expect_s3_class(tbl, "tbl_df")
  expect_equal(tbl$a, 1:2)
})

test_that("presto connector reports missing RPresto", {
  skip_if_not_installed("DBI")
  skip_if(requireNamespace("RPresto", quietly = TRUE))
  res <- newResource(name = "test", url = "presto://localhost:8080/hive.default/test")
  expect_error(PrestoResourceConnector$new()$createDBIConnection(res), "install_github")
})
