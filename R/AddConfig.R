#' addModuleConfig
#'
#' @description
#' Create an R list with the config specification for one or more modules
#'
#' @details
#' User specifies the settings to create a config for a module
#' 
#' @param config The current config to append the extra module to
#' @param moduleConfig A module config to be added
#' @return
#' An R list with the module config settings
#'
#' @export
#' 
addModuleConfig <- function(
    config, 
    moduleConfig
){
  
  moduleConfig$order <- length(config)+1
  config$shinyModules[[length(config$shinyModules)+1]] <- moduleConfig
  
  return(config)
  
}

#' initializeModuleConfig
#'
#' @description
#' Creates an empty config 
#'
#' @details
#' An empty config that can be used to add shiny module configs to
#' 
#' @return
#' An empty list
#'
#' @export
#' 
initializeModuleConfig <- function(){
  return(list(shinyModules = list()))
}
