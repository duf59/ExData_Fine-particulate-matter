# Setup ####

library(data.table)
library(lubridate)
library(ggplot2)

# Load the data ####

NEI <- as.data.table(readRDS("./data/summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS("./data/Source_Classification_Code.rds"))

# Question 6 ####
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?

# get motor vehicle sources (We considers this corresponds to EI.Sector containing "On-road")
motor.vehicles.sources <- grep("On-Road",levels(SCC$EI.Sector), value = TRUE)

# merge datasets
SCC.vehicle <- SCC[EI.Sector %in% motor.vehicles.sources,
                   list(SCC = as.character(SCC), EI.Sector = EI.Sector)]
SCC.vehicle$EI.Sector <- factor(SCC.vehicle$EI.Sector)  # drop unused factor levels
setkey(NEI, SCC)
setkey(SCC.vehicle,SCC)
NEI.with.EI.sector <- merge(NEI,SCC.vehicle)

# Subset Baltimore data and aggregate Emissions by year
vehicle.emissions <- NEI.with.EI.sector[fips %in% c("24510","06037"), list(Emissions = sum(Emissions)),
                                        by = list(year,fips)]
# Add a variable "location"
vehicle.emissions <- vehicle.emissions[, location := ifelse(fips == "24510", "Baltimore", "Los Angeles")]

# plot to PNG - using ggplot2 ####

png(file = "plot6.png", bg = "transparent", type = "cairo-png")


g <- ggplot(vehicle.emissions, aes(year, Emissions/1e2))
g <- g + geom_point(aes(color = location), size = 3)
g <- g + labs(title = expression("Total emissions of PM"[2.5] ~ "from motor vehicle sources"))
g <- g + labs(y = expression("Total emissions [10 "^{2}~" tons]"))
g <- g + geom_smooth(aes(color = location), method=lm, fullrange=T)
print(g)

dev.off()
