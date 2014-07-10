###
# Plot 4 diagrams of electric power consumption for one household over 2 days
# into one image
# contained diagrams are:
# * Top left: Global Active Power (in kilowatts) over a period of 2 days
# * Bottom left: All three Sub metering parameters (in watt-hour of active energy) in one plot
# * Top right: Voltage (in V) over a period of 2 days
# * Bottom right: Global reactive power (in kilowatts) over a period of 2 days
###
library(lubridate)
library(dplyr)

# define some variables for later use
mainDir <- getwd()
subDir <- "data"
filePath <- ""
dataDir <- paste(mainDir, subDir, sep = "/")
pathToConsumptionTxtFile <- "household_power_consumption.txt"
pathToConsumptionZipFile <- "household_power_consumption.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

###
# try to download the ZIPed data file from the given url
# and save it in adirectory if it not already exists
# @TODO: maybe create a little module which
# can easiely included for later use...
###

# check if directory exists to save the data file
if (!file.exists(dataDir)) {
  # if it not exists create it
  dir.create(file.path(mainDir, subDir))
}

# does the data file household_power_consumption.txt exists in the directory above?
if(!file.exists(paste(dataDir, pathToConsumptionTxtFile, sep = "/"))) {
  # no, so download the ZIP from url specified above
  zipFilePath <- paste(dataDir, pathToConsumptionZipFile, sep = "/")
  download.file(fileUrl, destfile=zipFilePath)
  # and unzip the data file
  unzip(zipFilePath, exdir=dataDir, overwrite=TRUE)
  # remove the ZIP, it's no longer needed
  file.remove(zipFilePath)
  # save the path to the data file in a variable for later use
  filePath <- paste(dataDir, pathToConsumptionTxtFile, sep = "/")
} else {
  # the data file already exists,
  # so save the path to the data file in a variable for later use
  filePath <- paste(dataDir, pathToConsumptionTxtFile, sep = "/")
}

# read data from the constructed file path
# NA strings are marked with '?'
hpcData <- read.table(filePath, sep=";", head=TRUE, na.strings="?", stringsAsFactors=FALSE)

# create date representations from the given dates to filter on
startYear <- dmy("01/02/2007")
endYear <- dmy("02/02/2007")

# filter the consumption data to examine only the data between 01/02/2007 and 02/02/2007
hpcData <- filter(hpcData, (dmy(Date) >= startYear & dmy(Date) <= endYear))
hpcData$Date <- dmy(hpcData$Date)
hpcData$DateTime <- ymd_hms(paste(hpcData$Date, hpcData$Time))

# Combine 4 plots into one plot and save it as plot4.png
png("plot4.png", width=480, height=480)
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

# plot Global Active Power
plot(hpcData$DateTime,
     hpcData$Global_active_power,
     type="l",
     xlab="",
     ylab="Global Active Power")

# plot Voltage
plot(hpcData$DateTime,
     hpcData$Voltage,
     type="l",
     xlab="datetime",
     ylab="Voltage")

# plot Energy sub metering
plot(hpcData$DateTime,
     hpcData$Sub_metering_1,
     type="l",
     xlab="",
     ylab="Energy sub metering")

lines(hpcData$DateTime,
      hpcData$Sub_metering_2,
      col="red")
lines(hpcData$DateTime,
      hpcData$Sub_metering_3,
      col="blue")

legend("topright",
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd=2,
       lty=1,
       bty="n",
       col=c("black", "red", "blue"))

# plot Global Reactive Power
plot(hpcData$DateTime,
     hpcData$Global_reactive_power,
     type="l",
     xlab="datetime",
     ylab="Global_reactive_power")

dev.off()