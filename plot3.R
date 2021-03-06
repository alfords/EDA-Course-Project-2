# data preparation
# setting directory
wd="C:\\Users\\aazhang\\workspace\\R\\EDA Project 2"
setwd(wd)

Url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# create directory if they do not exists
if(!file.exists("./data")){dir.create("./data")}
if(!file.exists("./figure")){dir.create("./figure")}

# check if data exists. If not download it.
if(!file.exists("./data/FNEI.zip")){
    Url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(Url,destfile="./data/FNEI.zip", mode = "wb", method="auto") 
}

# list of files in zip
SCCfile  <- "Source_Classification_Code.rds"
PM25file <- "summarySCC_PM25.rds"

# unzip and caching the result
if(!file.exists(paste("./data", SCCfile,  sep="/"))){unzip("./data/FNEI.zip", files=SCCfile,  exdir="./data" )}
if(!file.exists(paste("./data", PM25file, sep="/"))){unzip("./data/FNEI.zip", files=PM25file, exdir="./data" )}


# question 3
# Of the 4 types of sources indicated by type variables these sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question. 

# read files
SCC  <- readRDS(paste("./data", SCCfile,  sep="/"))
NEI  <- readRDS(paste("./data", PM25file, sep="/"))

library(plyr)
NEI.Balt <- NEI[NEI$fips=="24510",]
em2.Balt <- ddply(NEI.Balt, .(year, type), summarise, TotalEmissions = sum(Emissions))

# plotting
png(filename="./figure/plot3.png",  width= 480, height = 480)
library(ggplot2)
par(mfrow = c(1, 1), bg="transparent")
print(qplot(year, TotalEmissions, facets=.~type, geom=c("line"), data=em2.Balt,
      main= "Total PM2.5 emissions in Baltimore by type", ylab="Total Emissions (Tons)"))#+theme_bw()

dev.off()
