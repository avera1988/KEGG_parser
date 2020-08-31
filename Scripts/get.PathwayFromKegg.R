#!/usr/bin/Rscript
############################################
# This script return All metabolic pathway annotation associated to KO ids after
# BlastKoala Annotation by KEGG
# Author Arturo Vera
# quark.vera@gmail.com
# April 2020
###############################################
#Install Dependencies

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

if(!require("KEGGREST")){
	BiocManager::install("KEGGREST")
	library(KEGGREST)
}

if (!require("tidyverse")){
        install.packages("tidyverse")
	library(tidyverse)
}
if(!require("openxlsx")){
	install.packages("openxlsx")
	library(openxlsx)
} 
##Reading data
args <- commandArgs(TRUE)
input.user.KO <- args[1]
input.Annot <- args[2]
outputFile <- args[3]
##Manin script

#Reading Table from KEGG Koala
rawTable <- read.delim(input.user.KO,header = F,sep="\t")
colnames(rawTable) <- c("GeneID","KO")

#Reading annotation Table obtined by get.infoFRom Kegg script
AnnotTable <- read.delim(input.Annot,header=T,sep="\t")

AnnotTable <- AnnotTable %>%
  dplyr::rename(KO="names") %>%
  distinct()

#Parsing gene id with KO annotation
KOTable <- rawTable %>%
  filter(grepl("K",KO))

rawTableAnnot <- dplyr::inner_join(KOTable,AnnotTable,by="KO")

TableB <- rawTableAnnot %>%
  filter(grepl("K",KO)) %>%
  filter(!grepl("uncharacterized",DEFINITION))

totalKO <- as.vector(TableB$KO)

#KEGGRest function to obtain the Pathways
jTotal <- lapply(totalKO,function(x){
  cabeckeg <- keggGet(x)
  cabeDF <- data.frame(c(cabeckeg[[1]]$ENTRY,
                         cabeckeg[[1]]$PATHWAY))
  colnames(cabeDF) <- "Pathway" 
  cabeDF$KO <- cabeDF[1,]
  return(cabeDF)
})
#Reducing table into a Dataframe
BindTotal <- reduce(jTotal,rbind) %>%
  mutate(ROWS=row.names(.)) %>%
  filter(!grepl("KO",ROWS)) %>%
  select(matches("KO|Path"))
#Join Pathways and Annotaion values (i.e. DEFFINITION)
TotalKegg <- right_join(BindTotal,rawTableAnnot,by="KO") %>%
  arrange(Pathway)

#Saving objects into tab and excel files
write.table(TotalKegg,paste0(outputFile,".tab"),sep="\t",row.names = F,quote=F)
openxlsx::write.xlsx(TotalKegg,file=paste0(outputFile,".xlsx"))

