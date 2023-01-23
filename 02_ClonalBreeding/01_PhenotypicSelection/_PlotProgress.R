rm(list=ls())
library(tidyverse)
library(dplyr)
library(plyr)
library(ggplot2)
library(coda)
library(gridExtra)
library(reshape2)
library(ggpubr)

nReps = 28
# scenarios = c("PS", "PedigreeBlup", "Seed_GSconst_6y", "Seed_GSunconst_6y", "ECT_GS")
# scenarios = c("PS", "PedigreeBlup", "Seed_GSconst", "Seed_GSconst_test","Seed_GSconst_pheno", "Seed_GSconst_noECT", "Seed_GSconst_6y", "Seed_GSunconst_6y", "ECT_GS")
# scenarios = c("PS", "PedigreeBlup","PedigreeBlup_Seed", 
#               "Seed_GSconst", "Seed_GSconst_pheno", "Seed_GSconst_noECT", "Seed_GSconst_pheno_noECT", "Seed_GSconst_6y",
#               "Seed_GSunconst", "Seed_GSunconst_pheno", "Seed_GSunconst_noECT", "Seed_GSunconst_pheno_noECT", "Seed_GSunconst_6y",
#               "ECT_GS")
scenarios = c("PS", "PedigreeBlup","PedigreeBlup_Seed", 
              "Seed_GSconst", "Seed_GSconst_pheno", "Seed_GSconst_noECT", "Seed_GSconst_pheno_noECT", "Seed_GSconst_6y",
              "Seed_GSunconst", "Seed_GSunconst_pheno", "Seed_GSunconst_noECT", "Seed_GSunconst_pheno_noECT", "Seed_GSunconst_6y",
              "ECT_GS","ECT_GS_pheno")

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
rawData$scenario = sub("^PedigreeBlup$","Pedigree",rawData$scenario)
rawData$scenario = sub("^PedigreeBlup_Seed$","Pedigree-Seed",rawData$scenario)
rawData$scenario = sub("^Seed_GSconst$","Seed-GSconst",rawData$scenario)
rawData$scenario = sub("^Seed_GSconst_noECT$","Seed-GSconst-noECT",rawData$scenario)
rawData$scenario = sub("^Seed_GSconst_pheno_noECT$","Seed-GSconst-pheno-noECT",rawData$scenario)
rawData$scenario = sub("^Seed_GSconst_6y$","Seed-GSconst-6y",rawData$scenario)
rawData$scenario = sub("^Seed_GSconst_pheno$","Seed-GSconst-pheno",rawData$scenario)
rawData$scenario = sub("^Seed_GSunconst$","Seed-GSunconst",rawData$scenario)
rawData$scenario = sub("^Seed_GSunconst_noECT$","Seed-GSunconst-noECT",rawData$scenario)
rawData$scenario = sub("^Seed_GSunconst_pheno_noECT$","Seed-GSunconst-pheno-noECT",rawData$scenario)
rawData$scenario = sub("^Seed_GSunconst_6y$","Seed-GSunconst-6y",rawData$scenario)
rawData$scenario = sub("^Seed_GSunconst_pheno$","Seed-GSunconst-pheno",rawData$scenario)
rawData$scenario = sub("^ECT_GS$","ECT-GS",rawData$scenario)
rawData$scenario = sub("^ECT_GS_pheno$","ECT-GS-pheno",rawData$scenario)

# Re-order the scenarios for the legend
# rawData$scenario <- factor(rawData$scenario, 
#                            levels=c("PS", "Pedigree", "Seed-GSconst-6y", "Seed-GSunconst-6y","ECT-GS"))
rawData$scenario <- factor(rawData$scenario, 
                           levels=c("PS", "Pedigree", "Pedigree-Seed",
                                    "Seed-GSconst","Seed-GSconst-pheno","Seed-GSconst-noECT","Seed-GSconst-pheno-noECT","Seed-GSconst-6y",
                                    "Seed-GSunconst","Seed-GSunconst-pheno","Seed-GSunconst-noECT","Seed-GSunconst-pheno-noECT","Seed-GSunconst-6y",
                                    "ECT-GS-pheno","ECT-GS"))
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
path = paste0(getwd(),"/PlotProgress")
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
  # scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
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
ggsave(filename = paste("PlotProgress/Gain_Seed.png"), plot = a, width = 5, height = 5, scale = 1.1)

a1 <- ggplot(rawData[rawData$year == 40,], aes(x=scenario, y=meanSeed,color=scenario)) +
  geom_boxplot() +
  stat_summary(fun ="mean", color="gray", shape=1) +
  # geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4) +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  # geom_hline(yintercept = mean(rawData$meanSeed[rawData$year == 40 & rawData$scenario == "PS"]), linetype = 2)+
  geom_hline(yintercept = mean(rawData$meanSeed[rawData$year == 40 & rawData$scenario == "Seed-GSc"]), linetype = 2) +
  # geom_text(x=0.5, y=115000, label="Scatter plot") +
  # stat_compare_means(ref.group = "PS", label = "p.format",label.y = c(15900)) +
  # stat_compare_means(ref.group = "ECT-GS", label = "p.format",label.y = c(15000)) +
  # scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # ggtitle(title) +
  scale_y_continuous("Genetic mean") +
  scale_x_discrete("Program") +
  optns +
  theme(axis.text.x = element_text(angle = 25, vjust = 1, hjust=1))
ggsave(filename = paste("PlotProgress/Gain_boxplot_Seed.png"), plot = a1, width = 15, height = 5, scale = 1.1)

####################################################################
# Genetic gain - ECT stage
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(meanECT),
             se = sd(meanECT)/sqrt(length(nReps)))

a2 <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  # scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
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
ggsave(filename = paste("PlotProgress/Gain_ECT.png"), plot = a2, width = 5, height = 5, scale = 1.1)

####################################################################
# Genetic variance 
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(varSeed),
             se = sd(varSeed)/sqrt(length(nReps)))

b <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  # scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # geom_ribbon(aes(x=year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0)+
  # ggtitle("Genetic Gain") +
  # ggtitle(title) +
  scale_x_continuous("Year") +
  # scale_y_continuous("Genetic Gain",limits=c(0,20)) +
  scale_y_continuous("Genetic variance") +
  optns +
  theme(panel.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.2,0.17))
ggsave(filename = paste("PlotProgress/Variance.png"), plot = b, width = 5, height = 5, scale = 1.1)

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
  # scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
  # ggtitle(title) +
  scale_y_continuous("Genetic variance",limits = c(0,85000)) +
  scale_x_discrete("Program") +
  optns +
  theme(axis.text.x = element_text(angle = 25, vjust = 1, hjust=1))
ggsave(filename = paste("PlotProgress/Variance_boxplot.png"), plot = b1, width = 15, height = 5, scale = 1.1)

####################################################################
# Selection accuracy  - Seedlings stage
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(accSeed),
             se = sd(accSeed)/sqrt(length(nReps)))

c <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  # scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
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
ggsave(filename = paste("PlotProgress/Accuracy_Seed.png"), plot = c, width = 5, height = 5, scale = 1.1)

####################################################################
# Selection accuracy - ACT stage
temp = ddply(rawData,c("year","scenario"), summarize,
             mean = mean(accACT),
             se = sd(accACT)/sqrt(length(nReps)))

c1 <- ggplot(temp[temp$year >= 0,], aes(x = year,y = mean,color=scenario)) +
  geom_line(size = 1.3) + 
  geom_line(data = temp[temp$year >= 0 & temp$scenario == "PS",], aes(x = year, y = mean), size = 1.3) +
  # scale_colour_manual(values=colorPalette) +
  # scale_colour_manual(values=c("black",wes_palette("FantasticFox1")[2:5])) +
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
ggsave(filename = paste("PlotProgress/Accuracy_ACT.png"), plot = c1, width = 5, height = 5, scale = 1.1)

print(summary <- ggarrange(a,b,c, nrow = 1, ncol=3, common.legend = TRUE, legend="bottom"))
ggsave(filename = paste("PlotProgress/Summary.png"), plot = summary, width = 12, height = 4, scale = 1.1)
