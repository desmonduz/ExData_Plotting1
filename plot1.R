#This script plots a histogram showing the frequency of global energy usage in set of kilowatt bands from 2007-02-01 to 2007-02-02. 

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

#open png device, set height and width
png("plot1.png", width=480,height=480)

#plot histogram
hist(df$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

#close png device
dev.off()