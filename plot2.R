# Setup ####

library(data.table)
library(lubridate)


# Load the data ####

NEI <- as.data.table(readRDS("./data/summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS("./data/Source_Classification_Code.rds"), stringsAsFactors = FALSE)

# Question 2 ####
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
# from 1999 to 2008?

# Subset Baltimore data and aggregate Emissions by year
baltimore.emissions <- NEI[fips == "24510", list(Emissions = sum(Emissions)), by = year]

# plot to PNG - using base plotting system ####

png(file = "plot2.png", bg = "transparent", type = "cairo-png")

par(mar = c(5,5,4,2)) # extend left margin otherwise y label is cropped
with(baltimore.emissions, plot(year, Emissions/1e2, 
                              main = expression("Total emissions of PM"[2.5] ~ "in Baltimore City"),
                              ylab = expression("Total emissions [10 "^{2}~"tons]")))
with(baltimore.emissions,abline(lm(Emissions/1e2 ~ year)))

dev.off()
