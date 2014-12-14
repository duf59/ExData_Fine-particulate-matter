# Setup ####

library(data.table)
library(lubridate)
library(ggplot2)

# Load the data ####

NEI <- as.data.table(readRDS("./data/summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS("./data/Source_Classification_Code.rds"))

# Question 3 ####
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
# variable, which of these four sources have seen decreases in emissions from 1999–2008 for
# Baltimore City? Which have seen increases in emissions from 1999–2008?

# Subset Baltimore data and aggregate Emissions by year & type
emissions.by.type <- NEI[fips == "24510" , list(Emissions = sum(Emissions)),
                                           by = list(year,type)]

# plot to PNG - using ggplot2 ####

png(file = "plot3.png", bg = "transparent", type = "cairo-png")

g <- ggplot(emissions.by.type, aes(year, Emissions/1e2))
g <- g + geom_point(aes(color = type), size = 3)
g <- g + facet_grid(type ~ . , scale = "free_y")
g <- g + geom_smooth(method=lm, aes(color = type), se = FALSE, fullrange=T)
g <- g + labs(title = expression("Total emissions of PM"[2.5] ~ "in Baltimore City"))
g <- g + labs(y = expression("Total emissions [10 "^{2}~" tons]"))
print(g)

dev.off()
