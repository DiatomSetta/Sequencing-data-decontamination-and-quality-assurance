# Goal of code: 
# Merge taxonomies across all runs from PR2 output.

## load libraries
library("devtools")
library("tidyverse")
library("knitr")
library("readxl")
library("here")
library("digest")
library("configr")
library("Biostrings")
library("digest")
here()

#' Merge taxonomic id's across multiple sequencing runs.
#'
#' Function to merge across taxonomies based on specific naming scheme and input of parameters from  a .yaml config file.
#' * Note: fasta file input must have naming scheme of `ASVs.fa`
#'
#' @param `config_file_name` A .yaml file name that contains the following entries:
#' * `runs_for_project`: comma seperated list of the names of the sequencing run folders (from partI of decontam).
#' * `region`: name of metabarcoding region used in partI output folder naming scheme.
#' * `parent_dir`: parent directory that contains all of the runs from partI
#' 
#' @returns Dataframe of asvs from all runs associated with the project.
#' 
#' @examples
#' merge_asv_output("config_file_name.yaml")
#' @export
merge_asv_output <- function(config_file_name) {
   ## load config file of variables for script
    option_list <- list(
    make_option(c("-c", "--config"), type="character", default=here("scripts","decontamination",config_file_name),
                help="Path to configuration file [default %default]", metavar="FILE")
    )
    opt_parser <- OptionParser(option_list=option_list)
    opt <- parse_args(opt_parser)
    # check if yaml
    print(is.yaml.file(opt$config))
    config_file <- read.config(opt$config)
    # save runs as a list:
    runs_file<-strsplit(config_file$runs_for_project, split = ",")[[1]]
    print(config_file$region)

    ## Load all asv tables:
    nested_results <- list()

    for (run in runs_file) {
        run_name<-str_remove(run, "^.*?_")
      
        nested_file <- readRDS(here(
          config_file$parent_dir,run,"data","processed","decontamination",
          config_file$region,"Output_R","ASV_nested_final_partI.RDS"))
        
        fasta_file <- readDNAStringSet(here(
          config_file$parent_dir,run,"data","raw",
          paste0(run_name,"_",config_file$region,"_","ASVs.fa")),
          format ="fasta") %>%
          as.data.frame() %>%
          rownames_to_column(var="ASV") %>%
          dplyr::rename("sequence" = `x`) %>%
          mutate(seq_id=map_chr(sequence, ~ digest(.x, algo = "md5", serialize = FALSE)))

        trimmed_nested_file<-
          nested_file %>% dplyr::select(Step5_non_target) %>%
          unnest(Step5_non_target) %>%
          unique() %>%
          dplyr::select(-any_of("sample_nc_flag")) %>%
          pivot_wider( # pivot wider so read counts are now below each sample name
            names_from = sample,
            values_from = reads,
            values_fill = list(reads = 0)
          )  %>% 
          mutate(iter = run_name) %>%
          left_join(fasta_file, by="seq_id") %>% relocate(sequence, .after="seq_id")
        
        nested_results[[run_name]] <- trimmed_nested_file
        
    }

    asv_tables <- bind_rows(nested_results) %>%
          dplyr::rename("sum.taxonomy" = Taxon) %>%
            mutate(across(-c(sequence:sum.taxonomy, iter, ASV), ~replace_na(.x, 0))) %>%
            relocate(c(ASV,iter),.after="seq_id")

    return(asv_tables) 
}


#' Merge taxonomic id's across multiple sequencing runs.
#'
#' Function to merge across taxonomies based on specific naming scheme and input of parameters from  a .yaml config file.
#'
#' @param `config_file_name` A .yaml file name that contains the following entries:
#' @param `tax_file_ext` A file extension for the taxonomy files to merge.
#' 
#' @returns Dataframe of final taxonomy for seq_id's found across sequencing runs.
#' 
#' @examples
#' merge_taxa_output("config_file_name.yaml")
#' @export
merge_taxa_output <- function(config_file_name, tax_file_ext) {
    ## load config file of variables for script
    option_list <- list(
    make_option(c("-c", "--config"), type="character", default=here("scripts","decontamination",config_file_name),
                help="Path to configuration file [default %default]", metavar="FILE")
    )
    opt_parser <- OptionParser(option_list=option_list)
    opt <- parse_args(opt_parser)
    # check if yaml
    print(is.yaml.file(opt$config))
    config_file_nm <- read.config(opt$config)
    # save runs as a list:
    runs_file<-strsplit(config_file_nm$runs_for_project, split = ",")[[1]]
    print(config_file_nm$region)

    # load and merge taxonomy file:configfor (run in runs_file)
    # Load all run data from nested asv into R and merge:
    all.taxa <- list()

    for (run in runs_file) {
        run_name<-str_remove(run, "^.*?_")
        # so we know what run the function is iterating through
        print(run_name)

        fasta.file <- readDNAStringSet(here(
        config_file_nm$parent_dir,run,"data","raw",
        paste0(run_name,"_",config_file_nm$region,"_","ASVs.fa")),
        format ="fasta") %>%
        as.data.frame() %>%
        rownames_to_column(var="ASV") %>%
        dplyr::rename("sequence" = `x`) %>%
        mutate(seq_id=map_chr(sequence, ~ digest(.x, algo = "md5", serialize = FALSE))) %>%
        dplyr::select(c("ASV","seq_id"))
    
        taxa.file <- read_delim(here(
        config_file_nm$parent_dir,run,"data","raw",
        paste0(run_name,"_",config_file_nm$region,"_",tax_file_ext)),delim="\t")  %>% 
        { if("Taxon" %in% colnames(.)) {
          message("Taxonomy already in one column")
          .
          } else {
            tidyr::unite(., "Taxon", -c("ASV"), sep=";", remove=TRUE, na.rm = FALSE)
          }
        } %>%
                  mutate(iter = run_name) %>%
                  mutate(Taxon = str_remove(Taxon, ";+$")) %>%
                  # if Feature ID present, replace with ASV:
                  { 
                    if("Feature ID" %in% colnames(.)) {
                      dplyr::rename(., "ASV"=`Feature ID`)
                      } else {
                        .
                      }
                    } %>%
                  # if no 'confidence' in taxonomy, create a dummy variable
                  { 
                    if("Confidence" %in% colnames(.)) {
                      .
                      } else {
                        dplyr::mutate(., Confidence = 1)
                      }
                    } %>%
                  left_join(fasta.file, by="ASV")
                  
                  all.taxa[[run_name]] <- taxa.file
                  
              }

    # bind taxa across all runs:
    all_taxa_v2 <- bind_rows(all.taxa)

    # merge across seq_id with a nested dataframe:
    merged_taxa <- all_taxa_v2 %>%
                    # Filter out NAs first so they don't end up in your lists
                    filter(!is.na(iter), !is.na(ASV), !is.na(Taxon), !is.na(Confidence)) %>%
                    group_by(seq_id) %>%
                    # Nest ASV, Taxon, and Confidence into a list-column named 'data'
                    nest(data = c(iter,ASV, Taxon, Confidence))
                        # summarise(
                        # iter = paste(unique(na.omit(iter)), collapse = ","),
                        # ASV = paste(unique(na.omit(ASV)), collapse = ","),
                        # Taxon = paste(unique(na.omit(Taxon)), collapse = ","),
                        # Confidence = paste(unique(na.omit(Confidence)), collapse = ","))
        
    return(merged_taxa)
}

#' Helper function to find the common prefix of semicolon-separated strings
#'
#' Function to compare confidence scores and taxonomies, following three rules:
#'   Rule 1: If confidence higher (down to second decimal) for one ASV compared to another choose that ASV.
#'   Rule 2: If confidence is the same, choose taxonomy with lower id'd taxonomy, if they match at higher taxonomic levels.
#'   Rule 3: If confidence is the same, and don't match at higher taxonomic levels, reduce down to lowest matching taxonomy.
#'
#' @param `Taxon` A taxon string seperated by semicolons, for a seq_id. Can be used by purrr::map_chr to pull each seq_id and compare taxon strings.
#' 
#' @returns A final taxon string and confidence for 'best choice' for each sequence id.
#' 
#' @examples
#' find_common_taxon(taxa=taxa_in_df)
#' @export
find_common_taxon <- function(taxa) {
  taxa <- as.character(unlist(taxa))
  
  # Quick escape if all entries are completely identical
  if (length(unique(taxa)) == 1) return(taxa[1])
  
  # Split all taxa into their individual ranks
  split_taxa <- strsplit(taxa, ";")
  
  # Find the depth of the shortest and longest strings in the tie
  lengths <- sapply(split_taxa, length)
  min_depth <- min(lengths)
  max_depth <- max(lengths)
  
  # Check if all strings completely match up to the shortest string's depth
  all_match_to_min <- TRUE
  for (i in 1:min_depth) {
    ranks_at_i <- sapply(split_taxa, function(x) x[i])
    if (length(unique(ranks_at_i)) != 1) {
      all_match_to_min <- FALSE
      break
    }
  }
  
  if (all_match_to_min) {
    # RULE 1: They match perfectly all the way down to the shorter string's limit.
    # Return the entry with the longest string (highest depth).
    longest_idx <- which.max(lengths)
    return(taxa[longest_idx])
    
  } else {
    # RULE 2: They do not match. Find the exact point of divergence and roll back.
    common_depth <- 0
    for (i in 1:min_depth) {
      ranks_at_i <- sapply(split_taxa, function(x) x[i])
      if (length(unique(ranks_at_i)) == 1) {
        common_depth <- i
      } else {
        break
      }
    }
    
    if (common_depth == 0) return(NA_character_)
    return(paste(split_taxa[[1]][1:common_depth], collapse = ";"))
  }
}

#' Final taxonomy from merged taxonomies across sequencing runs.
#'
#' Choose 'best' taxonomies after merging across sequencing runs using the find_common_taxon() function.

#'
#' @param df A nested dataframe of merged taxonomy
#'   * `seq_id`: Unique hashmd5 for full sequence, used as replacement for ASV id.
#'   * `iter`: Sequencing run for the sequence id's.
#'   * `ASV`: ASV id's for merged sequence id's if multiple, separated by a comma
#'   * `Confidence`: Confidence or other measure of taxonomic classifier likelihood.
#' @returns Dataframe of final taxonomy for seq_id's found across sequencing runs.
#' @examples
#' choose_best_taxa(merged_taxa_df)
#' @export
choose_best_taxa <- function(df) { 
    result <- df %>%
    mutate(
        # Pre-clean the Taxon column inside the nested lists
        data = map(data, function(sub_df) {
        sub_df <- as.data.frame(sub_df)

        sub_df %>%
            mutate(
            # Force clean text, stripping anything starting with ; and ending with _sp. at the end
            Taxon = map_chr(Taxon, ~ str_remove(as.character(.x[1]), ";[^;]*_sp\\.?$"))
            )
        }),
        # Clean and filter the sub-tables using map()
        winner_tibble = map(data, function(sub_df) {
          sub_df <- sub_df %>%
            mutate(
            ASV = map_chr(ASV, ~ as.character(.x[1])),
            Taxon = map_chr(Taxon, ~ as.character(.x[1]))
          )

        # Check if Confidence exists
        if ("Confidence" %in% colnames(sub_df)) {
          sub_df <- sub_df %>%
            mutate(
                conf_numeric = map_dbl(Confidence, ~ as.numeric(.x[1])),
                conf_rounded = round(conf_numeric, 2)
            ) %>%
            # Isolate the highest rounded confidence rows
            filter(conf_rounded == max(conf_rounded, na.rm = TRUE)) %>%
            # Break ties with absolute confidence
            arrange(desc(conf_numeric)) %>%
            dplyr::slice(1)
        } else {
          # No Confidence column: just take the first row as the structural winner
          sub_df <- sub_df %>%
            dplyr::slice(1) %>%
            mutate(conf_numeric = NA_real_)
        }

        return(sub_df)
      }),
        
        # Extract the common taxon across the ties using map()
        Final_Taxon = map_chr(data, function(sub_df) {
        sub_df <- as.data.frame(sub_df)    

        if ("Confidence" %in% colnames(sub_df)) {
            taxa_in_df <- sub_df %>%
              mutate(
                  conf_numeric = map_dbl(Confidence, ~ as.numeric(.x[1])),
                  conf_rounded = round(conf_numeric, 1)
              ) %>%
            filter(conf_rounded == max(conf_rounded, na.rm = TRUE)) %>%
            pull(Taxon)
        } else {
            # No Confidence column: bypass filtering and evaluate all taxa
            taxa_in_df <- sub_df %>% pull(Taxon)
        }
        
        res <- find_common_taxon(taxa_in_df)
        if (length(res) == 0 || is.na(res)) return(NA_character_)
        as.character(res[1])
      }),
        
        # Pull flat values out of our winner tibbles
        Final_iter = map_chr(winner_tibble, ~ as.character(.x$iter[1])),
        Final_ASV  = map_chr(winner_tibble, ~ as.character(.x$ASV[1])),
        Final_Conf = map_dbl(winner_tibble, ~ as.numeric(.x$conf_numeric[1]))
    ) %>%
    # Clean up and keep your original columns + new calculated values
    dplyr::select(seq_id, iter = Final_iter, ASV = Final_ASV, Taxon = Final_Taxon, Confidence = Final_Conf)

    # View the result
    return(result)
}