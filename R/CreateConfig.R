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

  class(result) <- "shinyModuleConfig"
  
  return(result)
}

#' createDefaultHomeConfig
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
createDefaultHomeConfig <- function(
){
  result <- createModuleConfig(
    moduleId = 'home',
    tabName = "Home",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "homeViewer",
    moduleServerFunction = "homeServer",
    moduleInfoBoxFile =  "homeHelperFile()",
    moduleIcon = "house"
  )
  
  class(result) <- c(class(result), "homeModuleConfig")
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
    moduleIcon = "info-circle"
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
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultEstimationConfig <- function(
){
  
  result <- createModuleConfig(
    moduleId = 'estimation', 
    tabName = 'Estimation', 
    shinyModulePackage = 'OhdsiShinyModules', 
    moduleUiFunction = 'estimationViewer', 
    moduleServerFunction = 'estimationServer', 
    moduleInfoBoxFile = 'estimationHelperFile()', 
    moduleIcon = 'list'
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
  class(result) <- c(class(result), "cohortDiagnosticsModuleConfig")
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
  class(result) <- c(class(result), "datasourcesModuleConfig")
  return(result)
}

#' createDefaultReportConfig
#'
#' @description
#' Create an R list with the report config specification
#'
#' @details
#' User specifies the settings to create a default config for a report module
#' 
#'                             
#' @return
#' An R list with the module config settings
#'
#' @export
createDefaultReportConfig <- function(
){
  result <- createModuleConfig(
    moduleId = 'report',
    tabName = "Report",
    shinyModulePackage = 'OhdsiShinyModules',
    moduleUiFunction = "reportViewer",
    moduleServerFunction = "reportServer",
    moduleInfoBoxFile =  "reportHelperFile()",
    moduleIcon = "book"
  )
  
  class(result) <- c(class(result), "reportModuleConfig")
  return(result)
}
