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

#' createShinyApp 
#'
#' @description
#' Create a shiny app for a shiny server
#'
#' @details
#' User specifies the json config and connection
#' 
#' @param config  The json with the app config     
#' @param connection  A connection to the results   
#' @param resultDatabaseSettings A list with the result schema and table prefixes                  
#' @return
#' The shiny app will open
#'
#' @export
createShinyApp <- function(
    config,
    connection,
    resultDatabaseSettings = list(
      schema = 'main',
      cgTablePrefix = 'cg_',
      cdTablePrefix = 'cd_',
      cTablePrefix = 'c_',
      plpTablePrefix = 'plp_',
      pvTablePrefix = 'pv_',
      cmTablePrefix = 'cm_',
      sccsTablePrefix = 'sccs_',
      esTablePrefix = 'es_',
      incidenceTablePrefix = 'i_',
      databaseTable = 'database_meta_table',
      databaseTablePrefix = ''
    )
      ){
  
  if(missing(config)){
    ParallelLogger::logInfo('Using default config')
    config <- ParallelLogger::loadSettingsFromJson(system.file('shiny', 'config.json', package = 'shinyModuleViewer'))
  }
  
  app <- shiny::shinyApp(
    ui = ui(config = config), 
    server = server(
      config = config, 
      connection = connection,
      resultDatabaseSettings = resultDatabaseSettings
      )
    )
  return(app)
}

#' viewShiny
#'
#' @description
#' Open the shiny app
#'
#' @details
#' User specifies the json config and connection
#' 
#' @param config  The json with the app config     
#' @param connection  A connection to the results  
#' @param resultDatabaseSettings A list with the result schema and table prefixes                  
#' @return
#' The shiny app will open
#'
#' @export
viewShiny <- function(
    config,
    connection, 
    resultDatabaseSettings
    ){
  
  app <- createShinyApp(
    config = config,
    connection = connection,
    resultDatabaseSettings = resultDatabaseSettings
    )
  
  shiny::runApp(app)
}
