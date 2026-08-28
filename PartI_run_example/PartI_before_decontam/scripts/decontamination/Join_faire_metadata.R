# Last updated:
Sys.time()

# Goal of script:
# Load sample and experimentRun metadata into one file for decontamination.
# install.packages("googlesheets4") # install and choose cran mirror

### load libraries
library("tidyverse")
library("here")
library("googlesheets4")
here()

# Store your sheet URL
sheet_url <- "GOOGLEDOCURLHERE"

# Read in each sheet
sample_metadata <- read_sheet(sheet_url, sheet = "sampleMetadata")
experiment_run_metadata <- read_sheet(sheet_url, sheet = "experimentRunMetadata")

# convert columns that have mixed data types and read in as a list:by
sample_metadata <- sample_metadata %>%
# Force every list column into a basic character column
  mutate(across(where(is.list), ~ map_chr(.x, as.character))) %>%
  # Automatically guess and apply the correct data types (e.g., numeric)
  type_convert()

experiment_run_metadata <- experiment_run_metadata %>%
# Force every list column into a basic character column
  mutate(across(where(is.list), ~ map_chr(.x, as.character))) %>%
  # Automatically guess and apply the correct data types (e.g., numeric)
  type_convert()


# if running from downloaded metadata files:
# directory with faire data:
# file_path<-here("data","processed","decontamination")

# load metadata files and join if needed:
# experiment_run_metadata <- read_csv(here(file_path,"experimentRunMetadata_faire.csv"))
# sample_metadata <- read_csv(here(file_path,"sampleMetadata_faire.csv"))

# combine metadata
metadata_file <- experiment_run_metadata %>% 
    left_join(sample_metadata %>% select(-"assay_name"), by="samp_name")
# save combined file:
write_csv(metadata_file, here("data","processed","decontamination","Metadata_faire.csv"))

### Print session info
print(sessionInfo(), locale = FALSE)
