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

## 🚀 Installation & Setup Instructions!

Part of the OME team and running on OME high-computing cluster (HPC)? See the [OME Section](#running-decontamination-and-quality-assurance-with-OME-HPC) for details.

Not part of the OME team or running on local computer? See the [Github Section](#running-decontamination-and-quality-assurance-with-github-repo-files) for details.

## Running decontamination and quality assurance with github repo files

### Part I - Decontamination by sequencing run

  1. Download the [`Inputs/PartI_run_inputs/`](https://github.com/DiatomSetta/Sequencing-data-decontamination-and-quality-assurance/tree/2cbd7af136c3e5e66d7ba6f0081c51d0b3b18ef7/Inputs/PartI_run_inputs) folder which includes all the necessary scripts and files (listed below). Scripts specific to the OME group are labeled as such below.
   
  * create_dir_structure.R [scripts]
  * decontamination_utilities.R [scripts]
  * Decontam_partI.Rmd [scripts]
  * decontam_pre-merge_region.yaml [scripts]
  * Known_contaminants.csv [data]
  * Unknown_characters.csv [data]
  * Join_faire_metadata.R (OME group) [scripts]
  * download_neg_con_metadata.R (OME group) [scripts]
  
  *The create_dir_structure.R file will create the directory structure needed for the scripts, but is the same as the PartI_run_inputs directory*

1. Examples of data files are included in `Inputs/PartI_run_inputs/` to test scripts and decontamination pipeline. Files needed for the decontamination pipeline are a metadata file (ex: `processed/decontamination/Metadata_faire.csv`), fasta file (`raw/ASVs.fa`), asv table (`raw/counts.tsv`), and taxonomy table (`taxonomy.txt`).

2. OME team members should copy the sequencing files from the `eDNA_Bioinformatics` directory to `data/raw` with symlink (see example below). Need to copy three files for Part I, fasta sequencing file (.fa), asv count table (.tsv), and taxonomy table (can include multiple here but all should be tab-delimited). To create symlink to original file location and save space. Note, you need the absolute directory path to correctly reference the original file.

```
# For asv table:
ln -s $eDNA_Bioinformatics/Run1/01_REVAMP/18Sv4/dada2/ASVs.fa $HOME_DIR/OME_Run1/data/raw/Run1_18Sv4_ASVs.fa
# For asv table:
ln -s $eDNA_Bioinformatics/Run1/01_REVAMP/18Sv4/dada2/ASVs_counts.tsv $HOME_DIR/OME_Run1/data/raw/Run1_18Sv4_counts.tsv
# For taxonomy table from revamp:
ln -s $eDNA_Bioinformatics/Run1/01_REVAMP/18Sv4/ASV2Taxonomy/18Sv4_asvTaxonomyTable.txt $HOME_DIR/OME_Run1/data/raw/Run1_18Sv4_tax_revamp.txt

```
  *Note: Replace $eDNA_Bioinformatics with absolute path, and $HOME_DIR with the absolute path to your home directory*
   
3. Before running any scripts rename folders and files as apropriate for the sequencing run you are processing (e.g. Run1, Run2, etc.). Then open the parent directory (PartI_run_inputs) in Visual Studio code (VS code), or as an R markdown project.
   
4. OME team members should run both the `Join_faire_metadata.R` and `download_neg_con_metadata.R` in the run folder to download the most recent version of the faire metadata spreadsheet and the negative control spreadsheet. URLs for both can be found on the `Steps_for_processing` tab of the `OME_Decontamination_Progress_Notes` spreadsheet in the `OME_Decontamination` project folder. You will need to log into your google account within your coding environment (VS code, R) to access the files.

    *For all others, add negative control data to a file structured similarly to the [NegativeControls.csv](https://github.com/DiatomSetta/Sequencing-data-decontamination-and-quality-assurance/blob/2cbd7af136c3e5e66d7ba6f0081c51d0b3b18ef7/Example_decontamination/PartI_run_example/data/processed/decontamination/NegativeControls.csv) file in the in the `Example_decontamination/PartI_run_example/data/processed` folder*
   
5. Edit the config file (`decontam_pre-merge_region.yaml`) with the correct paths to each file and region specific filtering information.
   
6. Edit the `Decontam_partI.Rmd` file front matter at the top of the file with the naming schema for the run and region of interest. The config file name also needs to be edited in the third code chunk of the file named `load-config` to the config file for the region of interest (e.g for 18Sv4, `decontam_pre-merge_18Sv4.yaml`). Examples used for OME group that differ by region, below:

```

```

7. Knit the R markdown file (`Decontam_partI.Rmd`), which should produce the same output files as the `Example_decontamination/PartI_run_example` folder.
   
8. OME team members should update the `Decontam_notes` tab in the `OME_Decontamination_Progress_Notes` spreadsheet in the `OME_Decontamination` project folder with progress and notes on filtering steps. The html file produced by the R markdown file should also be copied to the `Markdown_decontam_output` folder within the same project directory for others to review as needed.

### Part II - Merging across sequencing runs

1. Similar to Part I, download the [`Inputs/PartII_IV_project_inputs/`](https://github.com/DiatomSetta/Sequencing-data-decontamination-and-quality-assurance/tree/c9ed8597750e86a2c09bc2929b058a02b9cfedae/Inputs/PartII_IV_project_inputs) folder which includes all the necessary scripts and files (listed below). Scripts specific to the OME group are labeled as such below.
   
  * create_dir_structure.R [scripts]
  * decontamination_utilities.R [scripts]
  * merging_functions.R [scripts]
  * Decontam_partII.Rmd [scripts]
  * Decontam_partIII.Rmd [scripts]
  * Decontam_partIV.Rmd [scripts]
  * decontam_post-merge_region.yaml [scripts]
  * Unknown_characters.csv [data]
  * Join_faire_metadata.R (OME group) [scripts]
  
  *The create_dir_structure.R file will create the directory structure needed for the scripts, but is the same as the PartI_run_inputs directory*

## Running decontamination and quality assurance with OME HPC

### Part I - Decontamination by sequencing run

*Note: OME Runs 1-3 must be run in a particular order, Run 2 and Run 3 must be run before Run 1 for negative control filtering*

  1. Copy one of the run folders from `setta` directory (e.g. `OME_Run1`).
  2. Check the raw sequencing files you need are in `run/data/raw` directory. If not add symlink to files in the `eDNA_Bioinformatics` directory (see github repo files section Part I Step 2 below).
  3. Run `Join_faire_metadata.R` to ensure most updated metadata is downloaded, you will need to login with your gmail credentials to access google sheets.
  4. Run `download_neg_con_metadata.R` to ensure most updated negative control data is downloaded, once again you'll use your gmail credentials to access google sheets.
  5. If Run 2 and Run 3 are already run and you are on Run 1, run the `combo_nc_assoc_multiple_runs.sh` script to merge negative controls from those runs to use with Run 1. Edit `$BASE_DIR` and `$OUTPUT_FILE` directories to those for your HPC folders.
  6. Edit the config file (`decontam_pre-merge_18Sv4.yaml`) for the metabarcoding region of interest. 
  7. Edit the `Run#_Decontam_partI.Rmd` R markdown file. In line 1 check the run number and in line 7 check the run number and metabarcoding region is correct for the html output file. In the first code chunk `load-config` edit the config file name to match the decontamination file name you saved (e.g. `decontam_pre-merge_18Sv4.yaml`).
  8. Run the `Run#_Decontam_partI.Rmd` R markdown file, either chunk by chunk or by knitting the file.
  9. If you get errors when running the markdown file, check the end of the `sample_mismatch.csv` file to make sure the final name and asv sample name match. If they don't, you will likely need to edit the `merge-data` r code chunk in the markdown file so the sample names match. Let Sam know if you have to do this so the master code can be edited.
  10. Update the `OME_Decontamination_Progress_Notes` with any notes and status after completing part I. Upload the `html` output file into the `OME_Decontamination/Markdown_decontam_output` folder in the projects directory.

### Part II-IV - Merging across sequencing runs

   1. Copy one of the project folders from `setta/OME_Projects` directory (e.g. `WCOA21`).
   2. To run this you will need to reference the processed files from part I of all the sequencing runs this project was run across. This can be specified in the config file (`decontam_post-merge_marker`) in the `parent_dir` variable that sets the parent directory within which all of the processed run data is found with the same directory structure as Run1 decontamination output.
   3. Run `Join_faire_metadata.R` to ensure most updated metadata is downloaded, you will need to login with your gmail credentials to access google sheets.
   4. Edit the config file with correct directories, decontamination parameters, marker regions, and runs for project.
   5. Edit the `Run#_Decontam_partII.Rmd`, `Run#_Decontam_partIII.Rmd`, and `Run#_Decontam_partIV.Rmd` R markdown files. In line 1 check the project and in line 7 check the project and metabarcoding region is correct for the html output file. In the first code chunk `load-config-file` edit the config file name to match the decontamination file name you saved (e.g. `decontam_post-merge_18Sv4.yaml`).
   6. Run the `Run#_Decontam_partI.Rmd` R markdown file, either chunk by chunk or by knitting the file. This will take a while if merging across multiple runs.
   7. Check output files and edit config file parameters if neccessary. 
   8. Update the `OME_Decontamination_Progress_Notes` with any notes and status as each decontamination part is completed. Upload the `html` output file into the `OME_Decontamination/Markdown_decontam_output` folder in the projects directory.

### Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and
Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project
code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the
Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub
project will be governed by all applicable Federal law. Any reference to specific commercial products,
processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or
imply their endorsement, recommendation or favoring by the Department of Commerce. The Department
of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to
imply endorsement of any commercial product or activity by DOC or the United States Government.
