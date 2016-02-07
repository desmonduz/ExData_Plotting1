#This script plots 4 charts showing global active power, reactive power, voltage, submeter readings for the period from 2007-02-01 to 2007-02-02. 

####################################################

#loading required libraries

require("lubridate") #library for working with dates
require("sqldf") #sqlite tool for reading only required rows in file. This saves us from using more memory.

df=read.csv.sql("./data/powerConsum.txt", 
                header=T, 
                sep=";", #separator is semi-colon
                eol='\n', #row is denoted using new line
                sql="select * from file where Date in ('1/2/2007', '2/2/2007')") #specify sql to pick rows only from given dates

#replace ? with NA
df[df=="?"]=NA

#convert to date and time
df=transform(df, Date=dmy(Date), Time=hms(Time))

#creating new column FullDate which is the summation of Date and Time
df=transform(df, FullDate=Date+Time)

#open png device, set height and width
png("plot4.png", width=480, height=480)

#set up canvas grid to 2x2
par(mfrow=c(2,2))

#plot 1: global active power
plot(x=df$FullDate,y=df$Global_active_power, type='l', ylab="Global Active Power (kilowatts)",xlab="")

#plot 2: voltage
plot(x=df$FullDate,y=df$Voltage, type='l', ylab="Voltage",xlab="")

#plot 3: energy per submeter
plot(x=df$FullDate,y=df$Sub_metering_1, type='n', ylab="Energy sub metering",xlab="")
lines(x=df$FullDate,y=df$Sub_metering_1)
lines(x=df$FullDate,y=df$Sub_metering_2, col="red")
lines(x=df$FullDate,y=df$Sub_metering_3, col="blue")
legend("topright", legend=c("Submetering 1","Submetering 2","Submetering 3"), col=c("black", "red", "blue"), lwd=1, lty=1)

#plot 4: global reactive power
plot(x=df$FullDate,y=df$Global_reactive_power, type='l', ylab="Global Reactive Power",xlab="")

#close png device
dev.off()