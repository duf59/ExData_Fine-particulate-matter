# Setup ####

library(data.table)
library(lubridate)
library(ggplot2)

# Load the data ####

NEI <- as.data.table(readRDS("./data/summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS("./data/Source_Classification_Code.rds"))

# Question 4 ####
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# get coal combustion-related sources (we consider the EI.Sectors containing "coal")
coal.sources <- grep("coal",levels(SCC$EI.Sector), value = TRUE, ignore.case = TRUE)

# merge datasets
SCC.coal <- SCC[EI.Sector %in% coal.sources, list(SCC = as.character(SCC), EI.Sector = EI.Sector)]
SCC.coal$EI.Sector <- factor(SCC.coal$EI.Sector)  # drop unused factor levels
setkey(NEI, SCC)
setkey(SCC.coal,SCC)
NEI.with.EI.sector <- merge(NEI,SCC.coal)

# aggregate emissions by year
coal.emissions <- NEI.with.EI.sector[, list(Emissions = sum(Emissions)),
                                     by = list(year)]

# plot to PNG - using ggplot2 ####

png(file = "plot4.png", bg = "transparent", type = "cairo-png") # default size is 480*480

g <- ggplot(coal.emissions, aes(year, Emissions/1e5))
g <- g + geom_point(size = 5)
g <- g + labs(title = expression("Total emissions of PM"[2.5] ~ "from coal combustion"))
g <- g + labs(y = expression("Total emissions [10 "^{5}~" tons]"))
g <- g + geom_smooth(method=lm, fullrange=T)
print(g)

dev.off()
