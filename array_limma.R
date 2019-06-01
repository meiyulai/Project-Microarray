###########################################
# normalize raw data to expression values #
###########################################

source("https://bioconductor.org/biocLite.R")
biocLite("affy")

library(affy)
setwd('/CEL') #set the working directory

# Customized method
affy.data <- ReadAffy()
normalize.opt <- expresso(affy.data, bgcorrect.method = "mas", normalize.method = "quantiles", pmcorrect.method = "pmonly", summary.method = "medianpolish")
exprs.opt <- exprs(normalize.opt)
#write.csv(exprs.opt, 'OptNorm.csv') #export the normalized data as a csv file to the working directory

# RMA method
norm.RMA <- justRMA()
exprs.rma <- exprs(norm.RMA)
#write.csv(exprs.rma, 'RMANorm.csv')

########################################################
# Linear Models for Microarray Data (limma)            #
# Detect gene expression difference with linear models #
########################################################

#source("http://bioconductor.org/biocLite.R")
#biocLite("limma")

library(limma)
clinicdata <- read.csv('clinicaldata.csv')
exprsdata <- read.csv('OptNorm.csv')
exprsData <- exprsData[, -1] #delete the first column
attach(clinic698)

#only use the samples with ER+/treated/high BRCA1-level
Data <- exprsData[, which(ER == 1 & Treatment == 1 & BRCA1_80 == 1)] 

#grouped the selected samples to metastasis or non-metastasis
group <- ifelse(ER == 1 & Treatment == 1 & BRCA1_80 == 1 & Event == 1, 1, 0)
group <- group[which(ER == 1 & Treatment == 1 & BRCA1_80 ==  1)]
design <- model.matrix(~ factor(group)) #create a linear model
fit <- lmFit(Data, design) #fit the linear model
fit <- eBayes(fit) #empirical bayesian estimation

#list top 50 significantly different expressions 
topTable(fit, coef = 2, adjust = 'BH', number = 50) 
#'adjust' is for adjusting p-value method
#'coef' is for specifying the variable we want to make contrast


