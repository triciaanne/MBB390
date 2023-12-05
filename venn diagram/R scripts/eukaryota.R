library(VennDiagram)
data2 <- read.csv("eukaryota.csv")

g <- list(data2$BOL) 
h <- list(data2$MzA) 
i <- list(data2$MzB)

## remove NA values from lists
j <- lapply(g, function(z){ z[!is.na(z) & z != ""]})
k <- lapply(h, function(z){ z[!is.na(z) & z != ""]})
l <- lapply(i, function(z){ z[!is.na(z) & z != ""]})

##print each list then copy paste to a vector
#print(j/k/l)

## vectors
set4 <- c("Trebouxiophyceae","Cymatosiraceae","Kareniaceae","Mamiellaceae","Picozoa","Protaspidae",
          "Picomonadida","Mediophyceae","Chrysochromulinaceae","Chroomonadaceae","Syndiniales_Group_I",
          "Thaumatomonadida","Syndiniales_Group_II","Syndiniales","Gymnodiniphycidae","Prymnesiales",
          "MAST-7B","Rhizosolenids","Prymnesiophyceae","MAST-4","Syndiniales_Group_III",
          "Thecofilosea","Chlorarachniaceae","Gymnodinium_clade","Chlorarachniophyta",
          "Bacillariophyceae","Thraustochytriaceae","Prymnesiaceae","MAST-11","Capsasporidae",
          "Picomonadidae","Centrohelida","Ceratiaceae","Nephroselmidales","Marimonadida",
          "MAST-7D","Pycnococcaceae","Thoracosphaeraceae","MAST-1D","Prasinococcaceae","MAST-4D",
          "Novel_Clade_2","MAST-7","MAST-1B","Codosigidae","MAST-2","Stephanoecidae","Pavlovophyceae",
          "Salpingoecidae","Dolichomastigaceae","MAST-8","Pinguiochrysidales","Eustigmatales",
          "Pav3","MAST-9","MOCH-2","MAST-9A","Holostichidae","T58","Dictyochophyceae","ANT37-16",
          "Ebriacea")

set5 <- c("Trebouxiophyceae","Bathycoccaceae","Cymatosiraceae","Kareniaceae","Mamiellaceae",
          "Geminigeraceae","Picozoa","Protaspidae","Picomonadida","Mediophyceae","Chrysochromulinaceae",
          "Dinophyceae","Chroomonadaceae","Syndiniales_Group_I","Thaumatomonadida","Syndiniales_Group_II",
          "Kathablepharidaceae","Syndiniales","Gymnodiniphycidae","Tintinnina_Codonellopsidae",
          "Prymnesiales","MAST-7B","Rhizosolenids","Prymnesiophyceae","Peridiniales","MAST-4",
          "Protosporangiidae","Syndiniales_Group_III","Thecofilosea","Chlorarachniaceae","Gymnodinium_clade",
          "Chlorarachniophyta","Spumellaria","Chlorodendrales","Bacillariophyceae","Sphaeropleales",
          "Polykrikaceae","Strombidiidae","Eumetazoa_Ctenophora","Thraustochytriaceae","Tontoniidae",
          "Prasinophycae","Porifera","Chattonellales","Prymnesiaceae","MAST-11","Mesodiniidae",
          "Capsasporidae","Picomonadidae","Gonyaulacales","Raphidophyceae","Centrohelida",
          "Telonemida","Eumetazoa_Cnidaria","Ceratiaceae","Nephroselmidales","Marimonadida",
          "MAST-7D","Suessiaceae","Bolidophyceae","Pycnococcaceae","Amphidiniaceae","Thoracosphaeraceae",
          "Gymnodiniaceae","MAST-1D","MAST-10","Prasinococcaceae","MAST-4D","Apusomonadidae",
          "Dothideomycetes","Novel_Clade_2","MAST-7","Eurotiomycetes","MAST-1B","Codosigidae",
          "MAST-2","Didiniidae","Phytomyxea","MAST-1C","Strobilidiidae","Acanthocystidae",
          "Uronematidae","Stramenopiles","Sarcinochrysidales","Stephanoecidae","Pavlovophyceae",
          "Tintinnina_Tintinnidae","Eumetazoa_Tunicata","Eumetazoa_Mollusca","Eumetazoa_Copepoda",
          "Chytridiomycetes","Abeoformidae","Salpingoecidae","Cryptomonadales","Acantharia",
          "Basal_Group_T","Dolichomastigaceae","Rozella","Ceriantharia","RAD_A","Rhynchonellida",
          "Saprolegniales","Ventrifissuridae","Haptophyta","Chromerida","Leptothecata","Novel_Clade_3",
          "MAST-8","Oligotrichia","Strombidinopsidae","Metromonadea","Porphyridiaceae","Ephelotidae",
          "Paraphysomonadaceae","Labyrinthulomycetes","Pyrenomonadaceae","Haplosclerida","Eumetazoa_Mammalia")

set6 <- c("Trebouxiophyceae","Bathycoccaceae","Cymatosiraceae","Kareniaceae","Mamiellaceae",
          "Geminigeraceae","Picozoa","Protaspidae","Picomonadida","Mediophyceae","Chrysochromulinaceae",
          "Dinophyceae","Chroomonadaceae","Syndiniales_Group_I","Thaumatomonadida","Syndiniales_Group_II",
          "Kathablepharidaceae","Syndiniales","Gymnodiniphycidae","Tintinnina_Codonellopsidae",
          "Prymnesiales","MAST-7B","Rhizosolenids","Prymnesiophyceae","Peridiniales","MAST-4",
          "Protosporangiidae","Syndiniales_Group_III","Thecofilosea","Chlorarachniaceae","Gymnodinium_clade",
          "Chlorarachniophyta","Spumellaria","Chlorodendrales","Bacillariophyceae","Sphaeropleales",
          "Polykrikaceae","Strombidiidae","Eumetazoa_Ctenophora","Thraustochytriaceae","Tontoniidae",
          "Prasinophycae","Porifera","Chattonellales","Prymnesiaceae","MAST-11","Mesodiniidae",
          "Capsasporidae","Picomonadidae","Gonyaulacales","Raphidophyceae","Centrohelida","Telonemida",
          "Eumetazoa_Cnidaria","Ceratiaceae","Nephroselmidales","Marimonadida","MAST-7D","Suessiaceae",
          "Bolidophyceae","Pycnococcaceae","Amphidiniaceae","Thoracosphaeraceae","Gymnodiniaceae",
          "MAST-1D","MAST-10","Prasinococcaceae","MAST-4D","Apusomonadidae","Dothideomycetes",
          "Novel_Clade_2","MAST-7","Eurotiomycetes","Codosigidae","MAST-2","Phytomyxea","MAST-1C",
          "Strobilidiidae","Stramenopiles","Sarcinochrysidales","Stephanoecidae","Pavlovophyceae",
          "Tintinnina_Tintinnidae","Eumetazoa_Tunicata","Eumetazoa_Mollusca","Eumetazoa_Copepoda",
          "Chytridiomycetes","Abeoformidae","Salpingoecidae","Cryptomonadales","Acantharia",
          "Basal_Group_T","Dolichomastigaceae","Rozella","Ceriantharia","RAD_A","Rhynchonellida",
          "Saprolegniales","Ventrifissuridae","Haptophyta","Chromerida","Leptothecata","Novel_Clade_3",
          "MAST-8","Strombidinopsidae","Ephelotidae","Paraphysomonadaceae","Labyrinthulomycetes",
          "Haplosclerida","Eumetazoa_Mammalia","Vampyrellidae","Lingulodiniaceae","Fragilariales",
          "Pyrophacaceae","Dinoflagellata","Plagiorchiida","Gonyaulacaceae","Tintinnina_Codonellidae",
          "Schizymeniaceae","Coscinodiscophytina","RAD_B","Anthoathecata","Eimeriorina",
          "Dactylopodida","Sordariomycetes","DSGM-81")

v2 <- venn.diagram(list(BOL=set4, MzA=set5, MzB=set6), fill = c("pink","green","purple"), alpha = c(0.5, 0.5, 0.5), filename=NULL)
jpeg("eukaryota.png")

grid.newpage()
grid.draw(v2)
dev.off()

## list overlap
overlap2 <- intersect(set4, set5)
overlap2
cat(paste0(overlap2, collapse = "\n"))

