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