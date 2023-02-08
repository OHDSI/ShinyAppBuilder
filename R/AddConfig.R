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
  
  moduleConfig$order <- length(config$shinyModules)+1
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
