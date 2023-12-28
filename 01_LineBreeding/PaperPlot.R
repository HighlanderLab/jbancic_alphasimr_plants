
# ---- Clean environment and load packages ----

rm(list = ls())
# install.packages(pkgs = c("readr", "reshape2", "ggplot2", "ggpubr"))
library(package = "readr")
library(package = "reshape2")
library(package = "ggplot2")
library(package = "ggpubr")

# ---- Specify ggplot theme options ----

theme_optns <- theme_bw(base_size = 16, base_family = "sans") +
  theme(panel.background = element_blank(),
        # legend.title = element_blank(),
        legend.title = element_text(size = 14, face = "bold"),
        legend.text  = element_text(size = 14),
        legend.position = "right",
        plot.title = element_text(size = 15, face = "bold"),
        axis.text  = element_text(size = 14,colour = "black"),
        axis.title = element_text(size = 18),
        # axis.title.x = element_blank(),
        axis.text.x  = element_text(hjust = .9, angle = 45),
        strip.text   = element_text(face = "bold", size = 18, colour = 'black'))

# ---- Read in and organise results ----

nReps = 10
df.pheno <- read_csv("Results_LinePheno.csv")
df.GS    <- read_csv("Results_LineGS_const.csv")
df.GSun  <- read_csv("Results_LineGS_unconst.csv")
temp <- rbind(df.pheno,df.GS,df.GSun)
rm(df.pheno,df.GS,df.GSun)

# Organise data
colnames(temp)[c(1,3)] <- c("Year","Scenario")
temp <- melt(temp,
             id.vars = c("Year", "rep", "Scenario"),
             measure.vars = c("meanG","varG","accSel"))

# Rename Scenarios
temp$Scenario <- recode_factor(temp$Scenario,
                               `LinePheno`      = "Pheno",
                               `LineGS_const`   = "GS-constrained",
                               `LineGS_unconst` = "GS-unconstrained")
temp0 <- temp

# ---- Plot results ----

#### Plot genetic gain of each replicate in the burnin phase ####

temp$paste <- factor(paste0(temp$rep,temp$Scenario))
mean <- temp %>%
  group_by(Year, Scenario, variable) %>%
  summarise(value = mean(value)) %>%
  filter((variable %in% c("meanG"))) %>%
  droplevels
mean$paste <- factor(paste0(mean$rep,mean$Scenario))
(a <- temp %>%
    filter((variable %in% c("meanG"))) %>%
    droplevels() %>%
    ggplot(aes(x = Year, y = value, group = paste)) +
    geom_line(aes(color = Scenario), linewidth = 0.6, alpha = 0.2) +
    geom_line(data = mean, aes(group = paste), linewidth = 0.8) +
    ylim(-0.1,5) +
    xlim(0,20) +
    ggtitle("Burn-in phase") +
    ylab("Genetic gain") +
    theme_optns +
    guides(color = guide_legend(override.aes = list(linewidth = 1, alpha = 1))))

#### Plot genetic gain of each replicate in the future phase ####

# First center data to year 20
for(i in 1:10){
  mean = temp$value[temp$rep == i & temp$Year == 20 & temp$variable == "meanG"]
  center = temp$value[temp$rep == i & temp$variable == "meanG"] - mean
  temp$value[temp$rep == i & temp$variable == "meanG"] = center
}
# Plot
(b1 <- temp %>%
    filter((variable %in% c("meanG"))) %>%
    droplevels() %>%
    ggplot(aes(x = Year, y = value, group = paste)) +
    geom_line(aes(color = Scenario), linewidth = 0.6, alpha = 0.2) +
    # scale_color_manual(values = c("blue","red","orange")) +
    ylim(0,5) +
    xlim(20,40) +
    ggtitle("Future phase") +
    ylab("Genetic gain") +
    theme_optns)

# Calculate means
temp <- temp %>%
  group_by(Year, Scenario, variable) %>%
  summarise(value = mean(value)) %>%
  droplevels

# Plot multiple reps
temp$paste <- factor(temp$Scenario)

# Genetic gain in future phase
(b2 <- b1 +
    geom_line(data = temp %>% filter((variable %in% c("meanG"))) %>% droplevels(),
              aes(x = Year, y = value, color = Scenario), linewidth = 0.8))

# Genetic variance
(c <- temp %>%
    filter((variable %in% c("varG"))) %>%
    droplevels() %>%
    ggplot(aes(x = Year, y = value)) +
    geom_line(aes(color = Scenario), linewidth = 0.8) +
    ylab("Genetic variance") +
    theme_optns)

# Selection accuracy
(d <- temp %>%
    filter((variable %in% c("accSel"))) %>%
    droplevels() %>%
    ggplot(aes(x = Year, y = value)) +
    geom_line(aes(color = Scenario), linewidth = 0.8) +
    ylab("Accuracy") +
    theme_optns)

#### Merge plots and save ####

(p <- ggarrange(a, b2, c, d, nrow = 2, ncol = 2,
                common.legend = T, legend = "bottom", align = "hv", heights = c(1,1,1,1)))
ggsave(plot = p, filename ="05_Figure.png", width = 4.5, height = 5, scale = 2)

# ---- Pair-wise comparison test ----

# Comparison constrained GS to Pheno
t.test(temp0[with(temp0,Scenario == "Pheno" & Year == 40 & variable == "meanG"),]$value,
       temp0[with(temp0,Scenario == "GS-constrained" & Year == 40 & variable == "meanG"),]$value,
       paired = T)[3] # 0.0004196465

# Comparison unconstrained GS to Pheno
t.test(temp0[with(temp0,Scenario == "Pheno" & Year == 40 & variable == "meanG"),]$value,
       temp0[with(temp0,Scenario == "GS-unconstrained" & Year == 40 & variable == "meanG"),]$value,
       paired = T)[3] # 6.652575e-05

# Comparison constrained GS to unconstrained GS
t.test(temp0[with(temp0,Scenario == "GS-constrained" & Year == 40 & variable == "meanG"),]$value,
       temp0[with(temp0,Scenario == "GS-unconstrained" & Year == 40 & variable == "meanG"),]$value,
       paired = T)[3] # 0.7701437
