#' saveConfig
#'
#' @description
#' Save the R list with the config specification as a json
#'
#' @details
#' User saves the R list with the config as a json file
#' 
#' @param configList An R list with the config settings
#' @param configLocation  The location to save the config json file                                     
#' @return
#' An R list with the config settings
#'
#' @export
saveConfig <- function(configList,configLocation){
  ParallelLogger::saveSettingsToJson(
    object = configList, 
    fileName = configLocation
    )
  
  return(invisible(TRUE))
}


#' loadConfig
#'
#' @description
#' Load the config specification
#'
#' @details
#' User specifies the config file and this function returns the R list with the config
#' 
#' @param configLocation  The location of the config json file                                     
#' @return
#' An R list with the config settings
#'
#' @export
loadConfig <- function(configLocation){
  configList <- ParallelLogger::loadSettingsFromJson(
    fileName = configLocation
    )
  
  return(configList)
}