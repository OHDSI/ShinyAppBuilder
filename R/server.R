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

# HELPER FUNCTIONS
addInfo <- function(item, infoId) {
  infoTag <- shiny::tags$small(
    class = "fa fa-info-circle pull-right action-button",
    type = "button",
    id = infoId
  )
  item$children[[1]]$children <- append(item$children[[1]]$children, list(infoTag))
  return(item)
}

showInfoBox <- function(title, htmlFileName) {
  shiny::showModal(shiny::modalDialog(
    title = title,
    easyClose = TRUE,
    footer = NULL,
    size = "l",
    shiny::HTML(readChar(htmlFileName, file.info(htmlFileName)$size))
  ))
}

server <- function(config, connection, resultDatabaseSettings) {

  moduleServer <- shiny::shinyServer(function(input, output, session) {
    
    # pointless code to use OhdsiShinyModules to prevent warning
    useless <- OhdsiShinyModules::getLogoImage()
    
    #=============
    # sidebar menu
    #=============
    output$sidebarMenu <- shinydashboard::renderMenu(
      do.call(
        shinydashboard::sidebarMenu,
        c(
          lapply(config$shinyModules, function(module) {
            addInfo(
              item = shinydashboard::menuItem(
                text = module$tabText,
                tabName = module$tabName,
                icon = shiny::icon(module$icon)
              ),
              infoId = paste0(module$tabName, "Info")
            )
          }
          ),
          id = "menu"
        )
      )
    )


    lapply(config$shinyModules, function(module) {
      if (!is.null(module$shinyModulePackage)) {
        moduleInfoBox <- parse(text = paste0(module$shinyModulePackage, "::", module$infoBoxFile))
      } else {
        moduleInfoBox <- module$infoBoxFile
      }

      shiny::observeEvent(eval(parse(text = paste0('input$', module$tabName, 'Info'))), {
        showInfoBox(module$tabName, eval(moduleInfoBox))
      })
    }
    )

    # MODULE SERVERS HERE
    runServer <- shiny::reactiveValues()
    for (module in  config$shinyModules) {
      runServer[[module$tabName]] <- 0
    }

    shiny::observeEvent(input$menu, {

      runServer[[input$menu]] <- runServer[[input$menu]] + 1

      #lapply(config$shinyModules, function(module){

      for (module in config$shinyModules) {
        if (input$menu == module$tabName & runServer[[module$tabName]] == 1 & module$tabName == "About") {
          argsList <- list(
            id = module$id,
            resultDatabaseSettings = resultDatabaseSettings,
            connectionHandler = connection,
            config = config
          )
          # run the server

          tryCatch({
            if (!is.null(module$shinyModulePackage)) {
              serverFunc <- parse(text = paste0(module$shinyModulePackage, "::", module$serverFunction))
            } else {
              serverFunc <- module$serverFunction
            }
            shiny::withProgress({
              do.call(
                what = eval(serverFunc),
                args = argsList
              )
            }, message = paste("Loading module", module$moduleId))

          }, error = function(err) {
            ParallelLogger::logError("Failed to load module ", module$tabName)
            shiny::showNotification(
              paste0("Error loading module: ", err),
              type = "error"
            )
          })
        }
        
        if (input$menu == module$tabName & runServer[[module$tabName]] == 1 & module$tabName != "About") {
          argsList <- list(
            id = module$id,
            resultDatabaseSettings = resultDatabaseSettings,
            connectionHandler = connection
          )
          # run the server
          
          tryCatch({
            if (!is.null(module$shinyModulePackage)) {
              serverFunc <- parse(text = paste0(module$shinyModulePackage, "::", module$serverFunction))
            } else {
              serverFunc <- module$serverFunction
            }
            shiny::withProgress({
              do.call(
                what = eval(serverFunc),
                args = argsList
              )
            }, message = paste("Loading module", module$moduleId))
            
          }, error = function(err) {
            ParallelLogger::logError("Failed to load module ", module$tabName)
            shiny::showNotification(
              paste0("Error loading module: ", err),
              type = "error"
            )
          })
        }

      }
    })

  })

  return(moduleServer)
}

  
  
  