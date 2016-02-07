#This script plots a line graph showing the global energy usage in kilowatts from 2007-02-01 to 2007-02-02. 

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
png("plot2.png", width=480, height=480)

#plot line graph
plot(x=df$FullDate,y=df$Global_active_power, type='l', ylab="Global Active Power (kilowatts)",xlab="")

#close png device
dev.off()