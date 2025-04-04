# Using Shiny App builder on OHDSI/ShinyProxyDeploy

1. Ensure data is uploaded to the OHDSI postgres server

2. Add the following to the application.yml file:

```yaml

  specs:
    ... # Keep old configuration intact, only append
    - id: <id>_MyStudyName
        display-name: My study name
        description: Study description
        container-cmd: ["R", "-e", "shiny::runApp('/srv/shiny-server/ShinyAppBuilder', host = '0.0.0.0', port = 3838)"]
        container-image: ohdsi/shiny-app-builder:latest
        container-volumes:
          - "/home/jenkins/shinyproxy/.Renviron:/root/.Renviron"
          - "/home/jenkins/minio/data/sp-app-data:/data"
        container-env:
          RESULT_DATABASE_SCHEMA: my_study_result_schema
          # Set to true or false to enable or disable modules
          SHINY_ABOUT_CFG: True
          SHINY_DATA_SOURCE_CFG: True
          SHINY_CG_CFG: True
          SHINY_CD_CFG: True
          SHINY_C_CFG: True
          SHINY_PLP_CFG: True
          SHINY_CM_CFG: True
          SHINY_SCCS_CFG: True
          SHINY_META_CFG: True
```

3. Create a pull request
4. Wait for approval. Once merged into main you will find your app at https://results.ohdsi.org