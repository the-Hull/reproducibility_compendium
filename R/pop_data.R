#' World Bank Global Population.
#'
#' A dataset containing the total population on country and regional level.
#'
#' @format A data frame with 12035 rows and 8 variables:
#' \describe{
#'   \item{country_name}{Character, name of each country}
#'   \item{country_code}{Character, country identifier code}
#'   \item{indicator_name}{Character, WB indicator name}
#'   \item{indicator_code}{Character, WB indicator code}
#'   \item{year}{Numeric, year of observation}
#'   \item{population}{Numeric, population in millions}
#'   \item{region}{Character, World region}
#'   \item{incomegroup}{Character, WB income group}
#'   ...
#' }
#' @source \url{http://https://data.worldbank.org/indicator/SP.POP.TOTL/}
"pop_data"
