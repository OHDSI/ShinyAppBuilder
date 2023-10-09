ShinyAppBuilder
===============

[![Build Status](https://github.com/OHDSI/ShinyAppBuilder/workflows/R-CMD-check/badge.svg)](https://github.com/OHDSI/ShinyAppBuilder/actions?query=workflow%3AR-CMD-check)
[![codecov.io](https://codecov.io/github/OHDSI/ShinyAppBuilder/coverage.svg?branch=main)](https://codecov.io/github/OHDSI/ShinyAppBuilder?branch=main)

ShinyAppBuilder is part of [HADES](https://ohdsi.github.io/Hades/).

Introduction
============

Create shiny apps using modules from OhdsiShinyModules or custom modules

Examples
========

To create a shiny viewer to explore CohortDiagnostic results, Characterization results, PatientLevelPrediction results and CohortMethod results:

```{r}
# install dependencies
remotes::install_github('ohdsi/ResultModelManager')
remotes::install_github('ohdsi/ShinyAppBuilder')

library(dplyr)
library(ShinyAppBuilder)

# STEP 1: create a config by first creating an empty config initializeModuleConfig()
#         and then adding a shiny module using addModuleConfig()

# Note: the common OHDSI analyses have default config settings (e.g., createDefaultAboutConfig() )

library(ShinyAppBuilder)
config <- initializeModuleConfig() %>%
  addModuleConfig(
    createDefaultAboutConfig()
  )  %>%
  addModuleConfig(
    createDefaultCohortDiagnosticsConfig()
    )
  ) %>%
  addModuleConfig(
    createDefaultCharacterizationConfig()
  ) %>%
  addModuleConfig(
    createDefaultPredictionConfig()
  ) %>%
  addModuleConfig(
    createDefaultCohortMethodConfig()
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
ShinyAppBuilder::viewShiny(
config = config, 
connection = connection
)

# Note - if you have non-standard table prefixes you may need 
#   to specify them in createDefaultResultDatabaseSettings()
ShinyAppBuilder::viewShiny(
config = config, 
connection = connection,  
resultDatabaseSettings = createDefaultResultDatabaseSettings()
)
```

If the connection works and there is results in the database, then an interactive shiny app will open.


## Running a on a shiny server

If running the shiny app on a server, you create the config as in Example 1, but instead of `ShinyAppBuilder::viewShiny` use:

```{r}
ShinyAppBuilder::createShinyApp(config = config, connection = connection)
```

Technology
==========

ShinyAppBuilder is an R package.


System Requirements
===================

Running the package requires R.


Installation
============

1. See the instructions [here](https://ohdsi.github.io/Hades/rSetup.html) for configuring your R environment, including Java.

2. In R, use the following commands to download and install ShinyAppBuilder:

  ```r
  install.packages("remotes")
  remotes::install_github("ohdsi/ShinyAppBuilder")
  ```
  
User Documentation
==================
Documentation can be found on the [package website](https://ohdsi.github.io/ShinyAppBuilder/).

PDF versions of the documentation are also available:

* Vignette: [Using Shiny App Builder](https://raw.githubusercontent.com/OHDSI/ShinyAppBuilder/main/inst/doc/shinyAppModules.pdf)
* Package manual: [ShinyAppBuilder.pdf](https://raw.githubusercontent.com/OHDSI/ShinyAppBuilder/main/extras/ShinyAppBuilder.pdf)


Support
=======

* Developer questions/comments/feedback: <a href="http://forums.ohdsi.org/c/developers">OHDSI Forum</a>
* We use the <a href="https://github.com/OHDSI/ShinyAppBuilder/issues">GitHub issue tracker</a> for all bugs/issues/enhancements


Contributing
============

Read [here](https://ohdsi.github.io/Hades/contribute.html) how you can contribute to this package.


License
=======

ShinyAppBuilder is licensed under Apache License 2.0. 


Development
===========

ShinyAppBuilder is being developed in R Studio.


### Development status

Under development


Acknowledgements
================

