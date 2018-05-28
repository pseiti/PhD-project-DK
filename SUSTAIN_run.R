# SUSTAIN (as described in Love, Medin & Gureckis, 2004; https://pdfs.semanticscholar.org/eed8/bc21cec42d1adb45a1a8f00db7b60aed6137.pdf)

rm(list=ls())
setwd("~/Dropbox/Projekte/CEITER/PhD_Õnne/Exp1/Analysis")
# setwd("~/Dropbox/R/SUSTAIN")

## VARIABLES' meaning
# I ... stimulus vector
# pos ... position of stimulus in the multidimensional representational space
# i ... ith stimulus dimension
# k ... kth feature on dimension i
# j ... cluster index 
# H_j_act ... activation of jth cluster H
# H_j_out ... output of jth cluster after lateral competition 
# m ... number of stimulus dimensions
# V ... vector representing each number vi of features per stimulus dimension i
# lambda_i ... tuning of the receptive field for the ith input dimension
# z ... queried stimulus dimension
# C_out_zk ... output of the output unit representing the kth value of z

## PARAMETERS' meaning
# r ... attentional parameter (accentuates the effect of the lambda vector)
# beta ... cluster competition
# eta ... learning rate
# d ... response parameter ("When d is high, accuracy is stressed and the output unit with the largest output is almost always chosen", p. 315)

## FUNCTIONS
source("SUSTAIN_fx.R")

## parameter setting
r <- 2.844642
beta <- 2.386305
d <- 12
eta <- 0.09361126
par <- c(r,beta,d,eta)
names(par) <- c("r","beta","d","eta")

## stimulus properties
labelQuery <- TRUE
m <- 4
V <- c(2,2,2,2)
shepard_structure_I <- list(c(1,1,1,1),c(1,1,2,1),c(1,2,1,1),c(1,2,2,1),c(2,1,1,2),c(2,1,2,2),c(2,2,1,2),c(2,2,2,2))
stimulus_structure <- shepard_structure_I
structure_name <- "Type1"
feature_coding <- c(0,1)

## Srun settings
ResponseSet <- c("A","B")
nAgents <- 50
agents <- paste("A",c(1:nAgents),sep="")
termCrit <- 4
nBlocks <- 32

run <- sapply(agents, agent_fx, par=par, nBlocks=nBlocks, termCrit=termCrit,
				labelQuery=labelQuery, ResponseSet=ResponseSet,
					structure_name=structure_name, stimulus_structure=stimulus_structure, m=m, V=V, feature_coding=feature_coding)

## simulation analysis
errorProb_perAgentAndBlock <- run["probOfError_block",]
errorProb_perAgentAndBlock <- lapply(errorProb_perAgentAndBlock,function(x){c(x,rep(NA,(nBlocks -length(x))))})
errorProb_perAgentAndBlock <- as.data.frame(errorProb_perAgentAndBlock)
rownames(errorProb_perAgentAndBlock) <- paste("Block",c(1:nrow(errorProb_perAgentAndBlock)),sep="")
averageErrorProb_perBlock <- rowMeans(errorProb_perAgentAndBlock,na.rm=T)

plot(averageErrorProb_perBlock~c(1:nBlocks),ylim=c(0,0.54),xlab="Learning Block",ylab="Probability of Error")



