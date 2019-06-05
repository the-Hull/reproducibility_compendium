#' Calculate the change of a WB parameter over a time period in percent
#'
#' @description Calculates the change of a WB parameter over a time period in percent. Column 
#' input and output names are flexible, as are grouping variables (e.g country or region).
#'
#' @param .dat data.frame or tibble containing identifier.
#' @param start_year Numeric (length one), start year of period.
#' @param end_year Numeric (length one), end year of period.
#' @param value_col Column of interest (bare name)
#' @param year_col Column containing years (bare name)
#' @param outname Name for newly calculated change percent column
#' @param ... Grouping columns (bare names)
#'
#' @importFrom attempt stop_if_not
#' @importFrom tidyr spread
#' @import rlang
#' @import dplyr
#'
#' @return Returns a grouped tibble with the grouping column, two columns with 
#' the summed data of each group for the chosen start and end year, as well as 
#' a column `outname` with the calculated percent change over the given time period.
#' @export
#'
#' @examples
#  # pop_data <- data(pop_data)
#' wb_change_percent(.dat = pop_data,
#'     start_year = 2002,
#'     end_year = 2016,
#'     value_col = population,
#'     year_col = year,
#'     outname = "pop_change_perc",
#'     region) 
wb_change_percent <- function(.dat, 
                              start_year,
                              end_year,
                              value_col,
                              year_col,
                              outname = "val_change",
                              ...){
    
    # some sanity checks, not exhaustive
    attempt::stop_if_not(.x = .dat, 
                         .p = is.data.frame,
                         msg = "Input .dat needs to be a data frame or tibble.")
    
    attempt::stop_if_any(.l = list(start_year, end_year),
                         .p = Negate(is.numeric),
                         msg = "Start and end year need to be numeric.")
    
    attempt::stop_if_not(.x = outname,
                         .p = is.character)
    
    # for tidy evaluation with rlang
    value_col <- enquo(value_col)
    year_col <- enquo(year_col)
    
    group_cols <- quos(...)
    
    # intial grouping based on the chosen group cols, and always on year
    .dat <- .dat %>% 
        group_by(!!! group_cols, !! year_col)
    
    # set up for using column name strings for tidy eval in mutate later on
    col_year_end <- paste0(quo_name(year_col),"_", end_year)
    col_year_start <- paste0(quo_name(year_col), "_" ,start_year)
    
    # inserted this to fix an R CMD CHECK note
    temp <- NULL 
    
    # calculate percent change for the chosen years
    # approach relies on spread and tidy to return a useful result
    res <- .dat %>% 
        dplyr::filter(!! year_col == start_year | 
                          !! year_col == end_year) %>%
        summarise(temp = sum(!! value_col,na.rm = T)) %>%
        tidyr::spread(key = !! year_col, value = temp, sep = "_") %>% 
        mutate(!! outname := (( !! sym(col_year_end) -  !! sym(col_year_start)) /
                                  !! sym(col_year_end)) * 100)
    
    
    
    return(res)
    
}

