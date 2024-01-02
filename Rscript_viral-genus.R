library(ggplot2)
library(scales)

# Load datasets and filter using some threshold
bol8_genus <- read.csv("BOL8_viral_genus.tsv", sep="\t", header=TRUE)
bol8_genus_passed <- bol8_genus[which(bol8_genus$membership_ratio >= 0.75 & bol8_genus$confidence_score >= 0.5), ]

mzA_genus <- read.csv("MzA_viral_genus.tsv", sep="\t", header=TRUE)
mzA_genus_passed <- mzA_genus[which(mzA_genus$membership_ratio >= 0.75 & mzA_genus$confidence_score >= 0.5), ]

mzB_genus <- read.csv("MzB_viral_genus.tsv", sep="\t", header=TRUE)
mzB_genus_passed <- mzB_genus[which(mzB_genus$membership_ratio >= 0.75 & mzB_genus$confidence_score >= 0.5), ]

# Combine into a single dataframe
comb_genus_passed <- rbind(
  data.frame(station = "BOL8", class_name = bol8_genus_passed$class_name),
  data.frame(station = "MzA", class_name = mzA_genus_passed$class_name),
  data.frame(station = "MzB", class_name = mzB_genus_passed$class_name)
)

# Calculate relative abundance
relative_abundance <- table(comb_genus_passed) / rowSums(table(comb_genus_passed))

# Convert to data frame
comb_genus_passed <- as.data.frame(relative_abundance)

# Filter genera with less than 1% relative abundance
comb_genus_passed <- comb_genus_passed[comb_genus_passed$Freq >= 0.01, ]

# Plot
barplot <- ggplot(comb_genus_passed, aes(x = station, fill = class_name, y = Freq)) +
  geom_bar(position = "stack", stat = "identity", color = "black", size = 0.2) +
  labs(
    y = "Relative Abundance",
    x = "Station"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major.x = element_blank(),  # Remove vertical gridlines
    panel.grid.minor.x = element_blank(),  # Remove minor vertical gridlines
    panel.border = element_blank()  # Remove panel border
  ) +
  geom_text(aes(label = percent(Freq)), position = position_stack(vjust = 0.5), size = 2.2) +
  guides(fill = guide_legend(title = "Genus"))  # Customize legend title

print(barplot)
