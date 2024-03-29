% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wb_calc_change_percent.R
\name{wb_change_percent}
\alias{wb_change_percent}
\title{Calculate the change of a WB parameter over a time period in percent}
\usage{
wb_change_percent(.dat, start_year, end_year, value_col, year_col,
  outname = "val_change", ...)
}
\arguments{
\item{.dat}{data.frame or tibble containing identifier.}

\item{start_year}{Numeric (length one), start year of period.}

\item{end_year}{Numeric (length one), end year of period.}

\item{value_col}{Column of interest (bare name)}

\item{year_col}{Column containing years (bare name)}

\item{outname}{Name for newly calculated change percent column}

\item{...}{Grouping columns (bare names)}
}
\value{
Returns a grouped tibble with the grouping column, two columns with 
the summed data of each group for the chosen start and end year, as well as 
a column `outname` with the calculated percent change over the given time period.
}
\description{
Calculates the change of a WB parameter over a time period in percent. Column 
input and output names are flexible, as are grouping variables (e.g country or region).
}
\examples{
wb_change_percent(.dat = pop_data,
    start_year = 2002,
    end_year = 2016,
    value_col = population,
    year_col = year,
    outname = "pop_change_perc",
    region) 
}
