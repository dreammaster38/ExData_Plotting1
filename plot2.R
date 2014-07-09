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
hpcData$Date <- dmy(hpcData$Date)
hpcData$DateTime <- ymd_hms(paste(hpcData$Date, hpcData$Time))

png("plot2.png", width=480, height=480)
plot(hpcData$DateTime, hpcData$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()