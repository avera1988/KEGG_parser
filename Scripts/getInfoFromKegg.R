###########################################
# Program name: getInfoFromKegg.r
# Author: Leticia Vega Alvarado
# Last modification: 20/ago/2015
# Description: Este programa se encarga de hacer búsquedas en la base de datos de KEGG, en particular
#              obtiene el campo DEFINITION.
# Parametros: getInfoFromKegg<-function(fnInputFileName,fnOutputFileName,fnField)
#            fnInputFileName: archivo con los identificadores (K00820), un identificador por linea. El archivo debe contener el path de ubicacion
#            fnOutputFileName: nombre del archivo de donde se colocaran los resultados. El nombre debe incluir el path de ubicacion del archivo
# Dependencias: Bioconductor, KEGGREST
# Example: In R
#          source("/home/lety/bin/getInfoFromKegg.r")
#          getInfoFromKegg("/home/lety/bin/prueba.txt","/home/lety/bin/prueba_KeggRes.txt")
#
#          El archivo prueba.txt contiene:
#          K00820
#          K04527
#          K00106
#
#          El archivo prueba_KeggRes.txt contiene:
#          names	DEFINITION
#          K00820	glucosamine--fructose-6-phosphate aminotransferase (isomerizing) [EC:2.6.1.16]
#          K04527	insulin receptor [EC:2.7.10.1]
#          K00106	xanthine dehydrogenase/oxidase [EC:1.17.1.4 1.17.3.2]
#
###########################################
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("KEGGREST")

getInfoFromKegg<-function(fnInputFileName,fnOutputFileName)
{
   library("KEGGREST")
   fnObjectstoFind<-scan(fnInputFileName,what=character())
   fnResTable<-data.frame(matrix(NA, nrow=1, ncol=2))
   names(fnResTable)<-c("names","DEFINITION")
   for(i in fnObjectstoFind)
   {
      print(i)
      fnResTable<-(rbind(fnResTable,c(i,fnAnswer<-keggGet(i)[[1]]$DEFINITION)))
          
   }
   fnResTable<-fnResTable[-1,]
   write.table(fnResTable,file=fnOutputFileName, sep="\t",quote=FALSE,row.names=F)
}
