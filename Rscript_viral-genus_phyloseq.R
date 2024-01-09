library("phyloseq")
library("ggplot2")
library("dplyr")

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

MyPalette <- c("#5DD0B9", "#E1E7E9", "#1f78b4", "#a6cee3",
               "#de77ae", "#c51b7d", "#8e0152", "#6a3d9a",
               "#fbdf6f", "#ff7f00", "#fff999", "#0928f4",
               "#dc2f10", "#476e66", "#694dfe", "#e5b1f9",
               "#359387")

#displays all viruses
viruses_physeq = subset_taxa(physeq, Domain == "Virus", Genus != "")



#displays top ~ viral OTUs only
top <- names(sort(taxa_sums(viruses_physeq), decreasing=TRUE))[1:40]
viruses_physeq_top <- transform_sample_counts(viruses_physeq, function(OTU) OTU/sum(OTU))
viruses_physeq_top <- prune_taxa(top, viruses_physeq_top)

#gives relative abundance of viruses according to genus
viruses_physeq_top_norm = transform_sample_counts(viruses_physeq_top, function(x) x / sum(x) )
p <- plot_bar(viruses_physeq_top_norm, fill="Genus")
p + geom_bar(aes(fill=Genus), stat="identity", position="fill") + scale_fill_manual(values=MyPalette)

#obtain values of abundances
data <-
  viruses_physeq_top %>%
  tax_glom("Genus") %>%
  transform_sample_counts(function(x)100* x / sum(x)) %>%
  psmelt() %>%
  as_tibble()

print(data %>%
  group_by(Sample, Genus) %>%
  summarise(Abundance = mean(Abundance)) %>%
  arrange(-Abundance),
  n=51)

