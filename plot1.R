# File location where file will be saved
fileNamePlot <- "plot1.png"

# Set D/M/Y format when importing
setClass("dateDMY")
setAs("character","dateDMY", function(from) {as.Date(from, format="%d/%m/%Y")} )

# Read only needed columns (date and Global_active_power)
household.Power.Consumption.DF <- read.table(
                                      file="household_power_consumption.txt",
                                      header=TRUE,
                                      # This will only select two colums
                                      colClasses = c("dateDMY","NULL","numeric",rep("NULL",6)),
                                      na.strings = "?",
                                      sep=";")

neededDates <- c(
                  as.Date("1/2/2007","%d/%m/%Y"), 
                  as.Date("2/2/2007","%d/%m/%Y")
                )

# Data for histogram
household.Power.Consumption.Subset.DF <- subset(
                                            x= household.Power.Consumption.DF,
                                            subset= Date %in% neededDates)

# Code for saving to png file
png(
    filename=fileNamePlot,
    width = 480, 
    height = 480)

hist(
  household.Power.Consumption.Subset.DF$Global_active_power,
  col="red", 
  main="Global Active Power", 
  xlab="Global Active Power (kilowatts)")

dev.off()
