# Sequencing data decontamination and quality assurance
Quality assurance and decontamination of sequencing data from raw asv tables to data submission and downstream data processing.

*Note: These scripts are still under development by the Ocean Molecular Ecology (OME) Group*

## Workflow of steps

Main processing steps include:
 * Part I) Filter out known contaminants and those found in negative and positive controls.
 * Part II) Merge samples across sequencing runs.
 * Part III) Depth, diversity, replicate filtering
 * Part IV) Final filtering and optional steps

![Sequencing data decontamination and quality assurance workflow](https://github.com/DiatomSetta/Sequencing-data-decontamination-and-quality-assurance/blob/main/Sequencing-data-decontamination-and-quality-assurance.jpg)

## To run decontam and QA/QC on sequencing data:
OLD --> 1) Edit the config files (.yaml) with file locations and filtering thresholds to run each R script.
OLD --> 2) Run the decontamination and quality assurance scripts in order (partI-IV), editing filtering thresholds in the config files as needed.

<u>Part I - Decontamination by sequencing run</u>
1) Copy all necessary scripts (listed below) to your directory, in a folder within `scripts/decontamination/`. Scripts specific to the OME group are labeled as such below.
  a. create_dir_structure.R
  b. decontamination_utilities.R
  c. Run1_Decontam_partI.Rmd
  d. Join_faire_metadata.R (OME group)
  e. download_neg_con_metadata.R (OME group)
  f. decontam_pre-merge_region.yaml (edit with region of interest)

2) If using VS code, open folder of parent directory (e.g. OME_Run1).

3) Run create_dir_structure.R script to make sure directory structure for code is set-up.

4) Copy `Known_contaminants.csv` and `Unknown_characters.csv` files for decontamination into the `data/processed/decontamination` directory.

5) Copy sequencing files to `data/raw` either directly or with symlink (OME group). Need at least three files for Part I, fasta sequencing file (.fa), asv count file (.tsv), and taxonomy files (can include multiple here but all should be tab-delimited). To create symlink to original file location and save space, use the code below which will create a symlink to the file (in this case labeled by `Run1_16Sv4_ASVs.fa`. Note, you need the absolute directory path to correctly reference the original file.

```
ln -s $eDNA_DIR/Run1/01_REVAMP/18Sv4/dada2/ASVs.fa $HOME_DIR/OME_Run1/data/raw/Run1_16Sv4_ASVs.fa
```

6) Edit the config file depending on the region of interest. Examples used for OME group that differ by region, below:
   
8) afddsafds
