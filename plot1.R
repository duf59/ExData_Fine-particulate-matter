# Setup ####

library(data.table)
library(lubridate)

# Load the data ####

NEI <- as.data.table(readRDS("./data/summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS("./data/Source_Classification_Code.rds"), stringsAsFactors = FALSE)

# Question 1 ####
# Have total emissions from PM2.5 decreased in the US from 1999 to 2008 ?

# Aggregate Emissions by year (for all data)
total.emissions <- NEI[, list(Emissions = sum(Emissions)), by = year]

# plot to PNG - using base plotting system ####

png(file = "plot1.png", bg = "transparent", type = "cairo-png")

par(mar = c(5,5,4,2)) # extend left margin otherwise y label is cropped
with(total.emissions, plot(year, Emissions/1e6, 
                              main = expression("Total emissions of PM"[2.5] ~ "per year"),
                              ylab = expression("Total emissions [10 "^{6}~"tons]")))
with(total.emissions,abline(lm(Emissions/1e6 ~ year)))

dev.off()
