# library(Characterization)
# library(testthat)

context("createDefaultResultDatabaseSettings")


test_that("initializeModuleConfig", {
  
  settings <- createDefaultResultDatabaseSettings('tester')
  
  testthat::expect_equal(settings$schema, 'tester')
  
  testthat::expect_true("cgTablePrefix" %in% names(settings))
  testthat::expect_true("cmTablePrefix" %in% names(settings))
  testthat::expect_true("cdTablePrefix" %in% names(settings))
  testthat::expect_true("plpTablePrefix" %in% names(settings))
  testthat::expect_true("sccsTablePrefix" %in% names(settings))
  testthat::expect_true("esTablePrefix" %in% names(settings))
  testthat::expect_true("incidenceTablePrefix" %in% names(settings))
  testthat::expect_true("cTablePrefix" %in% names(settings))
})

