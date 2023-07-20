###########################################
# Program name: getInfoFromKegg.r
# Author: Leticia Vega Alvarado
# Created: 09/20/2015
# Last modification: 06/15/2020 by Arturo Vera
# This software annotate a series of KO values wiht the Description in KEGG database
###########################################
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

if(!require("KEGGREST")){
	BiocManager::install("KEGGREST")
	library(KEGGREST)
} 

getInfoFromKegg<-function(fnInputFileName,fnOutputFileName)
{
   library("KEGGREST")
   fnObjectstoFind<-scan(fnInputFileName,what=character())
   fnResTable<-data.frame(matrix(NA, nrow=1, ncol=2))
   names(fnResTable)<-c("names","DEFINITION")
   for(i in fnObjectstoFind)
   {
      print(i)
      fnResTable<-(rbind(fnResTable,c(i,fnAnswer<-keggGet(i)[[1]]$NAME)))
          
   }
   fnResTable<-fnResTable[-1,]
   write.table(fnResTable,file=fnOutputFileName, sep="\t",quote=FALSE,row.names=F)
}
