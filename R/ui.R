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

ui <- function(
    config,
    title = "OHDSI Analysis Viewer",
    studyDescription = "Further details about the analyses used in this study can be found below.",
    link = 'http://ohdsi.org',
    themePackage = "ShinyAppBuilder"
) {
  
  shiny::addResourcePath(
    prefix = "www/images", 
    directoryPath = system.file("www/images",package = themePackage)
  )
  
  return(
    shinydashboard::dashboardPage(
      skin = "black",
      shinydashboard::dashboardHeader(
        title = title,
        titleWidth = 300,
        shiny::tags$li(
          shiny::div(
            shiny::img(
              title = "logo", 
              class = "navbar-logo"
            ), 
            style = "padding-top:0px; padding-bottom:0px;"
          ),
          class = "dropdown"
        ),
        shinydashboard::dropdownMenu(
          type = "messages",
          shinydashboard::messageItem(
            from = "View Protocol",
            message = "Click to view study design",
            icon = shiny::icon("book"),
            href = link
          )
        )
      ),
      
      shinydashboard::dashboardSidebar(
        shinydashboard::sidebarMenuOutput("sidebarMenu")
      ),
      # end sidebar
      
      # ADD EACH MODULE SHINY AS A TAB ITEM
      shinydashboard::dashboardBody(
        shiny::includeCSS(
          system.file(
            "www", 
            'theme.css', 
            package = themePackage
          )
        ),
        shinydashboard::box(
          width = '100%',
          title = shiny::span(
            shiny::icon("lightbulb"), 
            'Study Description'
          ),
          shiny::HTML(studyDescription)
        ),
        
        do.call(
          shinydashboard::tabItems,
          lapply(config$shinyModules, function(module) {
            if (!is.null(module$shinyModulePackage)) {
              uiFunction <- parse(
                text = paste0(module$shinyModulePackage, "::" , module$uiFunction)
              )
            } else {
              uiFunction <- module$uiFunction
            }
            
            shinydashboard::tabItem(tabName = module$tabName, eval(uiFunction)(id = module$id))
          })
        ),
        
        shiny::tags$footer(shiny::h6(
          paste0(
            "Generated with OhdsiShinyModules v",
            utils::packageVersion('OhdsiShinyModules'),
            ' and ShinyAppBuilder v',
            utils::packageVersion('ShinyAppBuilder')
          )
        ))
        
      )
      
    )
  )
}