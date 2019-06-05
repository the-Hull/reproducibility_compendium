
# Load data and process into ggplot ready df's

library(dplyr)
library(tidyr)
library(usethis)
library(purrr)

# Load files --------------------------------------------------------------

file_path <- "./data-raw/API_SP.POP.TOTL_DS2_en_csv_v2_9944650.zip"

# make file list
list_of_files <- unzip(file_path, list = TRUE)[, 1]

# establish connection to population data file
file_conn <- unz(file_path, list_of_files[2])

# make long data
pop_data <- readr::read_csv(file_conn, skip = 4) %>% 
    dplyr::select(1:61) %>% 
    tidyr::gather(key = "year", value = "population", -matches("[a-zA-Z]"))

# establish connection to meta data file 
file_conn <- unz(file_path, list_of_files[3])

# clean and join with data above
pop_data <- readr::read_csv(file_conn) %>% 
    dplyr::select(-SpecialNotes, -X6, -`Country Code`) %>% 
    dplyr::left_join(pop_data,., by = c("Country Name" = "TableName")) %>% 
    purrr::set_names(tolower(colnames(.) %>% 
                                 sub(" ", "_", .))) %>% 
    tidyr::drop_na() %>% 
    dplyr::mutate(population = population * 1e-6,
                  year = as.numeric(year)) 




# this last step saves our object into the data/ folder, attaching it to our
# global environment when the package is loaded
usethis::use_data(pop_data, overwrite = T)

