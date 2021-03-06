#!/usr/bin/bash
#######################################################################
#Script to obtain KEGG annotations and Pathways#
#"Usage:bash getinfo.sh path_to_KEGG_parser_Scripts"
#Author Aruro Vera
# 06/15/2020
#######################################################################

print_usage(){
	echo "Usage: $0 path_to_KEGG_pasrser_scripts"
}

if [ $# -le 0 ]
then
	print_usage
	exit 1
fi


scripts=$1
cp $scripts/*.R .

#Obtain Tables with KO and Gene_ID remove all not KO annotations

for i in *ko.txt;
	do
	cat $i|awk '{if($2 ~ /^K/) print $2}' > $i.to.keggrest;
	cat $i|awk '{if($2 ~ /^K/) print }' > $i.mod;
done

#Apply getInfo.R script

echo "Obtain KEGG annotations by KEGGREST"

for i in *.keggrest;
	do
	Rscript getInfo.warp.R $i $i.annot
done

#Obtain Pathway

echo "Obtain KEGG Pathways by KEGGREST"

for i in *.mod
	do
	name=$(basename $i .mod)
	Rscript get.PathwayFromKegg.R $i $name.to.keggrest.annot $name.Pathway
done

rm *.R
