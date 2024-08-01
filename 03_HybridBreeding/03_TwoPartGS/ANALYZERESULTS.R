# install.packages(pkgs = "dplyr")
library(package = "dplyr")

# Read in results
df <- bind_rows(readRDS(paste0(scenarioName,".rds")))
df2 <- bind_rows(readRDS(paste0(scenarioName,"_accPI.rds")))

# Plotting function
plot_results <- function(x, y, main, xlab, ylab, ylim = NULL, extra_plot_func = NULL) {
  plot(x, y, type = "l", main = main, xlab = xlab, ylab = ylab, col = "blue", lwd = 2, ylim = ylim)
  grid(nx = NA, ny = NULL, lty = 6, col = "gray90")
  if (!is.null(extra_plot_func)) extra_plot_func()
}

# Plot
png("Results.png", height = 1600, width = 900, res = 150) # Higher resolution
par(mfrow = c(4, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

# Inbred Genetic Gain
plot_results(1:nCycles, rowMeans(matrix(df$meanG_inbred, ncol = max(df$rep))), 
             "Inbred genetic gain", "Year", "Yield")

# Hybrid Genetic Gain
plot_results(1:nCycles, rowMeans(matrix(df$meanG_hybrid, ncol = max(df$rep))), 
             "Hybrid genetic gain", "Year", "Yield")

# Inbred Variance
plot_results(1:nCycles, rowMeans(matrix(df$varG_inbred, ncol = max(df$rep))), 
             "Inbred genetic variance", "Year", "Variance")

# Hybrid Variance
plot_results(1:nCycles, rowMeans(matrix(df$varG_hybrid, ncol = max(df$rep))), 
             "Hybrid genetic variance", "Year", "Variance")

# Selection accuracy in Product Development
plot_results(1:nCycles, rowMeans(matrix(df$acc_sel, ncol = max(df$rep))), 
             "Selection accuracy in Product Development", "Year", "Accuracy")

# Selection accuracy in Population Improvement
plot_results(1:nCycles, rowMeans(matrix(df2$accPI, ncol = max(df$rep))), 
             "Selection accuracy in Population Improvement", "Cycle", "Accuracy", 
             extra_plot_func = function() {
               axis(1, at = seq(0, nCycles, 10), labels = seq(0, 20, 5))
               abline(v = seq(1, 41, 2), col = "gray80", lty = 2)
             })

# Correlation
plot_results(1:nCycles, rowMeans(matrix(df$cor, ncol = max(df$rep))), 
             "Inbred vs. hybrid yield cor.", "Year", "Correlation")

dev.off()
