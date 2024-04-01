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
    link = 'http://ohdsi.org'
    ){
  return(
    shinydashboard::dashboardPage(
  skin = "black",

  shinydashboard::dashboardHeader(
    title = title,
    titleWidth = 450,
    
    shiny::tags$li(
      shiny::div(
        shiny::img(
          src = "https://www.ohdsi.org/wp-content/uploads/2015/02/h243-ohdsi-logo-with-text.png",
          title = "OHDSI",
          height = "50px",
          width = "200px"
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
  ), # end sidebar

  # ADD EACH MODULE SHINY AS A TAB ITEM
  shinydashboard::dashboardBody(
    shiny::includeCSS(
      system.file(
        "www",
        'formatting.css', 
        package = "ShinyAppBuilder"
      )
    ),

    do.call(
      shinydashboard::tabItems,
      lapply(config$shinyModules, function(module){

        if (!is.null(module$shinyModulePackage)) {
          uiFunction <- parse(text = paste0(module$shinyModulePackage,"::" ,module$uiFunction))
        } else {
          uiFunction <- module$uiFunction
        }

        shinydashboard::tabItem(
          tabName = module$tabName,
          eval(uiFunction)(id = module$id)
        )
      })
      ),

    shiny::tags$footer(
      shiny::h6(
        paste0(
        "Generated with OhdsiShinyModules v",
        utils::packageVersion('OhdsiShinyModules'),
        ' and ShinyAppBuilder v',
        utils::packageVersion('ShinyAppBuilder')
      )
    )
    )

  )

)
)}