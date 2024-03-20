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
png("Results.png", height = 1200, width = 450, res = 150) # Higher resolution
par(mfrow = c(3, 1), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

# Genetic Gain
plot_results(1:nCycles, rowMeans(matrix(df$meanG, ncol = max(df$rep))), 
             "Genetic gain", "Year", "Yield")

# Genetic Variance
plot_results(1:nCycles, rowMeans(matrix(df$varG, ncol = max(df$rep))), 
             "Genetic variance", "Year", "Variance")

# Selection Accuracy
plot_results(1:nCycles, rowMeans(matrix(df$accSel, ncol = max(df$rep))), 
             "Selection accuracy", "Year", "Correlation")

dev.off()
