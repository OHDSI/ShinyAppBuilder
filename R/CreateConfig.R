# Copyright 2023 Observational Health Data Sciences and Informatics
#
# This file is part of ShinyAppBuilder
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' createModuleConfig
#'
#' @description
#' Create an R list with the config specification
#'
#' @details
#' User specifies the settings to create a config for a module
#' 
#' @param moduleId  The shiny id for the tab containing the module UI
#' @param tabName   The name of the tab in the shiny app (this will be the side menu button text)      
#' @param shinyModulePackage  The R package to find the server and UI functions
#' @param moduleUiFunction  The name of the UI function in the R package shinyModulePackage
#' @param moduleServerFunction  The name of the server function in the R package shinyModulePackage
#' @param moduleDatabaseConnectionKeyService  The keyring service or the system environment variable with the result database details
#' @param moduleDatabaseConnectionKeyUsername The keyring username or the system environment variable with the result database details
#' @param moduleInfoBoxFile  The function in the R package shinyModulePackage that contains info text
#' @param moduleIcon The icon to use for the side menu button
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createModuleConfig <- function(
 moduleId = 'about',
 tabName = "About",
 shinyModulePackage = 'OhdsiShinyModules',
 moduleUiFunction = "aboutViewer",
 moduleServerFunction = "aboutServer",
 moduleDatabaseConnectionKeyService = 'resultDatabaseDetails',
 moduleDatabaseConnectionKeyUsername = NULL,
 moduleInfoBoxFile =  "aboutHelperFile()",
 moduleIcon = "info",
 resultDatabaseDetails,
 useKeyring = TRUE
){

  result <- list(
    id = moduleId,
    tabName = tabName,
    tabText = tabName,
    shinyModulePackage = shinyModulePackage,
    uiFunction = moduleUiFunction,
    serverFunction = moduleServerFunction,
    databaseConnectionKeyService = moduleDatabaseConnectionKeyService,
    databaseConnectionKeyUsername = moduleDatabaseConnectionKeyUsername,
    infoBoxFile = moduleInfoBoxFile,
    icon = moduleIcon,
    keyring = useKeyring
  )

  class(result) <- "shinyModuleConfig"
  
  if(!is.null(moduleDatabaseConnectionKeyService)){
    if(useKeyring){
      # setup key
      keyring::key_set_with_value(
        service = moduleDatabaseConnectionKeyService, 
        username = moduleDatabaseConnectionKeyUsername, 
        password = as.character(
          jsonlite::toJSON(
            resultDatabaseDetails
          ))
      )
    } else{
      
      var.name <- paste0(moduleDatabaseConnectionKeyService, '_', moduleDatabaseConnectionKeyUsername)
      var.value <- jsonlite::toJSON(
        resultDatabaseDetails
      )
      do.call(Sys.setenv, as.list(stats::setNames(var.value, var.name)))
      
    }
  }
  
  return(result)
}

#' createDefaultAboutConfig
#'
#' @description
#' Create an R list with the about config specification
#'
#' @details
#' User specifies the settings to create a default config for an about module
#' 
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultAboutConfig <- function(
  resultDatabaseDetails,
  useKeyring = T
){
  result <- createModuleConfig(
    moduleId = 'about',
    tabName = "About",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "aboutViewer",
    moduleServerFunction = "aboutServer",
    moduleDatabaseConnectionKeyService = NULL,
    moduleDatabaseConnectionKeyUsername = NULL,
    moduleInfoBoxFile =  "aboutHelperFile()",
    moduleIcon = "info",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )

  class(result) <- c(class(result), "aboutModuleConfig")
  return(result)
}

#' createDefaultPredictionConfig
#'
#' @description
#' Create an R list with the prediction config specification
#'
#' @details
#' User specifies the settings to create a default config for a prediction module
#' 
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultPredictionConfig <- function(
    resultDatabaseDetails = list(
      dbms = 'sqlite',
      tablePrefix = 'plp_',
      cohortTablePrefix = 'cg_',
      databaseTablePrefix = '',
      schema = 'main',
      databaseTable = 'DATABASE_META_DATA',
      incidenceTablePrefix = 'i_'
    ),
    useKeyring = T
){
  
  result <- createModuleConfig(
    moduleId = 'prediction',
    tabName = "Prediction",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "predictionViewer",
    moduleServerFunction = "predictionServer",
    moduleDatabaseConnectionKeyUsername = "prediction",
    moduleInfoBoxFile =  "predictionHelperFile()",
    moduleIcon = "chart-line",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )
  class(result) <- c(class(result), "predictionModuleConfig")
  return(result)
}

#' createDefaultEstimationConfig
#'
#' @description
#' Create an R list with the estimation config specification
#'
#' @details
#' User specifies the settings to create a default config for an estimation module
#' 
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultEstimationConfig <- function(
    resultDatabaseDetails = list(
      dbms = 'sqlite',
      tablePrefix = 'cm_',
      cohortTablePrefix = 'cg_',
      databaseTablePrefix = '',
      schema = 'main',
      databaseTable = 'DATABASE_META_DATA',
      incidenceTablePrefix = 'i_'
    ),
    useKeyring = T
){
  
  result <- createModuleConfig(
    moduleId = 'estimation',
    tabName = "Estimation",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "estimationViewer",
    moduleServerFunction = "estimationServer",
    moduleDatabaseConnectionKeyUsername = "estimation",
    moduleInfoBoxFile =  "estimationHelperFile()",
    moduleIcon = "chart-column",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )
  class(result) <- c(class(result), "estimationModuleConfig")
  return(result)
}

#' createDefaultCharacterizationConfig
#'
#' @description
#' Create an R list with the characterization config specification
#'
#' @details
#' User specifies the settings to create a default config for a characterization module
#' 
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultCharacterizationConfig <- function(
    resultDatabaseDetails = list(
      dbms = 'sqlite',
      tablePrefix = 'c_',
      cohortTablePrefix = 'cg_',
      databaseTablePrefix = '',
      schema = 'main',
      databaseTable = 'DATABASE_META_DATA',
      incidenceTablePrefix = 'i_'
    ),
    useKeyring = T
){
  
  result <- createModuleConfig(
    moduleId = 'characterization',
    tabName = "Characterization",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "descriptionViewer",
    moduleServerFunction = "descriptionServer",
    moduleDatabaseConnectionKeyUsername = "description",
    moduleInfoBoxFile =  "descriptionHelperFile()",
    moduleIcon = "table",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )

  class(result) <- c(class(result), "characterizationModuleConfig")
  return(result)
}


#' createDefaultCohortGeneratorConfig
#'
#' @description
#' Create an R list with the cohort generator config specification
#'
#' @details
#' User specifies the settings to create a default config for a cohort generator module
#' 
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultCohortGeneratorConfig <- function(
    resultDatabaseDetails = list(
      dbms = 'sqlite',
      tablePrefix = 'cg_',
      cohortTablePrefix = 'cg_',
      databaseTablePrefix = '',
      schema = 'main',
      databaseTable = 'DATABASE_META_DATA',
      incidenceTablePrefix = 'i_'
    ),
    useKeyring = T
){
  
  result <- createModuleConfig(
    moduleId = 'cohortGenerator',
    tabName = "Cohorts",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "cohortGeneratorViewer",
    moduleServerFunction = "cohortGeneratorServer",
    moduleDatabaseConnectionKeyUsername = "cohortGenerator",
    moduleInfoBoxFile =  "cohortGeneratorHelperFile()",
    moduleIcon = "user-gear",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )

  class(result) <- c(class(result), "cohortGeneratorModuleConfig")
  return(result)
}

#' createDefaultCohortDiagnosticsConfig
#'
#' @description
#' Create an R list with the characterization config specification
#'
#' @details
#' User specifies the settings to create a default config for a characterization module
#'
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultCohortDiagnosticsConfig <- function(
    resultDatabaseDetails = list(
      dbms = 'sqlite',
      tablePrefix = 'cd_',
      schema = 'main',
      vocabularyDatabaseSchema = 'main'
    ),
    useKeyring = T
){

  result <- createModuleConfig(
    moduleId = 'cohortDiagnostics',
    tabName = "CohortDiagnostics",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "cohortDiagnosticsView",
    moduleServerFunction = "cohortDiagnosticsSever",
    moduleDatabaseConnectionKeyUsername = "cohortDiagnostics",
    moduleInfoBoxFile =  "cohortDiagnosticsHelperFile()",
    moduleIcon = "users",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )
  class(result) <- c(class(result), "cohortDiagnosticsModuleConfig")
  return(result)
}

#' createDefaultSCCSConfig
#'
#' @description
#' Create an R list with the SCCS config specification
#'
#' @details
#' User specifies the settings to create a default config for an sccs module
#'
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultSCCSConfig <- function(
  resultDatabaseDetails = list(
    tablePrefix = 'sccs_',
    cohortTablePrefix = 'cg_',
    databaseTablePrefix = '',
    schema = 'main',
    databaseTable = 'DATABASE_META_DATA'
  ),
  useKeyring = T
){
  
  result <- createModuleConfig(
    moduleIcon = "people-arrows",
    moduleId = 'sscs', 
    tabName = 'SCCS',
    shinyModulePackage = "OhdsiShinyModules",
    moduleUiFunction = "sccsView",
    moduleServerFunction = "sccsServer",
    moduleDatabaseConnectionKeyUsername = 'sccs', 
    moduleInfoBoxFile = "sccsHelperFile()",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )
  class(result) <- c(class(result), "cohortSCCSModuleConfig")
  return(result)
}

#' createDefaultMetaConfig
#'
#' @description
#' Create an R list with the Meta, or EvidenceSynthesis, config specification
#'
#' @details
#' User specifies the settings to create a default config for a Meta, or EvidenceSynthesis, module
#'
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultMetaConfig <- function(
  resultDatabaseDetails = list(
    tablePrefix = 'es_',
    cmTablePrefix = 'cm_',
    sccsTablePrefix = 'sccs_',
    cgTablePrefix = 'cg_',
    schema = 'main',
    databaseMetaData = 'DATABASE_META_DATA'
  ),
  useKeyring = T
){
  
  result <- createModuleConfig(
    moduleIcon = "sliders",
    moduleId = 'EvidenceSynthesis', #namespace ns() 
    tabName = 'Meta',
    shinyModulePackage = "OhdsiShinyModules",
    moduleUiFunction = "evidenceSynthesisViewer",
    moduleServerFunction = "evidenceSynthesisServer",
    moduleDatabaseConnectionKeyUsername = 'es', 
    moduleInfoBoxFile = "evidenceSynthesisHelperFile()",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )
  class(result) <- c(class(result), "cohortMetaModuleConfig")
  return(result)
}

#' createDefaultPhevaluatorConfig
#'
#' @description
#' Create an R list with the phevaluator config specification
#'
#' @details
#' User specifies the settings to create a default config for a phevaluator module
#' 
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultPhevaluatorConfig <- function(
    resultDatabaseDetails = list(
      dbms = 'sqlite',
      tablePrefix = 'pv_',
      cohortTablePrefix = 'cg_',
      databaseTablePrefix = '',
      schema = 'main',
      databaseTable = 'DATABASE_META_DATA'
    ),
    useKeyring = T
){
  
  result <- createModuleConfig(
    moduleId = 'phevaluator',
    tabName = "PheValuator",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "phevaluatorViewer",
    moduleServerFunction = "phevaluatorServer",
    moduleDatabaseConnectionKeyUsername = "phevaluator",
    moduleInfoBoxFile =  "phevaluatorHelperFile()",
    moduleIcon = "gauge",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )
  class(result) <- c(class(result), "phevaluatorModuleConfig")
  return(result)
}

#' createDefaultDatasourcesConfig
#'
#' @description
#' Create an R list with the datasources config specification
#'
#' @details
#' User specifies the settings to create a default config for a datasources module
#' 
#' @param resultDatabaseDetails  A list containing the result database schema (schema), the tablePrefix for the results and other optional settings
#' @param useKeyring whether to save the resultDatabaseDetails to a keyring or system environmental variable
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultDatasourcesConfig <- function(
  resultDatabaseDetails = list(
    dbms = 'sqlite',
    tablePrefix = 'cg_',
    cohortTablePrefix = 'cg_',
    databaseTablePrefix = '',
    schema = 'main',
    databaseTable = 'DATABASE_META_DATA',
    incidenceTablePrefix = 'i_'
  ),
  useKeyring = T
){
  
  result <- createModuleConfig(
    moduleId = 'datasources',
    tabName = "Data Sources",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "datasourcesViewer",
    moduleServerFunction = "datasourcesServer",
    moduleDatabaseConnectionKeyUsername = "datasources",
    moduleInfoBoxFile =  "datasourcesHelperFile()",
    moduleIcon = "database",
    resultDatabaseDetails = resultDatabaseDetails,
    useKeyring = useKeyring
  )
  class(result) <- c(class(result), "datasourcesModuleConfig")
  return(result)
}