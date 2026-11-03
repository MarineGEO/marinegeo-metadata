# See data.tree vignette https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html

# Reef Life Survey records two kinds of organism: fish (method 1, and cryptic
# fish on method 2) and mobile macroinvertebrates (method 2). The tree has one
# functional group for each, with the taxonomic categories nested underneath.

library(data.tree)
library(tidyverse)

taxa_df <- read_csv(list.files("taxonomy-and-functional-groups/taxonomic-lookup/", full.names = T))

source("R/taxonomic-lookup-updates/taxonomy_helpers.R")

taxa_tree <- get_taxonomic_tree(taxa_df)

# Build the tree
reef_life_survey <- Node$new("Reef Life Survey", scientific_id = "PROTOCOL:REEF_LIFE_SURVEY",
                             definition = "Organisms recorded on Reef Life Survey underwater visual census transects.")

# Fish
fish <- reef_life_survey$AddChild("Fish", scientific_id = "FUNCTIONAL:FISH", type = "primary",
                                  definition = "Bony, jawless, and cartilaginous fishes, counted in size classes on method 1 and as cryptic fish on method 2.")

fish_ids <- c("Chondrichthyes", "Osteichthyes") # "Agnatha", or jawless fish, are not yet included in our surveys

lapply(fish_ids, function(x){
  new_node <- Clone(FindNode(taxa_tree, x))
  fish$AddChildNode(new_node)
})

# Invertebrates
invertebrates <- reef_life_survey$AddChild("Invertebrates", scientific_id = "FUNCTIONAL:INVERTEBRATES", type = "primary",
                                           definition = "Macroinvertebrates, counted on method 2. Includes the invertebrate chordates (tunicates).")

invertebrate_ids <- c("Annelida", "Arthropoda", "Bryozoa", "Cnidaria", "Echinodermata",
                      "Entoprocta", "Mollusca", "Nematoda", "Nemertea", "Platyhelminthes",
                      "Porifera", "Tunicata")

lapply(invertebrate_ids, function(x){
  new_node <- Clone(FindNode(taxa_tree, x))
  invertebrates$AddChildNode(new_node)
})

reef_life_survey
print(reef_life_survey, "scientific_id")

# Verify enrollment:
# View(print(reef_life_survey, "scientific_id", "type", "rank", limit = NULL))

output_network_df <- ToDataFrameNetwork(reef_life_survey, "scientific_id", "type", "code", "rank", "definition", direction = "descend")

output_network_df %>%
  mutate(tree_name = "reef_life_survey") %>%
  write_csv("taxonomy-and-functional-groups/nested-labelsets/reef_life_survey.csv")
