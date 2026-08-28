## What you will find here

This directory contains all input scripts needed to run decontamination on sequencing data (indicated with an asterisk). There are also example files for sequencing data included in the data directory (indicated with an asterisk). Additional scripts included are specific to OME group and don't include asterisks, including `Join_faire_metadata.R`,`download_neg_con_metadata.R`, and `combo_nc_assoc_multiple_runs.sh`.

### Directory structure

**Part I input files and directory**

```text
PartI_run_inputs/
├── data/
│   ├── processed/decontamination/
│   │             └── Known_contaminants.csv*
|   |             └── Metadata_faire.csv*
|   |             └── Uknown_characters.csv*
│   └── raw/
|       └── ASVs.fa*
|       └── counts.tsv*
|       └── taxonomy.txt*
|
└── scripts/decontamination/
            └── create_dir_structur.R*
            └── decontam_pre-merge_18Sv4.yaml*
            └── decontamination_utilities.R*
            └── Decontam_partI.Rmd*
            └── Join_faire_metadata.R
            └── download_neg_con_metadata.R
            └── combo_nc_assoc_multiple_runs.sh
```

**Part II-IV input files and directory**

```text
PartII_IV_project_inputs/
├── data/
│   ├── processed/decontamination/
|   |             └── Metadata_faire.csv*
|   |             └── Uknown_characters.csv*
│   └── raw/
|
└── scripts/decontamination/
            └── create_dir_structur.R*
            └── decontam_post-merge_18Sv4.yaml*
            └── decontamination_utilities.R*
            └── merging_functions.R*
            └── Decontam_partII.Rmd*
            └── Decontam_partIII.Rmd*
            └── Decontam_partIV.Rmd*
```
