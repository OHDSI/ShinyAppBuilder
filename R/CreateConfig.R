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
#' @param moduleInfoBoxFile  The function in the R package shinyModulePackage that contains info text
#' @param moduleIcon The icon to use for the side menu button
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
 moduleInfoBoxFile =  "aboutHelperFile()",
 moduleIcon = "info"
){

  result <- list(
    id = moduleId,
    tabName = tabName,
    tabText = tabName,
    shinyModulePackage = shinyModulePackage,
    uiFunction = moduleUiFunction,
    serverFunction = moduleServerFunction,
    infoBoxFile = moduleInfoBoxFile,
    icon = moduleIcon
  )
  
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
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultAboutConfig <- function(
){
  result <- createModuleConfig(
    moduleId = 'about',
    tabName = "About",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "aboutViewer",
    moduleServerFunction = "aboutServer",
    moduleInfoBoxFile =  "aboutHelperFile()",
    moduleIcon = "info"
  )
  
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
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultPredictionConfig <- function(
){
  
  result <- createModuleConfig(
    moduleId = 'prediction',
    tabName = "Prediction",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "patientLevelPredictionViewer",
    moduleServerFunction = "patientLevelPredictionServer",
    moduleInfoBoxFile =  "patientLevelPredictionHelperFile()",
    moduleIcon = "chart-line"
  )
  
  return(result)
}

#' createDefaultCohortMethodConfig
#'
#' @description
#' Create an R list with the cohort method config specification
#'
#' @details
#' User specifies the settings to create a default config for an cohort method module
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultCohortMethodConfig <- function(
){
  
  result <- createModuleConfig(
    moduleId = 'cohortmethod',
    tabName = "CohortMethod",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "cohortMethodViewer",
    moduleServerFunction = "cohortMethodServer",
    moduleInfoBoxFile =  "cohortMethodHelperFile()",
    moduleIcon = "chart-column"
  )
  
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
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultCharacterizationConfig <- function(
){
  
  result <- createModuleConfig(
    moduleId = 'characterization',
    tabName = "Characterization",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "characterizationViewer",
    moduleServerFunction = "characterizationServer",
    moduleInfoBoxFile =  "characterizationHelperFile()",
    moduleIcon = "table"
  )
  
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
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultCohortGeneratorConfig <- function(
){
  
  result <- createModuleConfig(
    moduleId = 'cohortGenerator',
    tabName = "Cohorts",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "cohortGeneratorViewer",
    moduleServerFunction = "cohortGeneratorServer",
    moduleInfoBoxFile =  "cohortGeneratorHelperFile()",
    moduleIcon = "user-gear"
  )
  
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
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultCohortDiagnosticsConfig <- function(
){

  result <- createModuleConfig(
    moduleId = 'cohortDiagnostics',
    tabName = "CohortDiagnostics",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "cohortDiagnosticsView",
    moduleServerFunction = "cohortDiagnosticsServer",
    moduleInfoBoxFile =  "cohortDiagnosticsHelperFile()",
    moduleIcon = "users"
  )

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
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultSccsConfig <- function(
){
  
  result <- createModuleConfig(
    moduleIcon = "people-arrows",
    moduleId = 'sscs', 
    tabName = 'SCCS',
    shinyModulePackage = "OhdsiShinyModules",
    moduleUiFunction = "sccsView",
    moduleServerFunction = "sccsServer",
    moduleInfoBoxFile = "sccsHelperFile()"
  )
  
  return(result)
}

#' createDefaultEvidenceSynthesisConfig
#'
#' @description
#' Create an R list with the EvidenceSynthesis config specification
#'
#' @details
#' User specifies the settings to create a default config for an EvidenceSynthesis module
#'
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultEvidenceSynthesisConfig <- function(
){
  
  result <- createModuleConfig(
    moduleIcon = "sliders",
    moduleId = 'EvidenceSynthesis', #namespace ns() 
    tabName = 'Meta',
    shinyModulePackage = "OhdsiShinyModules",
    moduleUiFunction = "evidenceSynthesisViewer",
    moduleServerFunction = "evidenceSynthesisServer",
    moduleInfoBoxFile = "evidenceSynthesisHelperFile()"
  )
  
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
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultPhevaluatorConfig <- function(
){
  
  result <- createModuleConfig(
    moduleId = 'phevaluator',
    tabName = "PheValuator",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "phevaluatorViewer",
    moduleServerFunction = "phevaluatorServer",
    moduleInfoBoxFile =  "phevaluatorHelperFile()",
    moduleIcon = "gauge"
  )
  
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
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultDatasourcesConfig <- function(
){
  
  result <- createModuleConfig(
    moduleId = 'datasources',
    tabName = "DataSources",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "datasourcesViewer",
    moduleServerFunction = "datasourcesServer",
    moduleInfoBoxFile =  "datasourcesHelperFile()",
    moduleIcon = "database"
  )
  
  return(result)
}