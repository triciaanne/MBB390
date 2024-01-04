library(igraph)
library(readr)
library(stringr)
library(readr)
library("gplots")

# GENERATE IGRAPH NETWORK FROM FASTSPAR P-VALUE MATRIX

pvals <- read_csv("pvalues.csv")
pvals.mat = pvals[,2:ncol(pvals)]

# set p-values of 0 to a non-zero, small p-value so we can take the logarithm
pvals.mat[pvals.mat == 0] = 0.000000001

# convert into significance
sig.mat = -1 * log10(pvals.mat)

# remove all edges with significance below 1
sig.mat[sig.mat<1] = 0
sig.mat = as.matrix(sig.mat)

# convert adjacency matrix into a graph
sparcc.graph = graph.adjacency(sig.mat,mode = "undirected")

# remove all nodes with no edges
Isolated = which(degree(sparcc.graph) == 0)
sparcc.graph = delete.vertices(sparcc.graph, Isolated)

sparcc.graph$weight <- sig.mat + 5

# display the graph
layout = layout.fruchterman.reingold
par(mar = c(5,5,5,5))

# set nodes as red if virus or gray if eukaryote
V(sparcc.graph)$color = ifelse(grepl("virus", V(sparcc.graph)$name), 
                               "red", "gray")
V(sparcc.graph)$label.cex = 5
V(sparcc.graph)$label.color = "black"

# set any edge connected to a virus node as pink 
edges = get.data.frame(sparcc.graph, what="edges")
E(sparcc.graph)$color = ifelse(grepl("virus", edges$from) | grepl("virus", edges$to),
                               "pink", "darkgray")

# set node size according to log of size
counts <- read_csv("counts.csv")
sizes = counts$sum[match(V(sparcc.graph)$name, counts$Family)]
sizes = log(sizes)*2

# output igraph as png
png(file = "network.png", height = 3000, width = 3000)
plot(sparcc.graph, rescale=TRUE, layout=layout, 
     directed = TRUE, vertex.size = sizes,
     label.dist=6, edge.width=10)
dev.off()

# GENERATE HEATMAP FROM FASTSPAR P-VALUE MATRIX

pvals <- read_csv("pvalues.csv")

# loop through the matrix
# remove columns and rows without any p-value less than 0.1
pvals[1] = NULL
toremove = c()
index = 1
for(row in pvals) {
  remove = TRUE
  for (column in row) {
    if(column <= 0.1)
      remove = FALSE
  }
  
  if(remove) {
    toremove = c(toremove, index)
  }
  
  index = index + 1
}

pvals <- pvals[-toremove,-toremove]
pvals = as.matrix(pvals)

# set gradient of color from p-values 0 to 0.1
# p-values greater than 0.1 are colored black

gradient = colorpanel(10, "red", "#520705")
col = c(gradient, "black")
breaks <- c(seq(0,0.1,length=11), 1)

# output heatmap as png
png(file = "0.1.png", height = 3000, width = 3500)
plot <- heatmap.2(pvals, dendrogram = "row",
                  scale = "none", col = col, breaks = breaks,
                  trace = "none", key=TRUE, symkey=FALSE, 
                  density.info="none", cexRow=6, cexCol=6,
                  labRow = colnames(pvals), margins=c(50,50),
                  keysize = 1, key.title = "p-value", key.xlab = NA,
                  lhei=c(0.17,2), lwid=c(0.7,2.5), key.par = list(cex=3))
dev.off()