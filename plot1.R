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

#Create a png file in the working directory
png(filename = "plot1.png", width = 480, height = 480)

#Plot
hist(twoday_power$Global_active_power, main = "Global Active Power", col = "red", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")

#Turn off the graphic device
dev.off()
