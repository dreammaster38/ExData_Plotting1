###
# Plot the Global Active Power in kilowatts ofelectric power consumption in households
###
library(lubridate)
library(dplyr)
# read data
hpcData <- read.table("data/household_power_consumption.txt", sep=";", head=TRUE, na.strings="?", stringsAsFactors=FALSE)

# create date representations from the given dates to filter on
startYear <- dmy("01/02/2007")
endYear <- dmy("02/02/2007")

# filter the consumption data to examine only the data between 01/02/2007 and 02/02/2007
hpcData <- filter(hpcData, (dmy(Date) >= startYear & dmy(Date) <= endYear))

png("plot1.png", width=480, height=480)
# create a histogram of the Global Active Power in kilowatts
# and write a PNG to disk
hist(hpcData$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()