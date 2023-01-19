# ShinyAppBuilder

[![Build Status](https://github.com/OHDSI/ShinyAppBuilder/workflows/R-CMD-check/badge.svg)](https://github.com/OHDSI/ShinyAppBuilder/actions?query=workflow%3AR-CMD-check)

[![codecov.io](https://codecov.io/github/OHDSI/ShinyAppBuilder/coverage.svg?branch=main)](https://codecov.io/github/OHDSI/ShinyAppBuilder?branch=main)

Create shiny apps using modules from OhdsiShinyModules or custom modules

# Example: Running a local shiny app

To create a shiny viewer to explore CohortDiagnostic results, Characterization results, PatientLevelPrediction results and CohortMethod results:

```{r}
# install dependencies
install.packages('dplyr')
remotes::install_github('ohdsi/ResultModelManager')
remotes::install_github('ohdsi/OhdsiShinyModules')
remotes::install_github('ohdsi/ShinyAppBuilder')

library(dplyr)
library(ShinyAppBuilder)

# STEP 1: create a config by first creating an empty config initializeModuleConfig()
#         and then adding a shiny module using addModuleConfig()

# Note: the common OHDSI analyses have default config settings (e.g., createDefaultAboutConfig() )

library(ShinyAppBuilder)
config <- initializeModuleConfig() %>%
  addModuleConfig(
    createDefaultAboutConfig(
      resultDatabaseDetails = list(),
      useKeyring = T
    )
  )  %>%
  addModuleConfig(
    createDefaultCohortDiagnosticsConfig(
      resultDatabaseDetails = list(
      dbms = 'sqlite',
      tablePrefix = 'cd_',
      schema = 'main',
      vocabularyDatabaseSchema = 'main'
    ),
      useKeyring = T
    )
  ) %>%
  addModuleConfig(
    createDefaultCharacterizationConfig(
      resultDatabaseDetails = list(
        tablePrefix = 'c_',
        cohortTablePrefix = 'cg_',
        databaseTablePrefix = '',
        schema = 'main',
        databaseTable = 'DATABASE_META_DATA',
        incidenceTablePrefix = 'ci_'
      ),
      useKeyring = T
    )
  ) %>%
  addModuleConfig(
    createDefaultPredictionConfig(
      resultDatabaseDetails = list(
        tablePrefix = 'plp_',
        cohortTablePrefix = 'cg_',
        databaseTablePrefix = '',
        schema = 'main',
        databaseTable = 'DATABASE_META_DATA'
      ),
      useKeyring = T
    )
  ) %>%
  addModuleConfig(
    createDefaultEstimationConfig(
      resultDatabaseDetails = list(
        tablePrefix = 'cm_',
        cohortTablePrefix = 'cg_',
        databaseTablePrefix = '',
        schema = 'main',
        databaseTable = 'DATABASE_META_DATA'
      ),
      useKeyring = T
    )
  )

# Step 2: specify the connection details to the results database 
          using DatabaseConnector::createConnectionDetails 
connectionDetails <- DatabaseConnector::createConnectionDetails(
 # add details to the result database
)

# Step 3: create a connection handler using the ResultModelManager package
connection <- ResultModelManager::ConnectionHandler$new(connectionDetails)

# Step 4: now run the shiny app based on the config file and view the results
#         at the specified connection
ShinyAppBuilder::viewShiny(config = config, connection = connection)
```

If the connection works and there is results in the database, then an interactive shiny app will open.


# Example: Running a on a shiny server

If running the shiny app on a server, you create the config as in Example 1, but instead of `ShinyAppBuilder::viewShiny` use:

```{r}
ShinyAppBuilder::createShinyApp(config = config, connection = connection)
```

