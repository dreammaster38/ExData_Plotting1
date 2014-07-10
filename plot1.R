###
# Plot a hiostogram of the Global Active Power
# of electric power consumption for one household over 2 days
# measured in in kilowatts
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

# create date representations from the given 2 days, used for filtering
startYear <- dmy("01/02/2007")
endYear <- dmy("02/02/2007")

# filter the consumption data to examine only the data between 01/02/2007 and 02/02/2007
hpcData <- filter(hpcData, (dmy(Date) >= startYear & dmy(Date) <= endYear))
hpcData$Date <- dmy(hpcData$Date)
hpcData$DateTime <- ymd_hms(paste(hpcData$Date, hpcData$Time))

# save the histogram as PNG file
png("plot1.png", width=480, height=480)
# create a histogram of the Global Active Power in kilowatts
# and write a PNG to disk
hist(hpcData$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()