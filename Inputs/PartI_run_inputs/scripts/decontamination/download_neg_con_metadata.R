# Last updated:
Sys.time()

# Goal of script:
# Load negative control sample information for decontamination.
# install.packages("googlesheets4") # install and choose cran mirror

### load libraries
library("tidyverse")
library("here")
library("googlesheets4")
here()

# Store your sheet URL
sheet_url <- "GOOGLEDOCURLHERE"

# Read in data and convert dates
neg_con_metadata <- read_sheet(sheet_url, col_types = "c") %>%
  mutate(date_of_extraction = as.Date(
                                parse_date_time(date_of_collection_utc, orders = c("dmy"))),
        date_of_collection_utc =  as.Date(                        
                                        parse_date_time(date_of_collection_utc, orders = c("dmy")))
  )

# save combined file:
write_csv(neg_con_metadata, here("data","processed","decontamination","NegativeControls.csv"))

### Print session info
print(sessionInfo(), locale = FALSE)
