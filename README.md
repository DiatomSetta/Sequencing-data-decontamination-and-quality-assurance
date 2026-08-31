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

## Running decontamination and quality assurance on sequencing data:

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