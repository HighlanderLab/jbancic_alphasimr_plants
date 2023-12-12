# Load packages
rm(list = ls())
require(readr)
require(reshape2)
require(ggplot2)
require(ggpubr)

# Specify ggplot theme options
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


#Read in results
nReps = 10
df.pheno <- read_csv("Results_LinePheno.csv")
df.GS    <- read_csv("Results_LineGS_const.csv")
df.GSun  <- read_csv("Results_LineGS_unconst.csv")
temp <- rbind(df.pheno,df.GS,df.GSun)
rm(df.pheno,df.GS,df.GSun)

# Melt variables
colnames(temp)[c(1,3)] <- c("Year","Scenario")
temp <- melt(temp,
             id.vars = c("Year", "rep", "Scenario"),
             measure.vars = c("meanG","varG","accSel"))

# Rename Scenarios
temp$Scenario <- recode_factor(temp$Scenario,
                               `LinePheno`      = "Pheno",
                               `LineGS_const`   = "GS-constrained",
                               `LineGS_unconst` = "GS-unconstrained")

# Plot genetic gain with one replicate
(a <- temp %>%
    filter((variable %in% c("meanG"))) %>%
    filter(rep == 5) %>%
    droplevels() %>% 
    ggplot(aes(x = Year, y = value)) +
    ggtitle("1 rep") +
    geom_line(aes(color = Scenario), linewidth = 0.8) +
    ylim(0,8) +
    ylab("Genetic gain") + 
    theme_optns) 

# Calculate means
temp <- temp %>%
  group_by(Year, Scenario, variable) %>%
  summarise(value = mean(value)) %>%
  droplevels

# Plot multiple reps
(b <- temp %>%
    filter((variable %in% c("meanG"))) %>%
    droplevels() %>% 
    ggplot(aes(x = Year, y = value)) +
    geom_line(aes(color = Scenario), linewidth = 0.8) +
    ggtitle("10 reps") +
    ylim(0,8) +
    ylab("Genetic gain") + 
    theme_optns) 

(c <- temp %>%
    filter((variable %in% c("varG"))) %>%
    droplevels() %>% 
    ggplot(aes(x = Year, y = value)) +
    geom_line(aes(color = Scenario), linewidth = 0.8) +
    ylab("Genetic variance") + 
    theme_optns)

(d <- temp %>%
    filter((variable %in% c("accSel"))) %>%
    droplevels() %>% 
    ggplot(aes(x = Year, y = value)) +
    geom_line(aes(color = Scenario), linewidth = 0.8) +
    ylab("Accuracy") + 
    theme_optns) 

(p <- ggarrange(a, b, c, d, nrow = 2, ncol = 2, 
                common.legend = T, legend = "bottom", align = "hv", heights = c(1,1,1,1)))
ggsave(plot = p, filename ="04_Figure.png", width = 4.5, height = 5, scale = 2)
