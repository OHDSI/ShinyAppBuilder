context("view shiny")

test_that("shiny works", {
  
  config <- initializeModuleConfig() 
  config <-  addModuleConfig(config, createDefaultAboutConfig())
  
  app <- createShinyApp(config = config, connection = NULL)
  
  testthat::expect_s3_class(app, "shiny.appobj")
  
  shiny::testServer(
    app = app, 
    args = list(
    ), 
    expr = {
      
      testthat::expect_equal(runServer[['About']],0)
      session$setInputs(menu = 'About')
      testthat::expect_equal(runServer[['About']],1)
      
    })
    
})

