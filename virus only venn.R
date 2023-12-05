library(VennDiagram)
data <- read.csv("VENN_VIRUS ONLY_combined-families.csv")

a <- list(data$BOL) 
b <- list(data$MzA) 
c <- list(data$MzB)

## remove NA values from lists
d <- lapply(a, function(z){ z[!is.na(z) & z != ""]})
e <- lapply(b, function(z){ z[!is.na(z) & z != ""]})
f <- lapply(c, function(z){ z[!is.na(z) & z != ""]})

##print each list then copy paste to a vector
#print(d)

## vectors
set1 <- c("T4virus","P12002virus","Lambdavirus","P70virus","Slashvirus","P12024virus","M12virus",
          "Vp5virus","Rsl2virus","Cba41virus","Bpp1virus","Vi1virus","P22virus","Luz24virus",
          "Prtbvirus","Xp10virus","Nit1virus","Hp1virus","Phic31virus")

set2 <- c("T4virus","P12002virus","Prasinovirus","Lambdavirus","Bxz1virus","P70virus","Slashvirus",
          "P12024virus","M12virus","Vp5virus","Rsl2virus","Cba41virus","Bpp1virus","Vi1virus",
          "Prymnesiovirus","Phicbkvirus","P22virus","Luz24virus")

set3 <- c("T4virus","P12002virus","Prasinovirus","Lambdavirus","Bxz1virus","P70virus",
          "Slashvirus","P12024virus","M12virus","Vp5virus","Cba41virus","Bpp1virus",
          "Phicbkvirus","Kp36virus")

v <- venn.diagram(list(BOL=set1, MzA=set2, MzB=set3), fill = c("red","blue","yellow"), alpha = c(0.5, 0.5, 0.5), filename=NULL)
jpeg("VirusonlyVenn20231201_1.png")

grid.newpage()
grid.draw(v)
dev.off()

## list overlap
overlap <- intersect(set1, set2)
overlap
cat(paste0(overlap, collapse = "\n"))


