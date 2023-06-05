context("view shiny")

test_that("shiny works", {
  
  config <- initializeModuleConfig() 
  config <-  addModuleConfig(config, createDefaultAboutConfig())

  tdb <- tempfile(fileext = "sqlite")
  on.exit(unlink(tdb))
  testCd <- DatabaseConnector::createConnectionDetails("sqlite", server = tdb)
  app <- createShinyApp(config = config, connectionDetails = testCd)
  
  expect_error(createShinyApp(config = config, connection = NULL))
  expect_error(createShinyApp(config = config, connection = NULL, connectionDetails = list()))
  
  testthat::expect_s3_class(app, "shiny.appobj")
  
  shiny::testServer(
    app = app, 
    args = list(
    ), 
    expr = {
      
      testthat::expect_equal(runServer[['About']],0)
      session$setInputs(menu = 'About')
      testthat::expect_equal(runServer[['About']],1)
      
    })
  
  # Test pooled and non-pooled connections and passing connection directly
  app2 <- createShinyApp(config = config, connectionDetails = testCd, usePooledConnection = FALSE)
  testthat::expect_s3_class(app, "shiny.appobj")
  connectionHandler <- ResultModelManager::ConnectionHandler$new(connectionDetails = testCd)
  app3 <- createShinyApp(config = config, connection = connectionHandler)
  testthat::expect_s3_class(app, "shiny.appobj")
})

