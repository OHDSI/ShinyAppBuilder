context("view shiny")

test_that("shiny works", {
  
  config <- initializeModuleConfig() 
  
  fooModuleUi <- function (id = "foo") {
    shiny::fluidPage(title = "foo")
  }
  
  fooModule <- function(
    id = 'foo',
    connectionHandler = NULL,
    resultDatabaseSettings = NULL,
    config
    ) {
    shiny::moduleServer(id, function(input, output, session) { })
  }
  
  fooHelpInfo <- function() {
    'NA'
  }
  
  moduleConfig <- createModuleConfig(
    moduleId = 'foo',
    tabName = "foo",
    shinyModulePackage = NULL,
    moduleUiFunction = fooModuleUi,
    moduleServerFunction = fooModule,
    moduleInfoBoxFile = "fooHelpInfo()",
    moduleIcon = "info"
  )
  
  config <- addModuleConfig(config, moduleConfig)
  
  # check app fails when NULL connection
  expect_error(createShinyApp(config = config, connection = NULL))
  expect_error(createShinyApp(config = config, connection = NULL, connectionDetails = list()))
 
  # create a connection and check app works
  tdb <- tempfile(fileext = "sqlite")
  on.exit(unlink(tdb))
  testCd <- DatabaseConnector::createConnectionDetails("sqlite", server = tdb)
  app <- createShinyApp(
    config = config, 
    connectionDetails = testCd
  )
  testthat::expect_s3_class(app, "shiny.appobj")


  shiny::testServer(
    app = app,
    args = list(
    ),
    expr = {
      
      testthat::expect_equal(runServer[['foo']], 0)
      session$setInputs(menu = 'foo')
      testthat::expect_equal(runServer[['foo']], 1)

    })

  # Test pooled and non-pooled connections and passing connection directly
  app2 <- createShinyApp(config = config, connectionDetails = testCd, usePooledConnection = FALSE)
  testthat::expect_s3_class(app, "shiny.appobj")
  connectionHandler <- ResultModelManager::ConnectionHandler$new(connectionDetails = testCd)
  app3 <- createShinyApp(config = config, connection = connectionHandler)
  testthat::expect_s3_class(app, "shiny.appobj")
})

test_that("shiny OhdsiShinyModules test", {
  
  # skip in cran and github actions
  skip_if_not_installed("OhdsiShinyModules")
  
  config <- initializeModuleConfig() 
  config <-  addModuleConfig(config, createDefaultAboutConfig())
  
  # editing for tests run
  config$shinyModules[[1]]$shinyModulePackageVersion <- '1.0.0'
  
  tdb <- tempfile(fileext = "sqlite")
  on.exit(unlink(tdb))
  testCd <- DatabaseConnector::createConnectionDetails("sqlite", server = tdb)
  app <- createShinyApp(config = config, connectionDetails = testCd)
  testthat::expect_s3_class(app, "shiny.appobj")

  shiny::testServer(
    app = app,
    args = list(
    ),
    expr = {

      testthat::expect_equal(runServer[['About']], 0)
      session$setInputs(menu = 'About')
      testthat::expect_equal(runServer[['About']], 1)

    })
})

# test app with summary reports
# first create empty html file
test_that("shiny works", {
  
  config <- initializeModuleConfig() 
  
  fooModuleUi <- function (id = "foo") {
    shiny::fluidPage(title = "foo")
  }
  
  fooModule <- function(
    id = 'foo',
    connectionHandler = NULL,
    resultDatabaseSettings = NULL,
    config
  ) {
    shiny::moduleServer(id, function(input, output, session) { })
  }
  
  fooHelpInfo <- function() {
    'NA'
  }
  
  moduleConfig <- createModuleConfig(
    moduleId = 'foo',
    tabName = "foo",
    shinyModulePackage = NULL,
    moduleUiFunction = fooModuleUi,
    moduleServerFunction = fooModule,
    moduleInfoBoxFile = "fooHelpInfo()",
    moduleIcon = "info"
  )
  
  config <- addModuleConfig(config, moduleConfig)
  
  # create a connection and check app works
  tdb <- tempfile(fileext = "sqlite")
  htmlFileLocation <- tempfile(fileext = ".html")
  
  on.exit(unlink(tdb))
  on.exit(unlink(htmlFileLocation))
  testCd <- DatabaseConnector::createConnectionDetails("sqlite", server = tdb)
  app <- createShinyApp(
    config = config, 
    connectionDetails = testCd, 
    reportSummaryDetails = data.frame(
      reportLocation = htmlFileLocation,
      reportName = 'test'
    )
  )
  testthat::expect_s3_class(app, "shiny.appobj")
  
  # check error when incorrect reportSummaryDetails
  testthat::expect_message(
    createShinyApp(
      config = config, 
      connectionDetails = testCd, 
      reportSummaryDetails = data.frame(
        reportLocation5 = htmlFileLocation,
        reportName = 'test'
      )
    )
  )
  
})
