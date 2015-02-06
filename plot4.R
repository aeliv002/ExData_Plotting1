# This is locale for in windows
if (Sys.getenv("OS") == "Windows_NT"){
  Sys.setlocale("LC_ALL", "English")
} else{
  # If it is Linux. If Mac You have to add Locale Yourself.
  Sys.setlocale("LC_ALL", 'en_US.UTF-8')
}

# File location where file will be saved
fileNamePlot <- "plot4.png"

# Sets D/M/Y format when importing
setClass("dateDMY")
setAs("character","dateDMY", function(from) {as.Date(from, format="%d/%m/%Y")} )

# Read data
household.Power.Consumption.DF <- read.table(
  file="household_power_consumption.txt",
  header=TRUE,
  # This will select needed columns
  colClasses = c("dateDMY","character",rep("numeric",7)),
  na.strings = "?",
  sep=";")

neededDates <- c(
  as.Date("1/2/2007","%d/%m/%Y"), 
  as.Date("2/2/2007","%d/%m/%Y")
)

# Subsetting data.frame to have only needed dates.
household.Power.Consumption.Subset.DF <- subset(
  x= household.Power.Consumption.DF,
  subset= Date %in% neededDates
)

# concat date and time and create POSIXlt for new variable dateTime
household.Power.Consumption.Subset.DF <- 
  as.data.frame(
    list(
      dateTime = as.POSIXlt(
        strptime(
          paste(
            household.Power.Consumption.Subset.DF$Date,
            household.Power.Consumption.Subset.DF$Time
          ),
          "%Y-%m-%d %H:%M:%S"
        )
      ),
      globalActivePower   = household.Power.Consumption.Subset.DF$Global_active_power,
      globalReactivePower = household.Power.Consumption.Subset.DF$Global_reactive_power,
      voltage             = household.Power.Consumption.Subset.DF$Voltage,
      subMetering1        = household.Power.Consumption.Subset.DF$Sub_metering_1,
      subMetering2        = household.Power.Consumption.Subset.DF$Sub_metering_2,
      subMetering3        = household.Power.Consumption.Subset.DF$Sub_metering_3
    )
  )


# Code for saving to png file.
png(
  filename=fileNamePlot,
  width = 480, 
  height = 480)

par(mfrow=c(2,2))

# Plot1 
plot(
  x=household.Power.Consumption.Subset.DF$dateTime,
  y=household.Power.Consumption.Subset.DF$globalActivePower,
  type="l",
  ylab="Global Active Power (kilowatts)",
  xlab="")

# Plot2

plot(
  x=household.Power.Consumption.Subset.DF$dateTime,
  y=household.Power.Consumption.Subset.DF$voltage,
  type="l",
  ylab="Voltage",
  xlab="datetime")

# Plot3

lineColors <- c("black","red","blue")
legendNames <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")

plot(
  x=household.Power.Consumption.Subset.DF$dateTime,
  y=household.Power.Consumption.Subset.DF$subMetering1,
  type="l",
  ylab="Energy sub metering",
  xlab="",
  col=lineColors[1])

lines(
  x=household.Power.Consumption.Subset.DF$dateTime,
  y=household.Power.Consumption.Subset.DF$subMetering2, type="l",
  col=lineColors[2])

lines(
  x=household.Power.Consumption.Subset.DF$dateTime,
  y=household.Power.Consumption.Subset.DF$subMetering3, type="l",
  col=lineColors[3])

legend(
  "topright", 
  legendNames, 
  col=lineColors, 
  lty=1, bty="n");

# Plot4

plot(
  x=household.Power.Consumption.Subset.DF$dateTime,
  y=household.Power.Consumption.Subset.DF$globalReactivePower,
  type="l",
  ylab="Global_reactive_power",
  xlab="datetime")

dev.off()
