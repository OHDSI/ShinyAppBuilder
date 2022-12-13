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