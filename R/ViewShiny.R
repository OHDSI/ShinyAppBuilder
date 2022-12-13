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
#' @return
#' The shiny app will open
#'
#' @export
createShinyApp <- function(config,connection){
  
  if(missing(config)){
    ParallelLogger::logInfo('Using default config')
    config <- ParallelLogger::loadSettingsFromJson(system.file('shiny', 'config.json', package = 'shinyModuleViewer'))
  }
  
  app <- shiny::shinyApp(ui(config=config), server(config = config, connection = connection))
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
#' @return
#' The shiny app will open
#'
#' @export
viewShiny <- function(config,connection){
  
  app <- createShinyApp(
    config = config,
    connection = connection
    )
  
  shiny::runApp(app)
}
