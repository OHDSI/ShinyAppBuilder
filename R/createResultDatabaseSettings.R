#' createDefaultResultDatabaseSettings
#'
#' @description
#' Create an R list with the default table prefixes and tables
#'
#' @details
#' User specifies the schema name and can override default table prefixes and table names
#' 
#' @param schema The schema containing the OHDSI study results
#' @param vocabularyDatabaseSchema The schema containing the vocabulary database 
#' @param cgTablePrefix The table prefix for cohort generator tables
#' @param cgTable The table with the cohort definitions in cohort generator 
#' @param databaseTable The table with the database details 
#' @param databaseTablePrefix The prefix for the databaseTable
#' @param cdTablePrefix The table prefix for the cohort diagnostic results
#' @param cTablePrefix The table prefix for the characterization results
#' @param incidenceTablePrefix The table prefix for the incidence results
#' @param plpTablePrefix The table prefix for the prediction results
#' @param cmTablePrefix The table prefix for the cohort method results
#' @param sccsTablePrefix The table prefix for the self controlled case series results
#' @param esTablePrefix The table prefix for the evidence synthesis method results
#' @param pvTablePrefix The table prefix for the phevaluator results
#' 
#' @return
#' An R list with the module config settings
#'
#' @export
#' 
createDefaultResultDatabaseSettings <- function(
    schema = 'main',
    vocabularyDatabaseSchema = schema,
    cgTablePrefix = 'cg_',
    cgTable = 'cohort_definition',
    databaseTable = 'DATABASE_META_DATA',
    databaseTablePrefix = '',
    cdTablePrefix = 'cd_',
    cTablePrefix = 'c_',
    incidenceTablePrefix = 'ci_',
    plpTablePrefix = 'plp_',
    cmTablePrefix = 'cm_',
    sccsTablePrefix = 'sccs_',
    esTablePrefix = 'es_',
    pvTablePrefix = 'pv_'
){
  
  resultDatabaseSettings <- list(
    schema = schema,
    vocabularyDatabaseSchema = vocabularyDatabaseSchema,
    cgTablePrefix = cgTablePrefix,
    cgTable = cgTable,
    databaseTable = databaseTable,
    databaseTablePrefix = databaseTablePrefix,
    cdTablePrefix = cdTablePrefix,
    cTablePrefix = cTablePrefix,
    incidenceTablePrefix = incidenceTablePrefix,
    plpTablePrefix = plpTablePrefix,
    cmTablePrefix = cmTablePrefix,
    sccsTablePrefix = sccsTablePrefix,
    esTablePrefix = esTablePrefix,
    pvTablePrefix = pvTablePrefix
  )
  
  return(resultDatabaseSettings)
}