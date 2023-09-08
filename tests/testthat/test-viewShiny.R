context("view shiny")

test_that("shiny works", {
  
  config <- initializeModuleConfig() 
  config <-  addModuleConfig(config, createDefaultAboutConfig())
  
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

      testthat::expect_equal(runServer[['About']], 0)
      session$setInputs(menu = 'About')
      testthat::expect_equal(runServer[['About']], 1)

    })

  # Test pooled and non-pooled connections and passing connection directly
  app2 <- createShinyApp(config = config, connectionDetails = testCd, usePooledConnection = FALSE)
  testthat::expect_s3_class(app, "shiny.appobj")
  connectionHandler <- ResultModelManager::ConnectionHandler$new(connectionDetails = testCd)
  app3 <- createShinyApp(config = config, connection = connectionHandler)
  testthat::expect_s3_class(app, "shiny.appobj")
})

test_that("shiny outside package loads", {
  tdb <- tempfile(fileext = "sqlite")
  on.exit(unlink(tdb))

  testCd <- DatabaseConnector::createConnectionDetails("sqlite", server = tdb)
  fooModuleUi <- function (id = "foo") {
    shiny::fluidPage(title = "foo")
  }

  fooModule <- function(id = 'foo') {
    shiny::moduleServer(id, function(input, output, session) { })
  }

  fooHelpInfo <- function() {
    system.file('about-www', "about.html", package = "OhdsiShinyModules")
  }

  config <- initializeModuleConfig()

  moduleConfig <- createModuleConfig(
    moduleId = 'foo',
    tabName = "foo",
    shinyModulePackage = NULL,
    moduleUiFunction = fooModuleUi,
    moduleServerFunction = fooModule,
    moduleInfoBoxFile = "fooHelpInfo()",
    moduleIcon = "info",
    useKeyring = FALSE,
    resultDatabaseDetails = list()
  )

  config <- addModuleConfig(config, moduleConfig)


  app <- createShinyApp(config = config, connectionDetails = testCd)
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
})