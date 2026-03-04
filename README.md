# Sequencing data decontamination and quality assurance
Quality assurance and decontamination of sequencing data from raw asv tables to data submission and downstream data processing.

*Note: These scripts are still under development by the Ocean Molecular Ecology (OME) Group*

## To run decontam and QA/QC on sequencing data:
1) Edit the config files (.yaml) with file locations and filtering thresholds to run each R script.
2) Run the decontamination and quality assurance scripts in order (partI-IV), editing filtering thresholds in the config files as needed.

## Workflow of steps

Main processing steps include:
 * Part I) Filter out known contaminants and those found in negative and positive controls.
 * Part II) Merge samples across sequencing runs.
 * Part III) Depth, diversity, replicate filtering
 * Part IV) Final filtering and optional steps

![Sequencing data decontamination and quality assurance workflow](https://github.com/DiatomSetta/Sequencing-data-decontamination-and-quality-assurance/blob/main/Sequencing-data-decontamination-and-quality-assurance.jpg)
