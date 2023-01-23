rm(list=ls())
library(tidyverse)
library(dplyr)
library(plyr)
library(ggplot2)
library(coda)
library(gridExtra)
library(reshape2)
library(ggpubr)
library(wesanderson)

nReps = 30
scenarios = c("PS","PedigreeBlup_Seed", 
              "Seed_GSconst_pheno_noECT",
              "Seed_GSunconst_pheno_noECT",
              "ECT_GS")
title = "100% parents replaced" # plot title

# Check if any files missing
temp <- paste(rep(scenarios,each = nReps),"_", rep(1:nReps, times = length(scenarios)), ".rds",sep = "")
temp[!file.exists(temp)]

# Read in output data
rawData = vector("list",nReps*length(scenarios))
i = 0L
for(SCENARIO in scenarios){
  for(REP in 1:nReps){
    i = i+1L
    FILE = paste0(SCENARIO,"_",REP,".rds")
    temp = readRDS(FILE)
    
    # Reset year to years since burn-in
    temp$year = temp$year-40
    temp$scenario = SCENARIO
    rawData[[i]] = temp
    
  }
}
rawData = bind_rows(rawData)

# Replace Scenario names with prettier names
rawData$Scenario = rawData$scenario
rawData$scenario = sub("^PS$","PS",rawData$scenario)
rawData$scenario = sub("^PedigreeBlup_Seed$","Seed-Ped",rawData$scenario)
rawData$scenario = sub("^Seed_GSconst_pheno_noECT$","Seed-GSc",rawData$scenario)
rawData$scenario = sub("^Seed_GSunconst_pheno_noECT$","Seed-GSunc",rawData$scenario)
rawData$scenario = sub("^ECT_GS$","ECT-GS",rawData$scenario)

# Re-order the scenarios for the legend
rawData$scenario <- factor(rawData$scenario, 
                           levels=c("PS", 
                                    "Seed-Ped",
                                    "Seed-GSc",
                                    "Seed-GSunc",
                                    "ECT-GS"))
levels(as.factor(rawData$scenario))

# Specify theme options
optns <- theme_bw(base_size = 16, base_family = "sans") +
  theme(panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = "none",
        plot.title = element_text(size = 18, face = "bold"),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 15,colour = "black"),
        axis.title = element_text(size = 16),
        strip.text = element_text(face = "bold", size = 20, colour = 'blue'))

# Create directory to save graphics
path = paste0(getwd(),"/PlotProgress_finalPlots")
dir.create(path = path,mode = "777")

####################################################################
# Genetic progress parameters
####################################################################

####################################################################
# Genetic gain - Seedling Stage
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(meanSeed),
             se = sd(meanSeed)/sqrt(length(nReps)))

a <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # geom_ribbon(aes(x=year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0)+
  # ggtitle("Genetic Gain") +
  # ggtitle(title) +
  scale_x_continuous("Year") +
  # scale_y_continuous("Genetic Gain",limits=c(0,20)) +
  scale_y_continuous("Genetic mean",limits = c(4000,10500)) +
  optns +
  theme(panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.2,0.8))
        # legend.position = c(0.28,0.76)) 
ggsave(filename = paste("PlotProgress_finalPlots/Gain_Seed.png"), plot = a, width = 5, height = 5, scale = 1.1)

####################################################################
# Genetic gain - ECT stage
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(meanECT),
             se = sd(meanECT)/sqrt(length(nReps)))

a2 <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # geom_ribbon(aes(x=year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0)+
  # ggtitle("Genetic Gain") +
  # ggtitle(title) +
  scale_x_continuous("Year") +
  # scale_y_continuous("Genetic Gain",limits=c(0,20)) +
  scale_y_continuous("Genetic mean") +
  optns +
  theme(panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.2,0.8))
        # legend.position = c(0.28,0.76)) 
ggsave(filename = paste("PlotProgress_finalPlots/Gain_ECT.png"), plot = a2, width = 5, height = 5, scale = 1.1)

####################################################################
# Genetic variance 
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(varSeed),
             se = sd(varSeed)/sqrt(length(nReps)))

b <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # geom_ribbon(aes(x=year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0)+
  # ggtitle("Genetic Gain") +
  # ggtitle(title) +
  scale_x_continuous("Year") +
  scale_y_continuous("Genetic variance",limits=c(0,140000)) +
  optns +
  theme(panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.75,0.8))
ggsave(filename = paste("PlotProgress_finalPlots/Variance.png"), plot = b, width = 5, height = 5, scale = 1.1)

b1 <- ggplot(rawData[rawData$year == 40,], aes(x=scenario, y=varSeed,color=scenario)) +
  geom_boxplot() +
  stat_summary(fun ="mean", color="gray", shape=1) +
  # geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4) +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  # geom_hline(yintercept = mean(rawData$meanSeed[rawData$year == 40 & rawData$scenario == "PS"]), linetype = 2)+
  geom_hline(yintercept = mean(rawData$meanSeed[rawData$year == 40 & rawData$scenario == "Seed-GSc"]), linetype = 2) +
  # geom_text(x=0.5, y=115000, label="Scatter plot") +
  # stat_compare_means(ref.group = "PS", label = "p.format",label.y = c(83500)) +
  # stat_compare_means(ref.group = "Seed-GSconst", label = "p.format",label.y = c(10000)) +
  scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # ggtitle(title) +
  scale_y_continuous("Genetic variance") +
  scale_x_discrete("Program") +
  optns +
  theme(axis.text.x = element_text(angle = 25, vjust = 1, hjust=1))
ggsave(filename = paste("PlotProgress_finalPlots/Variance_boxplot.png"), plot = b1, width = 6, height = 5, scale = 1.1)

####################################################################
# Selection accuracy  - Seedlings stage
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(accSeed),
             se = sd(accSeed)/sqrt(length(nReps)))

c <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # geom_ribbon(aes(x=year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0)+
  # ggtitle("Genetic Gain") +
  # ggtitle(title) +
  scale_x_continuous("Year") +
  # scale_y_continuous("Genetic Gain",limits=c(0,20)) +
  scale_y_continuous("Selection accuracy",limits=c(0,1)) +
  optns +
  theme(panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.8,0.8))
        # legend.position = c(0.28,0.76)) 
ggsave(filename = paste("PlotProgress_finalPlots/Accuracy_Seed.png"), plot = c, width = 5, height = 5, scale = 1.1)

####################################################################
# Selection accuracy - ACT stage
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(accACT),
             se = sd(accACT)/sqrt(length(nReps)))

c1 <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # geom_ribbon(aes(x=year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0)+
  # ggtitle("Genetic Gain") +
  # ggtitle(title) +
  scale_x_continuous("Year") +
  # scale_y_continuous("Genetic Gain",limits=c(0,20)) +
  scale_y_continuous("Selection accuracy",limits=c(0,1)) +
  optns +
  theme(panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.8,0.8))
        # legend.position = c(0.28,0.76)) 
ggsave(filename = paste("PlotProgress_finalPlots/Accuracy_ACT.png"), plot = c1, width = 5, height = 5, scale = 1.1)

summary100 <- ggarrange(a,b,c, nrow = 1, ncol=3, common.legend = TRUE, legend="bottom")
print(summary100 <- annotate_figure(summary100, top = text_grob(title, color = "black", face = "bold", size = 14)))
ggsave(filename = paste("PlotProgress_finalPlots/Summary.png"), plot = summary100, width = 12, height = 4, scale = 1.1)
save.image("PlotProgress_finalPlots/Data100.RData")
