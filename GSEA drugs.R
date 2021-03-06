#Drug "Gene Set Enrichment Analysis" (GSEA)
###We adapted Gene Set Enrichment Analysis (GSEA) to enable enrichment analyses of "drug classes" based in their mechanism of action (MOA)
###We used the GSEA method implemented in the R package fgsea (33)
###This was done for all the three signatures, this is just a representative example

## Open libraries
library(fgsea)
library(data.table)
library(ggplot2)
library(readxl)

##Prepare Ranks file containing our compounds name and score
##This is an example, the excel file should have only the Compounds name and their score, we ordered it alphabetically by compounds name
data <- read_excel("Drugs 2.7.xlsx")
data <- setNames(data$Score, data$Compound)
str(data)

##Prepare Pathways file
###This is an example, the excel file should have only the Compounds name and their MOA, we ordered it alphabetically by compounds name
datap <- read_excel("Pathways.xlsx")
dflist <- split(datap$Compound, datap$MOA)

## GSEA analysis using fsgea, it performs a pre-ranked GSEA analysis
fgseaRes <- fgsea(pathways = dflist, 
                  stats    = data,
                  minSize  = 2,
                  maxSize  = 800)

## Plot Pathways generation
### Examples for top pathways
topPathwaysUp <- fgseaRes[fgseaRes$padj < 0.05,][NES > 0][head(order(NES), n=10), pathway]
topPathwaysDown <- fgseaRes[fgseaRes$padj < 0.05,][NES < 0][head(order(NES), n=10), pathway]
topPathways <- c(topPathwaysUp, rev(topPathwaysDown))
plotGseaTable(dflist[topPathways], data, fgseaRes, gseaParam=0.5)
plotGseaTable(dflist[topPathwaysUp], data, fgseaRes, gseaParam=0.5)
plotGseaTable(dflist[topPathwaysDown], data, fgseaRes, gseaParam=0.5)

##Plot Enrichment generation
### An example
plotEnrichment(dflist[["Glucocorticoid receptor agonist"]], data) + labs(title="Glucocorticoid receptor agonist")
