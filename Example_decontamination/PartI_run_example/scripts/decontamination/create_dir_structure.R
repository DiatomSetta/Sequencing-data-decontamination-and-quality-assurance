## Set-Up for decontamination

# Run this to create the directory structure for files

library("here")
# create decontam directory structure
dir.create(here("scripts","decontamination"), recursive = TRUE)
dir.create(here("data","raw"), recursive = TRUE)
dir.create(here("data","processed","decontamination"), recursive = TRUE)
