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
#' @param connectionDetails     A DatabaseConnector::connectionDetails connection to the results database
#' @param usePooledConnection   Use a pooled database connection or not - set to true for multi-user environments (default)
#' @param studyDescription A human-readable character string describing the study/analysis
#' @param title The title for the app.  Defaults to: OHDSI Analysis Viewer
#' @param protocolLink A link to a site containing the study protocol
#'
#' @return
#' Shiny app instance
#'
#' @export
createShinyApp <- function(
    config,
    connection,
    resultDatabaseSettings = createDefaultResultDatabaseSettings(),
    connectionDetails = NULL,
    usePooledConnection = TRUE,
    studyDescription = "No description provided. Further details about the analyses used in this study can be found below.",
    title = "OHDSI Analysis Viewer",
    protocolLink = 'http://ohdsi.org'
      ){
  
  # if using connection details instead of connection
  # configure connection from the details
    if (missing(connection) || is.null(connection)) {
    checkmate::assertClass(connectionDetails, "ConnectionDetails")

    if (connectionDetails$dbms != "sqlite") {
      if (length(list.files(connectionDetails$pathToDriver, pattern = connectionDetails$dbms)) == 0) {
        DatabaseConnector::downloadJdbcDrivers(
          dbms = connectionDetails$dbms,
          pathToDriver = connectionDetails$pathToDriver)
      }
    }

    if (usePooledConnection) {
      connection <- ResultModelManager::PooledConnectionHandler$new(
        connectionDetails = connectionDetails
      )
    } else {
      connection <- ResultModelManager::ConnectionHandler$new(
        connectionDetails = connectionDetails
      )
    }
    on.exit(connection$finalize())
  }
  
  if(missing(config)){
    ParallelLogger::logInfo('Using default config')
    config <- ParallelLogger::loadSettingsFromJson(system.file('shiny', 'config.json', package = 'shinyAppBuilder'))
  }
  
  app <- shiny::shinyApp(
    ui = ui(
      config = config, 
      title = title,
      link = protocolLink,
      studyDescription = studyDescription
    ),
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
#' @inheritParams createShinyApp                 
#' @return
#' The shiny app will open
#'
#' @export
viewShiny <- function(
    config,
    connection, 
    resultDatabaseSettings  = createDefaultResultDatabaseSettings(),
    connectionDetails = NULL,
    usePooledConnection = TRUE,
    studyDescription = NULL,
    title = "OHDSI Analysis Viewer",
    protocolLink = 'http://ohdsi.org'
    ){
  
  app <- createShinyApp(
    config = config,
    connection = connection,
    resultDatabaseSettings = resultDatabaseSettings,
    connectionDetails = connectionDetails,
    usePooledConnection = usePooledConnection,
    studyDescription = studyDescription,
    title = title,
    protocolLink = protocolLink
    )
  
  shiny::runApp(app)
}
