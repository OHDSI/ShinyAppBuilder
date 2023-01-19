context("SaveLoadConfig")

test_that("saveConfig works", {
  
  loc <- tempfile()
  saveConfig(configList = list(a=1, b=2),loc)
  
  testthat::expect_true(file.exists(loc))
  
})


test_that("loadConfig works", {
  
  loc <- tempfile()
  saveConfig(configList = list(a=1, b=2),loc)

  config <- loadConfig(loc)
  
  testthat::expect_equal(list(a=1, b=2), config)
})