# This is locale for time in windows
if (Sys.getenv("OS") == "Windows_NT"){
  Sys.setlocale("LC_ALL", "English")
} else{
# If it is Linux. If Mac You have to add Locale Yourself.
  Sys.setlocale("LC_ALL", 'en_US.UTF-8')
}

# File location where file will be saved
fileNamePlot <- "plot2.png"

# Sets D/M/Y format when importing
setClass("dateDMY")
setAs("character","dateDMY", function(from) {as.Date(from, format="%d/%m/%Y")} )

# Read only needed columns date and Global_active_power
household.Power.Consumption.DF <- read.table(
  file="household_power_consumption.txt",
  header=TRUE,
#   # This will only reads two colums
  colClasses = c("dateDMY","character","numeric",rep("NULL",6)),
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
      globalActivePower = household.Power.Consumption.Subset.DF$Global_active_power
    )
  )


# Code for saving to file plot1.png
png(
  filename=fileNamePlot,
  width = 480, 
  height = 480)

plot(
  household.Power.Consumption.Subset.DF,
  type="l",
  ylab="Global Active Power (kilowatts)",
  xlab="")

# Finalize the saving to file
dev.off()
