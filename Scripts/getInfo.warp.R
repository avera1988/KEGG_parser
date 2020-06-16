#!/usr/bin/RScript


args <- commandArgs(TRUE)
inputFile <- args[1]
outputFile <- args[2]

source("getInfoFromKegg.R")
getInfoFromKegg(inputFile,outputFile)
