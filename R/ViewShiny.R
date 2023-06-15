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
#' @param connectionDetails  A DatabaseConnector::connectionDetails connection to the results database
#' @param usePooledConnection  use a pooled database connection or not - set to true for multi-user environments (default)
#' @return
#' Shiny app instance
#'
#' @export
createShinyApp <- function(config, connection = NULL, connectionDetails = NULL, usePooledConnection = TRUE) {

  if (missing(connection) || is.null(connection)) {
    checkmate::assertClass(connectionDetails, "ConnectionDetails", null.ok = TRUE)
    if (usePooledConnection) {
      connection <- ResultModelManager::PooledConnectionHandler$new(connectionDetails = connectionDetails)
    } else {
      connection <- ResultModelManager::ConnectionHandler$new(connectionDetails = connectionDetails)
    }
    on.exit(connection$finalize())
  }

  if (missing(config)) {
    ParallelLogger::logInfo('Using default config')
    config <- ParallelLogger::loadSettingsFromJson(system.file('shiny', 'config.json', package = 'shinyModuleViewer'))
  }

  app <- shiny::shinyApp(ui(config = config),
                         server(config = config,
                                connection = connection))
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
viewShiny <- function(config,
                      connection = NULL,
                      connectionDetails = NULL,
                      usePooledConnection = TRUE) {

  app <- createShinyApp(config = config,
                        connection = connection,
                        connectionDetails = connectionDetails,
                        usePooledConnection = usePooledConnection)

  shiny::runApp(app)
}
