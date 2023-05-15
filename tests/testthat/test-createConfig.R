context("CreateConfig")

# skip unless using windows

if(ifelse(is.null(Sys.info()), F, Sys.info()['sysname'] == 'Windows')){
  
  test_that("createModuleConfig works with keyring", {
    
    shinyModulePackage <- 'shinyModulePackage'
    moduleUiFunction <- 'moduleUiFunction'
    moduleServerFunction <- 'moduleServerFunction'
    moduleInfoBoxFile <- 'moduleInfoBoxFile()'
    useKeyring <- TRUE
    moduleIcon <- "info"
    moduleDatabaseConnectionKeyService <- 'resultDatabaseDetails'
    moduleDatabaseConnectionKeyUsername <-  'testing'
    
    setting <- createModuleConfig(
      moduleId = 'test',
      tabName = "Test",
      shinyModulePackage = shinyModulePackage,
      moduleUiFunction = moduleUiFunction,
      moduleServerFunction = moduleServerFunction,
      moduleDatabaseConnectionKeyService = moduleDatabaseConnectionKeyService,
      moduleDatabaseConnectionKeyUsername = moduleDatabaseConnectionKeyUsername,
      moduleInfoBoxFile =  moduleInfoBoxFile,
      moduleIcon = moduleIcon,
      resultDatabaseDetails = list(a=1),
      useKeyring = useKeyring
    )
    
    testthat::expect_equal(setting$id, 'test')
    testthat::expect_equal(setting$tabName, 'Test')
    testthat::expect_equal(setting$tabText, 'Test')
    
    testthat::expect_equal(setting$shinyModulePackage, shinyModulePackage)
    testthat::expect_equal(setting$uiFunction, moduleUiFunction)
    testthat::expect_equal(setting$serverFunction,moduleServerFunction)
    testthat::expect_equal(setting$databaseConnectionKeyService,moduleDatabaseConnectionKeyService)
    testthat::expect_equal(setting$databaseConnectionKeyUsername,moduleDatabaseConnectionKeyUsername)
    testthat::expect_equal(setting$infoBoxFile, moduleInfoBoxFile)
    testthat::expect_equal(setting$icon, moduleIcon)
    testthat::expect_equal(setting$keyring,useKeyring)
    
    # check keyring
    keyval <- keyring::key_get(
      service = moduleDatabaseConnectionKeyService, 
      username = moduleDatabaseConnectionKeyUsername, 
    )
    
    testthat::expect_equal(as.character(
      jsonlite::toJSON(
        list(a=1)
      )), keyval)
    
  })
}

test_that("createModuleConfig works with environmental vars", {
  
  shinyModulePackage <- 'shinyModulePackage'
  moduleUiFunction <- 'moduleUiFunction'
  moduleServerFunction <- 'moduleServerFunction'
  moduleInfoBoxFile <- 'moduleInfoBoxFile()'
  useKeyring <- FALSE
  moduleIcon <- "info"
  moduleDatabaseConnectionKeyService <- 'resultDatabaseDetails'
  moduleDatabaseConnectionKeyUsername <-  'testing'
  
  setting <- createModuleConfig(
    moduleId = 'test',
    tabName = "Test",
    shinyModulePackage = shinyModulePackage,
    moduleUiFunction = moduleUiFunction,
    moduleServerFunction = moduleServerFunction,
    moduleDatabaseConnectionKeyService = moduleDatabaseConnectionKeyService,
    moduleDatabaseConnectionKeyUsername = moduleDatabaseConnectionKeyUsername,
    moduleInfoBoxFile =  moduleInfoBoxFile,
    moduleIcon = moduleIcon,
    resultDatabaseDetails = list(a=1),
    useKeyring = useKeyring
  )
  
  testthat::expect_equal(setting$id, 'test')
  testthat::expect_equal(setting$tabName, 'Test')
  testthat::expect_equal(setting$tabText, 'Test')
  
  testthat::expect_equal(setting$shinyModulePackage, shinyModulePackage)
  testthat::expect_equal(setting$uiFunction, moduleUiFunction)
  testthat::expect_equal(setting$serverFunction,moduleServerFunction)
  testthat::expect_equal(setting$databaseConnectionKeyService,moduleDatabaseConnectionKeyService)
  testthat::expect_equal(setting$databaseConnectionKeyUsername,moduleDatabaseConnectionKeyUsername)
  testthat::expect_equal(setting$infoBoxFile, moduleInfoBoxFile)
  testthat::expect_equal(setting$icon, moduleIcon)
  testthat::expect_equal(setting$keyring,useKeyring)
  
  # check env var
  
  var.name <- paste0(moduleDatabaseConnectionKeyService, '_', moduleDatabaseConnectionKeyUsername)
  keyval <- Sys.getenv(var.name)
  
  testthat::expect_equal(
    as.character(jsonlite::toJSON(
      list(a=1)
    )), keyval)
  
})


test_that("check included createConfigs", {
  
conf <- createDefaultAboutConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"aboutViewer")
testthat::expect_equal(conf$serverFunction,"aboutServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultCharacterizationConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"descriptionViewer")
testthat::expect_equal(conf$serverFunction,"descriptionServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultCohortDiagnosticsConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"cohortDiagnosticsView")
testthat::expect_equal(conf$serverFunction,"cohortDiagnosticsSever")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultCohortGeneratorConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"cohortGeneratorViewer")
testthat::expect_equal(conf$serverFunction,"cohortGeneratorServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultEstimationConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"estimationViewer")
testthat::expect_equal(conf$serverFunction,"estimationServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultPredictionConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"predictionViewer")
testthat::expect_equal(conf$serverFunction,"predictionServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultSCCSConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"sccsView")
testthat::expect_equal(conf$serverFunction,"sccsServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultMetaConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"evidenceSynthesisViewer")
testthat::expect_equal(conf$serverFunction,"evidenceSynthesisServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultPhevaluatorConfig(useKeyring = F)
testthat::expect_equal(conf$uiFunction,"phevaluatorViewer")
testthat::expect_equal(conf$serverFunction,"phevaluatorServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

})
