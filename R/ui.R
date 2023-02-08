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

ui <- function(config){
  return(
    shinydashboard::dashboardPage(
  skin = "black",
  
  shinydashboard::dashboardHeader( 
    title = "OHDSI Analysis Viewer",
    shiny::tags$li(
      shiny::div(
        shiny::img(
          src = OhdsiShinyModules::getLogoImage(),
          title = "OHDSI",
          height = "40px",
          width = "40px"
        ),
        style = "padding-top:0px; padding-bottom:0px;"
      ),
      class = "dropdown"
    )
  ),
  
  shinydashboard::dashboardSidebar( 
    shinydashboard::sidebarMenuOutput("sidebarMenu") 
  ), # end sidebar 
  
  # ADD EACH MODULE SHINY AS A TAB ITEM
  shinydashboard::dashboardBody(
    
    do.call(
      shinydashboard::tabItems, 
      lapply(config$shinyModules, function(module){
        shinydashboard::tabItem(
          tabName = module$tabName, 
          eval(parse(text = paste0(module$shinyModulePackage,"::" ,module$uiFunction)))(id = module$id)
        )
      })
      )
    
  )
  
)
)}