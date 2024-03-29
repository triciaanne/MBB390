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

#displays all hosts with label to the genus level
physeq = subset_taxa(physeq, Genus != "")
eukaryotes_physeq = subset_taxa(physeq, Domain == "Eukaryota")

#displays top ~ host genera only
top <- names(sort(taxa_sums(eukaryotes_physeq), decreasing=TRUE))[1:17] #toggle with the upper limit
eukaryotes_physeq_top <- transform_sample_counts(eukaryotes_physeq, function(OTU) OTU/sum(OTU))
eukaryotes_physeq_top <- prune_taxa(top, eukaryotes_physeq_top)

#gives relative abundance of hosts according to genus
eukaryotes_physeq_top_norm = transform_sample_counts(eukaryotes_physeq_top, function(x) x / sum(x) )
p <- plot_bar(eukaryotes_physeq_top_norm, fill="Genus")
p + geom_bar(aes(fill=Genus), stat="identity", position="fill") +
  scale_fill_manual(values=MyPalette) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45),
    panel.grid.major.x = element_blank(),  # Remove vertical gridlines
    panel.grid.minor.x = element_blank(),  # Remove minor vertical gridlines
    panel.border = element_blank()  # Remove panel border
  )


#obtain values of abundances
data <-
  eukaryotes_physeq_top %>%
  tax_glom("Genus") %>%
  transform_sample_counts(function(x)100* x / sum(x)) %>%
  psmelt() %>%
  as_tibble()

print(data %>%
        group_by(Sample, Genus) %>%
        summarise(Abundance = mean(Abundance)) %>%
        arrange(-Abundance),
      n=36)
