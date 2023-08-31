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

subMenuParentItems <- function(subModules) {
  lapply(subModules, function(subMenuItem) {
    shinydashboard::menuItem(
      text = subMenuItem$text,
      tabName = subMenuItem$tabName,
      icon = shiny::icon(subMenuItem$icon)
    )
  })
}

addInfo <- function(item, infoId) {
  infoTag <- shiny::tags$small(
    class = "badge pull-right action-button",
    style = "padding: 1px 6px 2px 6px; background-color: steelblue;",
    type = "button",
    id = infoId,
    "i"
  )
  item$children[[1]]$children <- append(item$children[[1]]$children, list(infoTag))
  return(item)
}

loadModuleMenuItems <- function(module) {
  menuItem <- shinydashboard::menuItem(
    text = module$tabText,
    tabName = module$tabName,
    icon = shiny::icon(module$icon),
    subMenuParentItems(module$subModules)
  )

  addInfo(
    item = menuItem,
    infoId = paste0(module$tabName, "Info")
  )
}

server <- function(config, connection) {
  return(
    shiny::shinyServer(function(input, output, session) {

      # pointless code to use OhdsiShinyModules to prevent warning
      useless <- OhdsiShinyModules::getLogoImage()

      #=============
      # sidebar menu
      #=============
      output$sidebarMenu <- shinydashboard::renderMenu(
        do.call(
          shinydashboard::sidebarMenu,
          c(
            lapply(config$shinyModules, loadModuleMenuItems),
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

        for (subModule in module$subModules) {
          runServer[[subModule$tabName]] <- 0
        }
      }

      initModuleArgs <- function(module) {
        if (is.null(module$databaseConnectionKeyService)) {
          argsList <- list(
            id = module$id
          )
        } else {
          if (module$keyring) {
            # use keyring
            argsList <- list(
              id = module$id,
              resultDatabaseSettings = jsonlite::fromJSON(
                keyring::key_get(
                  module$databaseConnectionKeyService,
                  module$databaseConnectionKeyUsername
                )
              )
            )
          } else {
            # use environmental variables
            argsList <- list(
              id = module$id,
              resultDatabaseSettings = jsonlite::fromJSON(
                Sys.getenv(
                  paste0(
                    module$databaseConnectionKeyService,
                    '_',
                    module$databaseConnectionKeyUsername
                  )
                )
              )
            )
          }
          # add the connection
          argsList$connectionHandler <- connection
        }

        # attach shared data soruce reference
        if (!is.null(module$moduleDataSourceFunction)) {
          tryCatch({
            if (!is.null(module$shinyModulePackage)) {
              dsFunction <- parse(text = paste0(module$shinyModulePackage, "::", module$dataSourceFunction))
            } else {
              dsFunction <- module$dataSourceFunction
            }
            shiny::withProgress({
              argsList$dataSource <- do.call(
                what = eval(dsFunction),
                args = argsList
              )
            }, message = paste("Loading module", module$moduleId))
          }, error = function(err) {
            ParallelLogger::logError("Failed to load module data source for ", module$tabName, err)
            shiny::showNotification(
              paste0("Error loading module data source: ", module$tabName),
              type = "error"
            )
          })
        }
        return(argsList)
      }

      initModule <- function(module, argsList, modulePackage) {
        if (!is.null(module$serverFunction)) {
          tryCatch({
            if (!is.null(modulePackage)) {
              serverFunc <- parse(text = paste0(modulePackage, "::", module$serverFunction))
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
            ParallelLogger::logError("Failed to load module ", module$tabName, err)
            shiny::showNotification(
              paste0("Error loading module: ", module$tabName),
              type = "error"
            )
          })
        }
      }

      moduleArgList <- shiny::reactiveValues()
      moduleRes <- shiny::reactiveValues()

      shiny::observeEvent(input$menu, {

        lapply(config$shinyModules, function(module) {
          if (input$menu == module$tabName & runServer[[module$tabName]] == 0) {
            moduleArgList[[module$tabName]] <- initModuleArgs(module)
            moduleRes[[module$tabName]] <- initModule(module, argsList, module$shinyModulePackage)
            runServer[[module$tabName]] <- runServer[[module$tabName]] + 1
          }

          # attach any sub modules
          lapply(module$subModules, function(subMod) {
            if (input$menu == subMod$tabName) {
              # Always ensure parent is loaded first
              if (runServer[[module$tabName]] == 0) {
                moduleArgList[[module$tabName]] <- initModuleArgs(module)
                moduleRes[[module$tabName]] <- initModule(module,  moduleArgList[[module$tabName]], module$shinyModulePackage)
                runServer[[module$tabName]] <- runServer[[module$tabName]]+ 1
              }

              if (!is.null(subMod$serverFunction) & runServer[[subMod$tabName]] == 0) {
                 moduleRes[[subMod$tabName]] <- initModule(subMod,  moduleArgList[[module$tabName]], modulePackage = NULL)
                 runServer[[subMod$tabName]] <- runServer[[subMod$tabName]] + 1
              }
            }
          })
        })
      })


      # HELPER FUNCTIONS
      showInfoBox <- function(title, htmlFileName) {
        shiny::showModal(shiny::modalDialog(
          title = title,
          easyClose = TRUE,
          footer = NULL,
          size = "l",
          shiny::HTML(readChar(htmlFileName, file.info(htmlFileName)$size))
        ))
      }

    })

  ) }
  
  
  
  