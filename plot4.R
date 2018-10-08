#Load the libraries
library(lubridate)
library(dplyr)


#Download and Unzip the data
if(!file.exists("household_power_consumption.zip"))
{
  url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "./household_power_consumption.zip")
}
if(file.exists("household_power_consumption.zip"))
{
  unzip("household_power_consumption.zip")
}

#Read the data and perform subsetting based on the two specified dates
power<-read.csv("household_power_consumption.txt", sep = ";", colClasses = c(rep("character",2), rep("numeric",7)), na.strings = "?")
twoday_power<- power %>% filter(Date %in% c("1/2/2007","2/2/2007"))

#Compbine Date and Time to a Date/Time format
dt<-with(twoday_power, paste(Date, Time))
dt<-dmy_hms(dt)

#Add a new Date/Time column
twoday_power<- twoday_power %>% mutate(Date_Time = dt)

#Create a png file in the working directory and initialize the graphic parameters
png(filename = "plot4.png", width = 480, height = 480)
par(mfcol = c(2,2))


#Plot
plot(twoday_power$Date_Time, twoday_power$Global_active_power, type = "l", xlab = "", ylab = "Global Activity Power")

#Plot
with(twoday_power, plot(Date_Time, Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = ""))
with(twoday_power, lines(Date_Time, Sub_metering_1))
with(twoday_power, lines(Date_Time, Sub_metering_2, col = "red"))
with(twoday_power, lines(Date_Time, Sub_metering_3, col = "blue"))
legend("topright",col = c("black","red","blue"), lty = c(1,1,1), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty = "n")

#Plot
with(twoday_power, plot(Date_Time, Voltage, type = "l", xlab = "datetime"))

#Plot
with(twoday_power, plot(Date_Time, Global_reactive_power, type = "l", xlab = "datetime"))

#Turn off the graphic device
dev.off()
