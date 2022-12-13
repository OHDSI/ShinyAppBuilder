server <- function(config, connection){
  return(
  shiny::shinyServer(function(input, output, session) {

  #============= 
  # sidebar menu 
  #============= 
  output$sidebarMenu <- shinydashboard::renderMenu(
    do.call(
      shinydashboard::sidebarMenu, 
      c(
        lapply(config$shinyModules, function(module){
          addInfo(
            item = shinydashboard::menuItem(
              text = module$tabText, 
              tabName = module$tabName, 
              icon = shiny::icon(module$icon)
            ), 
            infoId = paste0(module$tabName,"Info")
          )
        }
        ), 
        id = "menu"
      )
    )
  )
  
  
  lapply(config$shinyModules, function(module){
    shiny::observeEvent(eval(parse(text = paste0('input$', module$tabName, 'Info'))), {
      showInfoBox(module$tabName, eval(parse(text = paste0(module$shinyModulePackage, "::",module$infoBoxFile))))
    })
  }
  )
  
  # MODULE SERVERS HERE
  runServer <- shiny::reactiveValues() 
  for(module in  config$shinyModules){
    runServer[[module$tabName]] <- 0
  }
  
  shiny::observeEvent(input$menu,{ 
    
    runServer[[input$menu]] <- runServer[[input$menu]] +1 
    
    #lapply(config$shinyModules, function(module){
      
    for(module in config$shinyModules){
      if(input$menu == module$tabName & runServer[[module$tabName]]==1){
        
        if(is.null(module$databaseConnectionKeyService)){
          argsList <- list(
            id = module$id
          )
        } else{
          
          
          if(module$keyring){
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
          } else{
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
        
        
        # run the server
        do.call(
          what = eval(parse(text = paste0(module$shinyModulePackage, "::",module$serverFunction))),
          args = argsList
        )

      }
      
    }
    
    #)
  })
  

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
      shiny::HTML(readChar(htmlFileName, file.info(htmlFileName)$size) ) 
    )) 
  }
  
})

)}
  
  
  
  