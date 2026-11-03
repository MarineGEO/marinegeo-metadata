library(data.tree)
library(tidyverse)

obs_df <- read_csv(list.files("taxonomy-and-functional-groups/observation-lookup/", full.names = T))
taxa_df <- read_csv(list.files("taxonomy-and-functional-groups/taxonomic-lookup/", full.names = T))

source("R/taxonomic-lookup-updates/taxonomy_helpers.R")

classifications_df <- get_wide_form_taxonomy(taxa_df)

taxa_tree <- get_taxonomic_tree(taxa_df)
print(taxa_tree, "scientific_id", "rank")
taxa_tree_df <- ToDataFrameNetwork(taxa_tree, "scientific_id", "rank", direction = "descend")

