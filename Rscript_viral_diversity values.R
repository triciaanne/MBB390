library("phyloseq")
library("ggplot2")

my_files <- list.files(pattern = "\\.csv$")
my_data <- lapply(my_files, read.csv)

names(my_data) <- gsub("\\.csv$", "", my_files)

otu_table_1 <- my_data$combined_otu_table1[my_data$combined_row_metadata$True.== "TRUE",]
metadata_1  <- my_data$combined_row_metadata[ my_data$combined_row_metadata$True.== "TRUE",]
taxo_1      <- my_data$NEW_combined_col_taxonomy1

#transpose data
otu_table_1 <- t(otu_table_1)
taxo_1 <- t(taxo_1)
metadata_1 <- t(metadata_1)

otu_table_1_matrix <- as.matrix(otu_table_1, rownames.force = NA)
taxo_1_matrix <- as.matrix(taxo_1)

colnames(otu_table_1_matrix) <- c("BOL", "MzA", "MzB")
rownames(taxo_1_matrix) <- rownames(otu_table_1_matrix)
colnames(taxo_1_matrix) <- c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")

OTU = otu_table(otu_table_1_matrix, taxa_are_rows = TRUE)
TAX = tax_table(taxo_1_matrix)

physeq = phyloseq(OTU, TAX)

#remove [a-z]__
tax_table(physeq)[, colnames(tax_table(physeq))] <- gsub(tax_table(physeq)[, colnames(tax_table(physeq))],     pattern = "[a-z]__", replacement = "")

#selects all viruses
viruses_physeq = subset_taxa(physeq, Domain == "Virus")

#plot richness
plot_richness(viruses_physeq, measures=c("Shannon", "Simpson"))

#gives the values of richness measures
estimate_richness(viruses_physeq, measures=c("Shannon", "Simpson"))
