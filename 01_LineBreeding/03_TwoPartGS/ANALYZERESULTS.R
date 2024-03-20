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
png("Results.png", height = 1200, width = 450, res = 150) # Higher resolution
par(mfrow = c(4, 1), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

# Genetic Gain
plot_results(1:nCycles, rowMeans(matrix(df$meanG, ncol = max(df$rep))), 
             "Genetic gain", "Year", "Yield")

# Genetic Variance
plot_results(1:nCycles, rowMeans(matrix(df$varG, ncol = max(df$rep))), 
             "Genetic variance", "Year", "Variance")

# Selection Accuracy in Product Development
plot_results(1:nCycles, rowMeans(matrix(df$accSel, ncol = max(df$rep))), 
             "Selection accuracy in Product Development", "Year", "Correlation")

# Selection Accuracy in Population Improvement
plot_results(1:nCycles, rowMeans(matrix(df2$accPI, ncol = max(df$rep))), 
             "Selection accuracy in Population Improvement", "Year", "Correlation", 
             extra_plot_func = function() {
               axis(1, at = seq(0, nCycles, 10), labels = seq(0, 20, 5))
               abline(v = seq(1, 41, 2), col = "gray80", lty = 2)
             })

dev.off()
