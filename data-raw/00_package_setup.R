
# pck-set-up ------------------------------------------------------------------

library(devtools)
library(usethis)
library(desc)

# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "WBanalyses")

#Set your name
my_desc$set("Authors@R", "person('Alex', 'Hurley', email = 'agl.hurley@gmail.com', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "Analyses of WB Population data in an exemplary package compendium")
# The description of your package
my_desc$set(Description = "This is a test run for an analyses based on reproducible research principles.")
# The urls
my_desc$set("URL", "http://github.com/the-hull/wbAnalyses")
my_desc$set("BugReports", "http://github.com/the-hull/wbAnalyses/issues")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license(name = "Alex HURLEY")
use_code_of_conduct()
use_lifecycle_badge("Experimental")
use_news_md()

# Get the dependencies
# use_package("tidyverse")
use_package("ggplot2")
use_package("dplyr")
# use_package("jsonlite")
# use_package("curl")
# use_package("attempt")
# use_package("purrr")

# Clean your description
use_tidy_description()
