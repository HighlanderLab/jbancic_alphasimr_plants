# install.packages(pkgs = "dplyr")
library(package = "dplyr")

# Read in results
df <- bind_rows(readRDS(paste0(scenarioName,".rds")))

# Plotting function
plot_results <- function(x, y, main, xlab, ylab, ylim = NULL, extra_plot_func = NULL) {
  plot(x, y, type = "l", main = main, xlab = xlab, ylab = ylab, col = "blue", lwd = 2, ylim = ylim)
  grid(nx = NA, ny = NULL, lty = 6, col = "gray90")
  if (!is.null(extra_plot_func)) extra_plot_func()
}

# Plot
png("Results.png", height = 1200, width = 900, res = 150) # Higher resolution
par(mfrow = c(3, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

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

# Selection accuracy
plot_results(1:nCycles, rowMeans(matrix(df$acc_sel, ncol = max(df$rep))), 
             "Selection accuracy", "Year", "Correlation")

# Correlation
plot_results(1:nCycles, rowMeans(matrix(df$cor, ncol = max(df$rep))), 
             "Inbred vs. hybrid yield cor.", "Year", "Correlation")

dev.off()
