###########################################################################
# To catch the selected CEL files from GEO datasets using the known GSMID #
###########################################################################

source("http://bioconductor.org/biocLite.R")
biocLite("GEOquery")

#set the working directory 
setwd('/tmp')
CEL.dir <- '/tmp/CEL'

#read the clinical data and catch the GSMID of samples
Data <- read.csv('clinicaldata.csv')
attach(Data)
GSMID <- GSM.ID #catch the GSMID of the samples

library(GEOquery) #load the package into R

gsm.error.vec <- numeric(length(GSMID))
for(i in 1:length(GSMID)){
    print(i)
    gsm.id <- as.character(GSMID[i])
    df <- getGEOSuppFiles(gsm.id, makeDirectory = F, baseDir = CEL.dir)
    if(is.null(df)){
	gsm.error.vec[i] <- 1
    }
    setwd('/tmp')	
}
