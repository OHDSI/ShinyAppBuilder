library(OhdsiShinyModules)
library(ShinyAppBuilder)

config <- initializeModuleConfig()
# SET ENVIRONMENT VARS TO TRUE TO INCLUDE IN SHINY APP
envVars <- c(
  "SHINY_ABOUT_CFG" = list(TRUE, createDefaultAboutConfig()),
  "SHINY_DATA_SOURCE_CFG" = list(TRUE, createDefaultDatasourcesConfig()),
  "SHINY_CG_CFG" = list(TRUE, createDefaultCohortGeneratorConfig()),
  "SHINY_CD_CFG" = list(TRUE, createDefaultCohortDiagnosticsConfig()),
  "SHINY_C_CFG" = list(TRUE, createDefaultCharacterizationConfig()),
  "SHINY_PLP_CFG" = list(TRUE, createDefaultPredictionConfig()),
  "SHINY_CM_CFG" = list(TRUE, createDefaultCohortMethodConfig()),
  "SHINY_SCCS_CFG" = list(TRUE, createDefaultSccsConfig()),
  "SHINY_META_CFG" = list(TRUE, createDefaultEvidenceSynthesisConfig())
)

for (var in names(envVars)) {
  useCfg <- as.logical(Sys.getenv(var, unset = envVars[[var]][1]))
  if (isTRUE(useCfg)) {
    config <- addModuleConfig(config, envVars[[var]][2])
  }
}

resultDatabaseSettings <- createDefaultResultDatabaseSettings(schema = Sys.getenv("RESULT_DATABASE_SCHEMA"))
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = Sys.getenv("shinydbServer"),
  port = Sys.getenv("shinydbPort", default = 5432),
  user = Sys.getenv("shinydbUser"),
  password = Sys.getenv("shinydbPassword")
)
createShinyApp(config = config,
               connectionDetails = connectionDetails,
               resultDatabaseSettings = resultDatabaseSettings)