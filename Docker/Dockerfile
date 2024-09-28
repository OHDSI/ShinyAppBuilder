FROM ohdsi/ohdsi-shiny-modules
# Set an argument for the app name and port
ARG APP_NAME
ARG SHINY_PORT

# Set arguments for the GitHub branch and commit id abbreviation
ARG GIT_BRANCH=main
ARG GIT_COMMIT_ID_ABBREV
ARG OSM_GIT_BRANCH=main

RUN R CMD javareconf
# Make sure OSM is up to date
RUN R -e 'remotes::install_github("OHDSI/OhdsiShinyModules", ref=Sys.getenv("OSM_GIT_BRANCH"), update = "always")'
# Run install on git ref or specified arg branch
RUN R -e "ref <- Sys.getenv('GIT_COMMIT_ID_ABBREV', unset=Sys.getenv('GIT_BRANCH')); remotes::install_github('OHDSI/ShinyAppBuilder', ref=ref)"

# Set workdir and copy app files
WORKDIR /srv/shiny-server/${APP_NAME}
COPY ./app.R ./

EXPOSE 3838
RUN R -e "shiny::runApp('/srv/shiny-server/${APP_NAME}', host = '0.0.0.0', port = 3838)"