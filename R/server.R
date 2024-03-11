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
    class = "badge pull-right action-button",
    style = "padding: 1px 6px 2px 6px; background-color: steelblue;",
    type = "button",
    id = infoId,
    "i"
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
    
    # ... (unchanged)
    
    #=============
    # Additional functions for dynamic sidebar
    #=============
    
    # Load the shinydashboardPlus package
    #library(shinydashboardPlus)
    
    # ...
    
    # Function to render content for the first sidebar
renderFirstSidebarContent <- function() {
  output$firstSidebarContent <- renderUI({
    # Replace this with the actual content/rendering logic for the first sidebar
    # Example: renderText("This is the content of the first sidebar")
    tags$p("This is the content of the first sidebar")
  })
}

# Function to add new sidebar item
addSidebarItem <- function(showAll = TRUE) {
  output$sidebarMenu <- shinydashboard::renderMenu({
    sidebarItems <- lapply(config$shinyModules, function(module) {
      addInfo(
        item = shinydashboard::menuItem(
          text = module$tabText,
          tabName = module$tabName,
          icon = shiny::icon(module$icon),
          startExpanded = showAll  # Show all sidebars expanded or not based on the parameter
        ),
        infoId = paste0(module$tabName, "Info")
      )
    })
    
    if (!showAll) {
      sidebarItems <- sidebarItems[-1]  # Exclude the first sidebar if showAll is set to FALSE
    }
    
    shinydashboard::sidebarMenu(
      do.call(shiny::tagList, sidebarItems),
      id = "menu"
    )
  })
}

# Function to hide sidebar items
hideSidebarItems <- function() {
  output$sidebarMenu <- shinydashboard::renderMenu({
    lapply(config$shinyModules, function(module) {
      if (module$id == 1) {
        # Always show the first sidebar
        addInfo(
          item = shinydashboard::menuItem(
            text = module$tabText,
            tabName = module$tabName,
            icon = shiny::icon(module$icon),
            startExpanded = TRUE  # Always show the first sidebar
          ),
          infoId = paste0(module$tabName, "Info")
        )
      } else {
        # Hide other sidebars
        addInfo(
          item = shinydashboard::menuItem(
            text = module$tabText,
            tabName = module$tabName,
            icon = shiny::icon(module$icon),
            startExpanded = FALSE  # Hide by default
          ),
          infoId = paste0(module$tabName, "Info")
        )
      }
    })
  })
}
# ... (existing code)

# Call the function to render content for the first sidebar during initialization
renderFirstSidebarContent()
    
    # ... (existing code)

shiny::observeEvent(input$addSidebar, {
  # Add new sidebar item logic
  output$sidebarMenu <- shinydashboard::renderMenu({
    sidebarItems <- lapply(config$shinyModules, function(module) {
      if (module$id == 1) {
        # Always show the first sidebar
        addInfo(
          item = shinydashboard::menuItem(
            text = module$tabText,
            tabName = module$tabName,
            icon = shiny::icon(module$icon),
            startExpanded = TRUE
          ),
          infoId = paste0(module$tabName, "Info")
        )
      } else {
        # Hide other sidebars
        addInfo(
          item = shinydashboard::menuItem(
            text = module$tabText,
            tabName = module$tabName,
            icon = shiny::icon(module$icon),
            startExpanded = FALSE
          ),
          infoId = paste0(module$tabName, "Info")
        )
      }
    })
    shinydashboard::sidebarMenu(
      do.call(shiny::tagList, sidebarItems),
      id = "menu"
    )
  })
  
  # Show all sidebars
  shinyjs::runjs('$(".sidebar-menu li a").tab("show");')
  
  # Hide sidebar items logic
  hideSidebarItems()
  
  # Show the "Add Sidebar" and "Hide Sidebar" buttons
  shinyjs::enable("addSidebar")
  shinyjs::enable("hideSidebar")
})

#=============
# View Summary button logic
#=============
shiny::observeEvent(input$viewSummary, {
  # Hide "Add Sidebar" and "Hide Sidebar" buttons
  shinyjs::disable("addSidebar")
  shinyjs::disable("hideSidebar")
  
  # Show only the first sidebar and its content
  output$sidebarMenu <- shinydashboard::renderMenu({
    sidebarItems <- lapply(config$shinyModules, function(module) {
      addInfo(
        item = shinydashboard::menuItem(
          text = module$tabText,
          tabName = module$tabName,
          icon = shiny::icon(module$icon),
          startExpanded = ifelse(module$id == 1, TRUE, FALSE)
        ),
        infoId = paste0(module$tabName, "Info")
      )
    })
    shinydashboard::sidebarMenu(
      do.call(shiny::tagList, sidebarItems),
      id = "menu"
    )
  })
  
  # Render the content for the first sidebar
  renderFirstSidebarContent()
  
  # Hide the rest of the sidebars
  hideSidebarItems()
  
  # Show the "Add Sidebar" and "Hide Sidebar" buttons
  shinyjs::enable("addSidebar")
  shinyjs::enable("hideSidebar")
  
  # Programmatically update the active tab to the first sidebar
  isolate({shinydashboard::updateTabItems(session, "menu", selected = "home")})
})

# Function to render content for the first sidebar
renderFirstSidebarContent <- function() {
  output$firstSidebarContent <- renderUI({
    # Replace this with the actual content/rendering logic for the first sidebar
    # Example: tags$p("This is the content of the first sidebar")
    tags$p("This is the content of the first sidebar")
  })
}

# Add Sidebar button logic
shiny::observeEvent(input$addSidebar, {
  # Add new sidebar item logic
  addSidebarItem(showAll = TRUE)
})

# Hide Sidebar button logic
shiny::observeEvent(input$hideSidebar, {
  # Hide sidebar items logic
  hideSidebarItems()
})

# Function to hide sidebar items
hideSidebarItems <- function() {
  output$sidebarMenu <- shinydashboard::renderMenu({
    lapply(config$shinyModules, function(module) {
      if (module$id == 1) {
        # Always show the first sidebar
        addInfo(
          item = shinydashboard::menuItem(
            text = module$tabText,
            tabName = module$tabName,
            icon = shiny::icon(module$icon),
            startExpanded = TRUE  # Always show the first sidebar
          ),
          infoId = paste0(module$tabName, "Info")
        )
      } else {
        # Hide other sidebars
        addInfo(
          item = shinydashboard::menuItem(
            text = module$tabText,
            tabName = module$tabName,
            icon = shiny::icon(module$icon),
            startExpanded = FALSE  # Hide by default
          ),
          infoId = paste0(module$tabName, "Info")
        )
      }
    })
  })
}

# Function to render content for the first sidebar
renderFirstSidebarContent <- function() {
  module <- config$shinyModules[[1]]
  if (!is.null(module$shinyModulePackage)) {
    serverFunc <- parse(text = paste0(module$shinyModulePackage, "::", module$serverFunction))
  } else {
    serverFunc <- module$serverFunction
  }
  eval(serverFunc)
}

# Show the first sidebar and its content on app opening
shinyjs::runjs('$(".sidebar-menu li a:first").tab("show");')
shinyjs::runjs('$(".sidebar-menu li.active a").click();')  # Click on the active sidebar to display its content
renderFirstSidebarContent()  # Render content for the first module







    
    runServer <- shiny::reactiveValues()
    for (module in  config$shinyModules) {
      runServer[[module$tabName]] <- 0
    }
    
    shiny::observeEvent(input$menu, {
      runServer[[input$menu]] <- runServer[[input$menu]] + 1
      
      for (module in config$shinyModules) {
        if (input$menu == module$tabName & runServer[[module$tabName]] == 1) {
          argsList <- list(
            id = module$id,
            resultDatabaseSettings = resultDatabaseSettings,
            connectionHandler = connection
          )
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
