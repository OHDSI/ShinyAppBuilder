context("CreateConfig")

# skip unless using windows

test_that("createModuleConfig works", {
  
  shinyModulePackage <- 'shinyModulePackage'
  moduleUiFunction <- 'moduleUiFunction'
  moduleServerFunction <- 'moduleServerFunction'
  moduleInfoBoxFile <- 'moduleInfoBoxFile()'
  moduleIcon <- "info"
  
  setting <- createModuleConfig(
    moduleId = 'test',
    tabName = "Test",
    shinyModulePackage = shinyModulePackage,
    moduleUiFunction = moduleUiFunction,
    moduleServerFunction = moduleServerFunction,
    moduleInfoBoxFile =  moduleInfoBoxFile,
    moduleIcon = moduleIcon
  )
  
  testthat::expect_equal(setting$id, 'test')
  testthat::expect_equal(setting$tabName, 'Test')
  testthat::expect_equal(setting$tabText, 'Test')
  
  testthat::expect_equal(setting$shinyModulePackage, shinyModulePackage)
  testthat::expect_equal(setting$uiFunction, moduleUiFunction)
  testthat::expect_equal(setting$serverFunction,moduleServerFunction)
  testthat::expect_equal(setting$infoBoxFile, moduleInfoBoxFile)
  testthat::expect_equal(setting$icon, moduleIcon)
  
  
})


test_that("check included createConfigs", {
  
conf <- createDefaultAboutConfig()
testthat::expect_equal(conf$uiFunction,"aboutViewer")
testthat::expect_equal(conf$serverFunction,"aboutServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultCharacterizationConfig()
testthat::expect_equal(conf$uiFunction,"characterizationViewer")
testthat::expect_equal(conf$serverFunction,"characterizationServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultCohortDiagnosticsConfig()
testthat::expect_equal(conf$uiFunction,"cohortDiagnosticsView")
testthat::expect_equal(conf$serverFunction,"cohortDiagnosticsServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultCohortGeneratorConfig()
testthat::expect_equal(conf$uiFunction,"cohortGeneratorViewer")
testthat::expect_equal(conf$serverFunction,"cohortGeneratorServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultCohortMethodConfig()
testthat::expect_equal(conf$uiFunction,"cohortMethodViewer")
testthat::expect_equal(conf$serverFunction,"cohortMethodServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultPredictionConfig()
testthat::expect_equal(conf$uiFunction,"patientLevelPredictionViewer")
testthat::expect_equal(conf$serverFunction,"patientLevelPredictionServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultSccsConfig()
testthat::expect_equal(conf$uiFunction,"sccsView")
testthat::expect_equal(conf$serverFunction,"sccsServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultEvidenceSynthesisConfig()
testthat::expect_equal(conf$uiFunction,"evidenceSynthesisViewer")
testthat::expect_equal(conf$serverFunction,"evidenceSynthesisServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultPhevaluatorConfig()
testthat::expect_equal(conf$uiFunction,"phevaluatorViewer")
testthat::expect_equal(conf$serverFunction,"phevaluatorServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")

conf <- createDefaultDatasourcesConfig()
testthat::expect_equal(conf$uiFunction,"datasourcesViewer")
testthat::expect_equal(conf$serverFunction,"datasourcesServer")
testthat::expect_equal(conf$shinyModulePackage,"OhdsiShinyModules")


})
