% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ViewShiny.R
\name{createShinyApp}
\alias{createShinyApp}
\title{createShinyApp}
\usage{
createShinyApp(
  config,
  connection,
  resultDatabaseSettings = createDefaultResultDatabaseSettings(),
  connectionDetails = NULL,
  usePooledConnection = TRUE,
  studyDescription =
    "No description provided. Further details about the analyses used in this study can be found below.",
  title = "OHDSI Analysis Viewer",
  protocolLink = "http://ohdsi.org",
  themePackage = "ShinyAppBuilder"
)
}
\arguments{
\item{config}{The json with the app config}

\item{connection}{A connection to the results}

\item{resultDatabaseSettings}{A list with the result schema and table prefixes}

\item{connectionDetails}{A DatabaseConnector::connectionDetails connection to the results database}

\item{usePooledConnection}{Use a pooled database connection or not - set to true for multi-user environments (default)}

\item{studyDescription}{A human-readable character string describing the study/analysis}

\item{title}{The title for the app.  Defaults to: OHDSI Analysis Viewer}

\item{protocolLink}{A link to a site containing the study protocol}

\item{themePackage}{A package containing custom theme elements}
}
\value{
Shiny app instance
}
\description{
Create a shiny app for a shiny server
}
\details{
User specifies the json config and connection
}
